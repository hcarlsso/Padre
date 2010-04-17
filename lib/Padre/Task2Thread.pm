package Padre::Task2Thread;

# Cleanly encapsulated object for a thread that does work based 
# on packaged method calls passed via a shared queue.

use 5.008005;
use strict;
use warnings;
use threads;
use threads::shared;
use Thread::Queue 2.11;
use Carp         ();
use Scalar::Util ();
use Padre::Logger;

our $VERSION = '0.58';

# Worker id sequence, so identifiers will be available in objects
# across all instances and threads before the thread has been spawned.
# We map the worker ID to the thread id, once it exists.
my $SEQUENCE : shared = 0;
my %WID2TID  : shared = ();





######################################################################
# Constructor and Accessors
sub new {
	TRACE($_[0]) if DEBUG;
	bless {
		wid   => ++$SEQUENCE,
		queue => Thread::Queue->new,
	}, $_[0];
}

sub wid {
	TRACE($_[0]) if DEBUG;
	$_[0]->{wid};
}

sub queue {
	TRACE($_[0])          if DEBUG;
	TRACE($_[0]->{queue}) if DEBUG;
	$_[0]->{queue};
}





######################################################################
# Main Methods

sub spawn {
	TRACE($_[0]) if DEBUG;
	my $self = shift;

	# Spawn the object into the thread and enter the main runloop
	$WID2TID{ $self->{wid} } = threads->create(
		sub {
			$_[0]->run;
		},
		$self,
	)->tid;

	return $self;
}

sub tid {
	TRACE($_[0]) if DEBUG;
	$WID2TID{ $_[0]->{wid} };
}

sub thread {
	TRACE($_[0]) if DEBUG;
	threads->object( $_[0]->tid );
}

sub join {
	TRACE($_[0]) if DEBUG;
	$_[0]->thread->join;
}

sub is_thread {
	TRACE($_[0]) if DEBUG;
	$_[0]->tid == threads->self->tid
}

sub is_running {
	TRACE($_[0]) if DEBUG;
	$_[0]->thread->is_running;
}

sub is_joinable {
	TRACE($_[0]) if DEBUG;
	$_[0]->thread->is_joinable;
}

sub is_detached {
	TRACE($_[0]) if DEBUG;
	$_[0]->thread->is_detached;
}





######################################################################
# Parent Thread Methods

sub send {
	TRACE($_[0]) if DEBUG;
	my $self   = shift;
	my $method = shift;
	unless ( _CAN($self, $method) ) {
		die("Attempted to send message to non-existant method '$method'");
	}

	# Add the message to the queue
	$self->queue->enqueue( [ $method, @_ ] );

	return 1;
}





######################################################################
# Child Thread Methods

sub run {
	TRACE($_[0]) if DEBUG;
	my $self  = shift;
	my $queue = $self->queue;

	# Loop over inbound requests
	while ( my $message = $queue->dequeue ) {
		unless ( _ARRAY($message) ) {
			# warn("Message is not an ARRAY reference");
			next;
		}

		# Check the message type
		my $method = shift @$message;
		unless ( _CAN($self, $method) ) {
			# warn("Illegal message type");
			next;
		}

		# Hand off to the appropriate method.
		# Methods must return true, otherwise the thread
		# will abort processing and end.
		$self->$method(@$message) or last;
	}

	return;
}

# Cleans up running hosts and then returns false,
# which instructs the main loop to exit and return.
sub shutdown {
	TRACE($_[0]) if DEBUG;
	return 0;
}





######################################################################
# Support Methods

sub _ARRAY ($) {
	(ref $_[0] eq 'ARRAY' and @{$_[0]}) ? $_[0] : undef;
}

sub _CAN ($$) {
	(Scalar::Util::blessed($_[0]) and $_[0]->can($_[1])) ? $_[0] : undef;
}

1;
