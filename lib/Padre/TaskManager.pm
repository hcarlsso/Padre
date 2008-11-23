
package Padre::TaskManager;
use strict;
use warnings;

use threads;
use threads::shared;
use Thread::Queue;

require Padre;
use Padre::Task;
use Padre::Wx;
use Wx::Event qw(EVT_COMMAND EVT_CLOSE);

our $TASK_DONE_EVENT : shared = Wx::NewEventType;
our $REAP_TIMER;
our $SINGLETON;

sub new {
	my $class = shift;
        
	return $SINGLETON if defined $SINGLETON;

	my $self = $SINGLETON = bless {
		min_no_workers => 1,
		max_no_workers => 3,
		@_,
		workers => [],
		task_queue => undef,
	} => $class;

	my $mw = Padre->ide->wx->main_window;

	EVT_COMMAND($mw, -1, $TASK_DONE_EVENT, \&on_task_done_event);
	EVT_CLOSE($mw, \&on_close);
 
	$self->{task_queue} = Thread::Queue->new();

	# Set up a regular action for reaping dead workers
	# and setting up new workers
	if (not defined $REAP_TIMER) {
		# explicit id necessary to distinguish from startup-timer of the main window
		my $timerid = Wx::NewId();
		$REAP_TIMER = Wx::Timer->new( $mw, $timerid );
		Wx::Event::EVT_TIMER(
			$mw, $timerid, sub { $SINGLETON->reap(); },
		);
		$REAP_TIMER->Start( 2000, Wx::wxTIMER_CONTINUOUS  ); # in ms
	}
	#$self->setup_workers();

	return $self;
}

sub setup_workers {
	my $self = shift;
	my $mw = Padre->ide->wx->main_window;

	my $workers = $self->{workers};
	while (@$workers < $self->{min_no_workers}) {
		my $worker = threads->create(\&worker_loop, $mw, $self);
		push @{$workers}, $worker;
	}

	my $jobs_pending = $self->task_queue->pending();
	if (@$workers < $self->{max_no_workers} and $jobs_pending > 2*@$workers) {
		my $target = int($jobs_pending/2);
		$target = $self->{max_no_workers} if $target > $self->{max_no_workers};
		foreach (1..($target-@$workers)) {
			my $worker = threads->create(\&worker_loop, $mw, $self);
			push @{$workers}, $worker;
		}
	}

	return 1;
}

# join all dead threads and remove them from the list of threads in 
# the list of workers
sub reap {
	my $self = shift;
	my $workers = $self->{workers};

	my @active_or_waiting;

	foreach my $thread (@$workers) {
		if ($thread->joinable()) {
			$thread->join();
		} else {
			push @active_or_waiting, $thread;
		}
	}
	
	$self->{workers} = \@active_or_waiting;


	# kill the no. of workers that exceed the maximum
	# (however this may happen)
	# TODO: We should slowly reduce the no. threads to minimum
	# of not busy. But how can we check for idling threads?
	# => check the no. queued jobs.
	if (@active_or_waiting > $self->{max_no_workers}) {
		my $no_to_kill = scalar(@active_or_waiting) - $self->{max_no_workers};
		$self->task_queue->insert( 0, ("STOP") x $no_to_kill );

		# We don't actually need to wait for the soon-to-be-joinable threads
		# since reap should be called regularly.
		#while (threads->list(threads::running) >= $self->{max_no_workers}) {
		#  $_->join for threads->list(threads::joinable);
		#}
	}

	$self->setup_workers();

	return 1;
}

sub schedule {
	my $self = shift;
	my $process = shift;
	if (not ref($process) or not $process->isa("Padre::Task")) {
		die "Invalid task scheduled!"; # TODO: grace
	}

	# cleanup old threads and refill the pool
	$self->reap();

	$process->prepare();

	my $string;
	$process->serialize(\$string);
	$self->task_queue->enqueue( [ref($process), $string] );

	return 1;
}

sub cleanup {
	my $self = shift;

	# the nice way:
	my @workers = $self->workers;
	$self->task_queue->insert( 0, ("STOP") x scalar(@workers) );
	while (threads->list(threads::running) >= 1) {
		$_->join for threads->list(threads::joinable);
	}

	# TODO:
	# the hard way goes along the lines of
	# - detach
	# - then kill

	return 1;
}

###################
# Accessors

sub task_queue { $_[0]->{task_queue} }

sub workers {
	my $self = shift;
	return @{$self->{workers}};
}

###################
# Event Handlers

sub on_close {
	my ($mw, $event) = @_; @_ = (); # hack to avoid "Scalars leaked"

	# TODO/FIXME:
	# This should somehow get at the specific TaskManager object
	# instead of going through the Padre globals!
	Padre->ide->{task_manager}->cleanup();

	# TODO: understand cargo cult
	$event->Skip(1);
}

sub on_task_done_event {
	my ($mw, $event) = @_; @_ = (); # hack to avoid "Scalars leaked"
	my $frozen = $event->GetData;
	my $process = Padre::TaskManager->thaw_process($frozen);

	$process->finish();
	return();
}

##########################
# Worker thread main loop

sub worker_loop {
	my ($mw, $taskmanager) = @_;
	my $queue = $taskmanager->task_queue;
	require Storable;

	#warn threads->tid() . " -- Hi, I'm a thread.";

	while (my $task = $queue->dequeue ) {

		#warn threads->tid() . " -- got task.";

		return 1 if not ref($task) eq 'ARRAY';

		my $class = $task->[0];

		# GET THE PROCESS
		my $okay = eval "require $class";
		if (!$okay or $@) {
			warn "Could not load class $class for running background task, skipping. This is a severe error.";
			next;
		}
		my $process = $class->deserialize( \$task->[1] );
		
		# RUN
		$process->run();

		# FREEZE THE PROCESS AND PASS IT BACK
		my $thread_event = Wx::PlThreadEvent->new(-1, $TASK_DONE_EVENT, Padre::TaskManager->freeze_process($process) );
		Wx::PostEvent($mw, $thread_event);

		#warn threads->tid() . " -- done with task.";
	}
}


################################################################
# Utility functions for serializing processes with their classes

sub freeze_process {
	my $selfclass = shift;
	my $obj = shift;
	my $string;
	$obj->serialize(\$string);
	my $stuff = [ref($obj), $string];
	return Storable::freeze($stuff);
}

sub thaw_process {
	my $selfclass = shift;
	my $string = shift;
	my $stuff = Storable::thaw($string);
	my $class = $stuff->[0];

	my $okay = eval "require $class";
	if (!$okay or $@) {
		warn "Could not load Padre::Task subclass $class. This is a severe error.";
		return();
	}
	return $class->deserialize( \$stuff->[1] );
}

1;

