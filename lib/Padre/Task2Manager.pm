package Padre::Task2Manager;

use 5.008005;
use strict;
use warnings;
use Params::Util       ();
use Padre::Task2Handle ();
use Padre::Task2Thread ();
use Padre::Task2Worker ();
use Padre::Wx          ();

our $VERSION = '0.58';

# Set up the primary integration event
our $THREAD_SIGNAL : shared;
BEGIN {
	$THREAD_SIGNAL = Wx::NewEventType();
}

sub new {
	bless {
		workers => [ ], # All workers
		minimum => 2,   # Workers to launch at startup
		handles => { }, # Handles for all active tasks
		running => { }, # Mapping from tid back to parent handle
		queue   => [ ], # Pending tasks to run in FIFO order
	}, $_[0];
}

sub start {
	my $self = shift;
	foreach ( 0 .. $self->{minimum} - 1 ) {
		$self->start_child($_);
	}
	return 1;
}

sub start_child {
	my $self   = shift;
	my $master = Padre::Task2Thread->master;
	my $worker = Padre::Task2Worker->new->spawn;
	$self->{workers}->[$_[0]] = $worker;
	return 1;
}

sub stop {
	my $self = shift;
	Padre::Task2Thread->master->stop;
	foreach ( 0 .. $#{$self->{workers}} ) {
		$self->stop_child($_);
	}
	return 1;
}

sub stop_child {
	my $self = shift;
	delete( $self->{workers}->[$_[0]] )->stop;
	return 1;
}





######################################################################
# Task Management

sub schedule {
	my $self = shift;
	my $task = Params::Util::_INSTANCE(shift, 'Padre::Task');
	unless ( $task ) {
		die "Invalid task scheduled!"; # TO DO: grace
	}

	# Add to the queue of pending events
	push @{$self->{queue}}, $task;

	# Iterate the management run-loop
	$self->step;
}

sub step {
	my $self    = shift;
	my $queue   = $self->{queue};
	my $running = $self->{running};

	# Is there anything in the queue to run
	return unless @$queue;

	# Is there anywhere to run the task
	return unless $self->{minimum} > scalar @$running;

	# Fetch and prepare the next task
	my $task   = shift @$queue;
	my $handle = Padre::Task2Handle->new( $task );
	my $hid    = $handle->hid;

	# Run the pre-run step in the main thread
	unless ( $handle->prepare ) {
		die "Task ->prepare method failed";
	}

	# Mark the task as running
	$running->{$hid} = $handle;

}





######################################################################
# Signal Handling

sub on_signal {
	my $self  = shift;
	my $event = shift;

	# Deserialize and squelch bad messages
	my $frozen  = $event->GetData;
	my $message = Storable::thaw( \$frozen );
	unless ( ref $message eq 'ARRAY' ) {
		# warn("Unrecognised non-ARRAY message received by a thread");
		return;
	}

	# Fine the task handle for the task
	my $hid    = shift @$message;
	my $handle = $self->{handles}->{$hid};
	unless ( $handle ) {
		# warn("Received message for a task that is not running");
		return;
	}

	# Handle the special startup message
	my $method = shift @$message;
	if ( $method eq 'STARTED' ) {
		# Register the task as running
		$self->{running}->{$hid} = $handle;
		return;
	}

	# Any remaining task should be running
	unless ( $self->{running}->{$hid} ) {
		# warn("Received message for a task that is not running");
		return;
	}

	# Handle the special shutdown message
	if ( $method eq 'STOPPED' ) {
		# Remove from the running list to guarentee no more events
		# will be sent to the handle (and thus to the task)
		delete $self->{running}->{$hid};

		# Fire the post-process/cleanup finish method, passing in the
		# completed (and serialised) task object.
		$handle->on_stopped( @$message );

		# Remove from the task list to destroy the task
		delete $self->{task};
		return;
	}

	# Pass the message through to the handle
	$handle->on_message( $method, @$message );
}

1;

# Copyright 2008-2010 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
