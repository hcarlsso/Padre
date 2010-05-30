#!/usr/bin/perl

# Create and test the task manager

use strict;
use warnings;
use Test::More tests => 14;
use Test::NoWarnings;
use Padre::Logger ':ALL';
use Time::HiRes               ();
use Padre::Wx                 ();
use Padre::Wx::App            ();
use Padre::Task2Manager       ();
use Padre::Task2::Addition    ();
use t::lib::Padre::NullWindow ();

sub order_is {
	
}





######################################################################
# Main Test Sequence

# We will need a running application so the main thread can
# receive events thrown from the child thread.
my $wxapp = Padre::Wx::App->new;
isa_ok( $wxapp, 'Padre::Wx::App' );

# We also need a main window of some kind to handle events
my $window = t::lib::Padre::NullWindow->new;
isa_ok( $window, 't::lib::Padre::NullWindow' );

my $manager = Padre::Task2Manager->new( conduit => $window );
isa_ok( $manager, 'Padre::Task2Manager' );

# Schedule the startup timer
Wx::Event::EVT_TIMER( $wxapp, Padre::Wx::ID_TIMER_POSTINIT, \&startup );
my $timer1 = Wx::Timer->new( $wxapp, Padre::Wx::ID_TIMER_POSTINIT );

# Schedule the failure timeout
Wx::Event::EVT_TIMER( $wxapp, Padre::Wx::ID_TIMER_LASTRESORT, \&timeout );
my $timer2 = Wx::Timer->new( $wxapp, Padre::Wx::ID_TIMER_LASTRESORT );

# Start the timers
$timer1->Start( 1,     1 );
$timer2->Start( 10000, 1 );





######################################################################
# Main Process

# We start with no threads
is( scalar(threads->list), 0, 'No threads' );

# Enter the wx loop
# $window->Show(1) if $window;
$wxapp->MainLoop;

# We end with no threads
is( scalar(threads->list), 0, 'No threads' );





######################################################################
# Basic Creation

sub startup {
	# Run the startup process
	ok( $manager->start, '->start ok' );
	Time::HiRes::sleep( 1 );
	is( scalar(threads->list), 3, 'Three threads exists' );

	# Create the sample task
	my $addition = Padre::Task2::Addition->new(
		x => 2,
		y => 3,
	);
	isa_ok( $addition, 'Padre::Task2::Addition' );

	# Schedule the task (which should trigger it's execution)
	ok( $manager->schedule($addition), '->schedule ok' );
	is( $addition->{prepare}, 1, '->{prepare} is false' );
	is( $addition->{run},     0, '->{run}     is false' );
	is( $addition->{finish},  0, '->{finish}  is false' );
}

sub timeout {
	# Run the shutdown process
	$timer1 = undef;
	$timer2 = undef;
	ok( $manager->stop, '->stop ok' );
	sleep(1);
	# $window->Show(0) if $window;
	$wxapp->ExitMainLoop;
}
