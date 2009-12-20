package Padre::Action::Run;

# Actions for running the current document

=pod

=head1 NAME

Padre::Action::Run is a outsourced module. It creates Actions for
various options to run the current file.

=cut

use 5.008;
use strict;
use warnings;
use Padre::Action ();
use Padre::Current qw{_CURRENT};

our $VERSION = '0.52';

#####################################################################

sub new {
	my $class = shift;
	my $main  = shift;

	# Create the empty object as normal, it won't be used usually
	my $self = bless {}, $class;

	# Add additional properties
	$self->{main} = $main;

	# Script Execution
	Padre::Action->new(
		name         => 'run.run_document',
		need_editor  => 1,
		need_runable => 1,
		label        => Wx::gettext('Run Script'),
		comment      => Wx::gettext('Runs the current document and shows its output in the output panel.'),
		shortcut     => 'F5',
		need_file    => 1,
		menu_event   => sub {
			$_[0]->run_document;
			$_[0]->refresh_toolbar( $_[0]->current );
		},
	);

	Padre::Action->new(
		name         => 'run.run_document_debug',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Run Script (debug info)'),
		comment      => Wx::gettext( 'Run the current document but include ' . 'debug info in the output.' ),
		shortcut     => 'Shift-F5',
		menu_event   => sub {
			$_[0]->run_document(1); # Enable debug info
		},
	);

	Padre::Action->new(
		name       => 'run.run_command',
		label      => Wx::gettext('Run Command'),
		comment    => Wx::gettext('Runs a shell command and shows the output.'),
		shortcut   => 'Ctrl-F5',
		menu_event => sub {
			$_[0]->on_run_command;
		},
	);
	Padre::Action->new(
		name        => 'run.run_tdd_tests',
		need_file   => 1,
		need_editor => 1,
		label       => Wx::gettext('Build + run all Tests'),
		comment     => Wx::gettext('Builds the current project, then run all tests.'),
		shortcut    => 'Ctrl-Shift-F5',
		menu_event  => sub {
			$_[0]->on_run_tdd_tests;
		},
	);

	Padre::Action->new(
		name        => 'run.run_tests',
		need_editor => 1,
		need_file   => 1,
		label       => Wx::gettext('Run Tests'),
		comment     => Wx::gettext(
			'Run all tests for the current project or document and show the results in ' . 'the output panel.'
		),
		need_editor => 1,
		menu_event  => sub {
			$_[0]->on_run_tests;
		},
	);

	Padre::Action->new(
		name         => 'run.run_this_test',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		need         => sub {
			my %objects = @_;
			return 0 if !defined( $objects{document} );
			return 0 if !defined( $objects{document}->{file} );
			return $objects{document}->{file}->{filename} =~ /\.t$/;
		},
		label       => Wx::gettext('Run This Test'),
		comment     => Wx::gettext('Run the current test if the current document is a test.'),
		menu_event  => sub {
			$_[0]->on_run_this_test;
		},
	);

	Padre::Action->new(
		name => 'run.stop',
		need => sub {
			my %objects = @_;
			return $main->{command} ? 1 : 0;
		},
		label      => Wx::gettext('Stop execution'),
		comment    => Wx::gettext('Stop a running task.'),
		shortcut   => 'F6',
		menu_event => sub {
			if ( $_[0]->{command} ) {
				if (Padre::Constant::WIN32) {
					$_[0]->{command}->KillProcess;
				} else {
					$_[0]->{command}->TerminateProcess;
				}
			}
			delete $_[0]->{command};
			$_[0]->refresh_toolbar( $_[0]->current );
			return;
		},
	);


	Padre::Action->new(
		name         => 'debug.step_in',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Step In') . ' (&s) ',
		comment      => Wx::gettext('Run the current document through the Debug::Client.'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_step_in;
		},
	);

	Padre::Action->new(
		name         => 'debug.step_over',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Step Over') . ' (&n) ',
		comment      => Wx::gettext('Run the current document through the Debug::Client.'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_step_over;
		},
	);


	Padre::Action->new(
		name         => 'debug.step_out',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Step Out') . ' (&r) ',
		comment      => Wx::gettext('Run the current document through the Debug::Client.'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_step_out;
		},
	);

	Padre::Action->new(
		name         => 'debug.run',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Run till breakpoint') . ' (&c) ',
		comment      => Wx::gettext('Start running and/or continoue running till next breakpoint or watch'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_run;
		},
	);

	Padre::Action->new(
		name         => 'debug.jump_to',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Jump to current execution line'),
		comment      => Wx::gettext('Run'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_jumpt_to;
		},
	);

	Padre::Action->new(
		name         => 'debug.set_breakpoint',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Set breakpoint') . ' (&b) ',
		comment      => Wx::gettext('Set a breakpoint to the current location of the cursor with a condition'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_set_breakpoint;
		},
	);

	Padre::Action->new(
		name         => 'debug.remove_breakpoint',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Remove breakpoint'),
		comment      => Wx::gettext('Remove the breakpoint at the current location of the cursor'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_remove_breakpoint;
		},
	);

	Padre::Action->new(
		name         => 'debug.list_breakpoints',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('List all the breakpoints'),
		comment      => Wx::gettext('List all the breakpoints on the console'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_list_breakpoints;
		},
	);

	Padre::Action->new(
		name         => 'debug.run_to_cursor',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Run to cursor'),
		comment      => Wx::gettext('Run'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_run_to_cursor;
		},
	);


	Padre::Action->new(
		name         => 'debug.show_stack_trace',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Show Stack Trace') . ' (&T) ',
		comment      => Wx::gettext('Run the current document through the Debug::Client.'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_show_stack_trace;
		},
	);

	Padre::Action->new(
		name         => 'debug.display_value',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Display value'),
		comment      => Wx::gettext('Display the current value of a variable'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_display_value;
		},
	);

	Padre::Action->new(
		name         => 'debug.show_value',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Show Value') . ' (&x) ',
		comment      => Wx::gettext('Run the current document through the Debug::Client.'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_show_value;
		},
	);

	Padre::Action->new(
		name         => 'debug.evaluate_expression',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Evaluate Expression'),
		comment      => Wx::gettext('Run the current document through the Debug::Client.'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_evaluate_expression;
		},
	);

	Padre::Action->new(
		name         => 'debug.quit',
		need_editor  => 1,
		need_runable => 1,
		need_file    => 1,
		label        => Wx::gettext('Quit Debugger') . ' (&q) ',
		comment      => Wx::gettext('Run the current document through the Debug::Client.'),

		#shortcut     => 'Shift-F5',
		menu_event  => sub {
			$_[0]->{_debugger_}->debug_perl_quit;
		},
	);



	return $self;
}

1;

# Copyright 2008-2009 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
