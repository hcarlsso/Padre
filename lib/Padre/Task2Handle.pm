package Padre::Task2Handle;

use 5.008005;
use strict;
use warnings;
use threads;
use threads::shared;
use Thread::Queue 2.11;
use Storable ();

our $VERSION  = '0.58';
our $SEQUENCE = 0;





######################################################################
# Constructor and Accessors

sub new {
	my $class = shift;
	my $self  = bless {
		hid  => ++$SEQUENCE,
		task => shift,
	}, $class;
	return $self;
}

sub hid {
	$_[0]->{hid};
}

sub task {
	$_[0]->{task};
}





######################################################################
# Parent Methods

sub prepare {
	my $self = shift;
	my $task = $self->{task};
	my $rv   = eval {
		$task->prepare;
	};
	if ( $@ ) {
		warn $@;
		return !1;
	}
	return !! $rv;
}

sub finish {
	my $self = shift;
	my $task = $self->{task};
	my $rv   = eval {
		$task->finish;
	};
	if ( $@ ) {
		warn $@;
		return !1;
	}
	return !! $rv;
}





######################################################################
# Worker Methods

sub run {
	my $self = shift;
	my $task = $self->task;

	# Create a circular reference back from the task
	$self->{handle} = $self;

	# Call the task's run method
	eval {
		$task->run();
	};

	# Save the exception if thrown
	$self->{exception} = $@ if $@;

	# Clean up the circular
	delete $self->{handle};

	return 1;
}





######################################################################
# Message Handling

# Serialize and pass-through to the Wx signal dispatch
sub message {
	Wx::App::GetInstance()->signal(
		Storable::freeze( [ shift->hid, @_ ] )
	);
}

sub on_message {
	my $self   = shift;
	my $method = shift;

	# Does the method exist
	unless ( $self->{task}->can($method) ) {
		# A method name provided directly by the Task
		# doesn't exist in the Task. Naughty Task!!!
		# Lacking anything more sane to do, squelch it.
		return;
	}

	# Pass the call down to the task and protect it from itself
	local $@;
	eval {
		$self->{task}->$method(@_);
	};
	if ( $@ ) {
		# A method in the main thread blew up.
		# Beyond catching it and preventing it killing
		# Padre entirely, I'm not sure what else we can
		# really do about it at this point.
		return;
	}

	return;
}

# Task startup handling
sub started {
	$_[0]->message( 'STARTED' );
}

# There is no on_stopped atm... not sure if it's needed.
# sub on_started { ... }

# Task shutdown handling
sub stopped {
	$_[0]->message( 'STOPPED', $_[0]->{task} );
}

sub on_stopped {
	my $self = shift;

	# The first parameter is the updated Task object.
	# Replace all content in the stored version with that from the
	# event-provided version.
	my $new  = shift;
	my $task = $self->{task};
	%$task = %$new;
	%$new  = ();

	# Execute the finish method in the updated Task object
	local $@;
	eval {
		$self->{task}->finish;
	};
	if ( $@ ) {
		# A method in the main thread blew up.
		# Beyond catching it and preventing it killing
		# Padre entirely, I'm not sure what else we can
		# really do about it at this point.
		return;
	}

	return;
}

1;

# Copyright 2008-2010 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
