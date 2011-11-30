package Padre::Wx::FBP::Debugger;

## no critic

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module edit the original .fbp file and regenerate.
# DO NOT MODIFY THIS FILE BY HAND!

use 5.008005;
use utf8;
use strict;
use warnings;
use Padre::Wx ();
use Padre::Wx::Role::Main ();

our $VERSION = '0.93';
our @ISA     = qw{
	Padre::Wx::Role::Main
	Wx::Panel
};

sub new {
	my $class  = shift;
	my $parent = shift;

	my $self = $class->SUPER::new(
		$parent,
		-1,
		Wx::DefaultPosition,
		[ 235, 530 ],
		Wx::TAB_TRAVERSAL,
	);

	$self->{debug} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{debug}->SetToolTip(
		Wx::gettext("Run Debug\nBLUE MORPHO CATERPILLAR \ncool bug")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{debug},
		sub {
			shift->on_debug_clicked(@_);
		},
	);

	$self->{step_in} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW | Wx::NO_BORDER,
	);
	$self->{step_in}->SetToolTip(
		Wx::gettext("s [expr]\nSingle step. Executes until the beginning of another statement, descending into subroutine calls. If an expression is supplied that includes function calls, it too will be single-stepped.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{step_in},
		sub {
			shift->on_step_in_clicked(@_);
		},
	);

	$self->{step_over} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW | Wx::NO_BORDER,
	);
	$self->{step_over}->SetToolTip(
		Wx::gettext("n [expr]\nNext. Executes over subroutine calls, until the beginning of the next statement. If an expression is supplied that includes function calls, those functions will be executed with stops before each statement.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{step_over},
		sub {
			shift->on_step_over_clicked(@_);
		},
	);

	$self->{step_out} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW | Wx::NO_BORDER,
	);
	$self->{step_out}->SetToolTip(
		Wx::gettext("r\nContinue until the return from the current subroutine. Dump the return value if the PrintRet option is set (default).")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{step_out},
		sub {
			shift->on_step_out_clicked(@_);
		},
	);

	$self->{run_till} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW | Wx::NO_BORDER,
	);
	$self->{run_till}->SetToolTip(
		Wx::gettext("c [line|sub]\nContinue, optionally inserting a one-time-only breakpoint at the specified line or subroutine.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{run_till},
		sub {
			shift->on_run_till_clicked(@_);
		},
	);

	$self->{display_value} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW | Wx::NO_BORDER,
	);
	$self->{display_value}->SetToolTip(
		Wx::gettext("Display Value")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{display_value},
		sub {
			shift->on_display_value_clicked(@_);
		},
	);

	$self->{quit_debugger} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW | Wx::NO_BORDER,
	);
	$self->{quit_debugger}->SetToolTip(
		Wx::gettext("Quit Debugger")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{quit_debugger},
		sub {
			shift->on_quit_debugger_clicked(@_);
		},
	);

	$self->{variables} = Wx::ListCtrl->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::LC_REPORT | Wx::LC_SINGLE_SEL,
	);
	$self->{variables}->SetMinSize( Wx::DefaultSize );

	$self->{show_local_variables} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Show Local Variables (y 0)"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);
	$self->{show_local_variables}->SetToolTip(
		Wx::gettext("y [level [vars]]\nDisplay all (or some) lexical variables (mnemonic: mY variables) in the current scope or level scopes higher. You can limit the variables that you see with vars which works exactly as it does for the V and X commands. Requires the PadWalker module version 0.08 or higher; will warn if this isn't installed. Output is pretty-printed in the same style as for V and the format is controlled by the same options.")
	);

	Wx::Event::EVT_CHECKBOX(
		$self,
		$self->{show_local_variables},
		sub {
			shift->on_show_local_variables_checked(@_);
		},
	);

	$self->{show_global_variables} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Show Global Variables"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);
	$self->{show_global_variables}->SetToolTip(
		Wx::gettext("working now with some gigery pokery to get around\nIntermitent Error, You can't FIRSTKEY with the %~ hash")
	);

	Wx::Event::EVT_CHECKBOX(
		$self,
		$self->{show_global_variables},
		sub {
			shift->on_show_global_variables_checked(@_);
		},
	);

	$self->{trace} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Trace"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);
	$self->{trace}->SetToolTip(
		Wx::gettext("t\nToggle trace mode (see also the AutoTrace option).")
	);

	Wx::Event::EVT_CHECKBOX(
		$self,
		$self->{trace},
		sub {
			shift->on_trace_checked(@_);
		},
	);

	$self->{dot} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{dot}->SetToolTip(
		Wx::gettext(".        Return to the executed line.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{dot},
		sub {
			shift->on_dot_clicked(@_);
		},
	);

	$self->{view_around} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{view_around}->SetToolTip(
		Wx::gettext("v [line]    View window around line.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{view_around},
		sub {
			shift->on_view_around_clicked(@_);
		},
	);

	$self->{list_action} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{list_action}->SetToolTip(
		Wx::gettext("L [abw]\nList (default all) actions, breakpoints and watch expressions")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{list_action},
		sub {
			shift->on_list_action_clicked(@_);
		},
	);

	$self->{running_bp} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{running_bp}->SetToolTip(
		Wx::gettext("Toggle running breakpoints (update DB)\nb\nSets breakpoint on current line\nB line\nDelete a breakpoint from the specified line.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{running_bp},
		sub {
			shift->on_running_bp_clicked(@_);
		},
	);

	$self->{module_versions} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{module_versions}->SetToolTip(
		Wx::gettext("M\nDisplay all loaded modules and their versions.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{module_versions},
		sub {
			shift->on_module_versions_clicked(@_);
		},
	);

	$self->{stacktrace} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{stacktrace}->SetToolTip(
		Wx::gettext("T\nProduce a stack backtrace.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{stacktrace},
		sub {
			shift->on_stacktrace_clicked(@_);
		},
	);

	$self->{all_threads} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{all_threads}->SetToolTip(
		Wx::gettext("E\nDisplay all thread ids the current one will be identified: <n>.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{all_threads},
		sub {
			shift->on_all_threads_clicked(@_);
		},
	);

	$self->{display_options} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{display_options}->SetToolTip(
		Wx::gettext("o\nDisplay all options.\n\no booloption ...\nSet each listed Boolean option to the value 1.\n\no anyoption? ...\nPrint out the value of one or more options.\n\no option=value ...\nSet the value of one or more options. If the value has internal whitespace, it should be quoted. For example, you could set o pager=\"less -MQeicsNfr\" to call less with those specific options. You may use either single or double quotes, but if you do, you must escape any embedded instances of same sort of quote you began with, as well as any escaping any escapes that immediately precede that quote but which are not meant to escape the quote itself. In other words, you follow single-quoting rules irrespective of the quote; eg: o option='this isn't bad' or o option=\"She said, \"Isn't it?\"\" .\n\nFor historical reasons, the =value is optional, but defaults to 1 only where it is safe to do so--that is, mostly for Boolean options. It is always better to assign a specific value using = . The option can be abbreviated, but for clarity probably should not be. Several options can be set together. See Configurable Options for a list of these.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{display_options},
		sub {
			shift->on_display_options_clicked(@_);
		},
	);

	$self->{m_staticline32} = Wx::StaticLine->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::LI_HORIZONTAL,
	);

	$self->{evaluate_expression} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{evaluate_expression}->SetToolTip(
		Wx::gettext("p expr \nSame as print {\$DB::OUT} expr in the current package. In particular, because this is just Perl's own print function.\n\nx [maxdepth] expr\nEvaluates its expression in list context and dumps out the result in a pretty-printed fashion. Nested data structures are printed out recursively,")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{evaluate_expression},
		sub {
			shift->on_evaluate_expression_clicked(@_);
		},
	);

	$self->{sub_names} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{sub_names}->SetToolTip(
		Wx::gettext("S [[!]regex]\nList subroutine names [not] matching the regex.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{sub_names},
		sub {
			shift->on_sub_names_clicked(@_);
		},
	);

	$self->{watchpoints} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{watchpoints}->SetToolTip(
		Wx::gettext("w expr\nAdd a global watch-expression. Whenever a watched global changes the debugger will stop and display the old and new values.\n\nW expr\nDelete watch-expression\nW *\nDelete all watch-expressions.")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{watchpoints},
		sub {
			shift->on_watchpoints_clicked(@_);
		},
	);

	$self->{raw} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{raw}->SetToolTip(
		Wx::gettext("Raw\nYou can enter what ever debug command you want!")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{raw},
		sub {
			shift->on_raw_clicked(@_);
		},
	);

	$self->{expression} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::DefaultPosition,
		[ 130, -1 ],
	);
	$self->{expression}->SetToolTip(
		Wx::gettext("Expression To Evaluate")
	);

	my $button_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$button_sizer->Add( $self->{debug}, 0, Wx::ALL, 1 );
	$button_sizer->Add( $self->{step_in}, 0, Wx::ALL, 5 );
	$button_sizer->Add( $self->{step_over}, 0, Wx::ALL, 5 );
	$button_sizer->Add( $self->{step_out}, 0, Wx::ALL, 5 );
	$button_sizer->Add( $self->{run_till}, 0, Wx::ALL, 5 );
	$button_sizer->Add( $self->{display_value}, 0, Wx::ALL, 5 );
	$button_sizer->Add( $self->{quit_debugger}, 0, Wx::ALL, 5 );

	my $checkbox_sizer = Wx::StaticBoxSizer->new(
		Wx::StaticBox->new(
			$self,
			-1,
			Wx::gettext("Show"),
		),
		Wx::VERTICAL,
	);
	$checkbox_sizer->Add( $self->{show_local_variables}, 0, Wx::ALL, 2 );
	$checkbox_sizer->Add( $self->{show_global_variables}, 0, Wx::ALL, 5 );

	my $bSizer11 = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$bSizer11->Add( $self->{trace}, 0, Wx::ALL, 5 );
	$bSizer11->Add( $self->{dot}, 0, Wx::ALL, 5 );
	$bSizer11->Add( $self->{view_around}, 0, Wx::ALL, 5 );
	$bSizer11->Add( $self->{list_action}, 0, Wx::ALL, 5 );

	my $option_button_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$option_button_sizer->Add( $self->{running_bp}, 0, Wx::ALL, 5 );
	$option_button_sizer->Add( $self->{module_versions}, 0, Wx::ALL, 5 );
	$option_button_sizer->Add( $self->{stacktrace}, 0, Wx::ALL, 5 );
	$option_button_sizer->Add( $self->{all_threads}, 0, Wx::ALL, 5 );
	$option_button_sizer->Add( $self->{display_options}, 0, Wx::ALL, 5 );

	my $with_options = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$with_options->Add( $self->{evaluate_expression}, 0, Wx::ALL, 5 );
	$with_options->Add( $self->{sub_names}, 0, Wx::ALL, 5 );
	$with_options->Add( $self->{watchpoints}, 0, Wx::ALL, 5 );
	$with_options->Add( $self->{raw}, 0, Wx::ALL, 5 );

	my $expression = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$expression->Add( $self->{expression}, 1, Wx::ALL, 5 );

	my $debug_output_options = Wx::StaticBoxSizer->new(
		Wx::StaticBox->new(
			$self,
			-1,
			Wx::gettext("Debug-Output Options"),
		),
		Wx::VERTICAL,
	);
	$debug_output_options->Add( $bSizer11, 0, Wx::EXPAND, 5 );
	$debug_output_options->Add( $option_button_sizer, 0, Wx::EXPAND, 5 );
	$debug_output_options->Add( $self->{m_staticline32}, 0, Wx::EXPAND | Wx::ALL, 5 );
	$debug_output_options->Add( $with_options, 0, Wx::EXPAND, 5 );
	$debug_output_options->Add( $expression, 0, Wx::EXPAND, 5 );

	my $bSizer10 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer10->Add( $button_sizer, 0, Wx::EXPAND, 5 );
	$bSizer10->Add( $self->{variables}, 1, Wx::ALL | Wx::EXPAND, 5 );
	$bSizer10->Add( $checkbox_sizer, 0, Wx::EXPAND, 5 );
	$bSizer10->Add( $debug_output_options, 0, Wx::EXPAND, 5 );

	$self->SetSizer($bSizer10);
	$self->Layout;

	return $self;
}

sub trace {
	$_[0]->{trace};
}

sub expression {
	$_[0]->{expression};
}

sub on_debug_clicked {
	$_[0]->main->error('Handler method on_debug_clicked for event debug.OnButtonClick not implemented');
}

sub on_step_in_clicked {
	$_[0]->main->error('Handler method on_step_in_clicked for event step_in.OnButtonClick not implemented');
}

sub on_step_over_clicked {
	$_[0]->main->error('Handler method on_step_over_clicked for event step_over.OnButtonClick not implemented');
}

sub on_step_out_clicked {
	$_[0]->main->error('Handler method on_step_out_clicked for event step_out.OnButtonClick not implemented');
}

sub on_run_till_clicked {
	$_[0]->main->error('Handler method on_run_till_clicked for event run_till.OnButtonClick not implemented');
}

sub on_display_value_clicked {
	$_[0]->main->error('Handler method on_display_value_clicked for event display_value.OnButtonClick not implemented');
}

sub on_quit_debugger_clicked {
	$_[0]->main->error('Handler method on_quit_debugger_clicked for event quit_debugger.OnButtonClick not implemented');
}

sub on_show_local_variables_checked {
	$_[0]->main->error('Handler method on_show_local_variables_checked for event show_local_variables.OnCheckBox not implemented');
}

sub on_show_global_variables_checked {
	$_[0]->main->error('Handler method on_show_global_variables_checked for event show_global_variables.OnCheckBox not implemented');
}

sub on_trace_checked {
	$_[0]->main->error('Handler method on_trace_checked for event trace.OnCheckBox not implemented');
}

sub on_dot_clicked {
	$_[0]->main->error('Handler method on_dot_clicked for event dot.OnButtonClick not implemented');
}

sub on_view_around_clicked {
	$_[0]->main->error('Handler method on_view_around_clicked for event view_around.OnButtonClick not implemented');
}

sub on_list_action_clicked {
	$_[0]->main->error('Handler method on_list_action_clicked for event list_action.OnButtonClick not implemented');
}

sub on_running_bp_clicked {
	$_[0]->main->error('Handler method on_running_bp_clicked for event running_bp.OnButtonClick not implemented');
}

sub on_module_versions_clicked {
	$_[0]->main->error('Handler method on_module_versions_clicked for event module_versions.OnButtonClick not implemented');
}

sub on_stacktrace_clicked {
	$_[0]->main->error('Handler method on_stacktrace_clicked for event stacktrace.OnButtonClick not implemented');
}

sub on_all_threads_clicked {
	$_[0]->main->error('Handler method on_all_threads_clicked for event all_threads.OnButtonClick not implemented');
}

sub on_display_options_clicked {
	$_[0]->main->error('Handler method on_display_options_clicked for event display_options.OnButtonClick not implemented');
}

sub on_evaluate_expression_clicked {
	$_[0]->main->error('Handler method on_evaluate_expression_clicked for event evaluate_expression.OnButtonClick not implemented');
}

sub on_sub_names_clicked {
	$_[0]->main->error('Handler method on_sub_names_clicked for event sub_names.OnButtonClick not implemented');
}

sub on_watchpoints_clicked {
	$_[0]->main->error('Handler method on_watchpoints_clicked for event watchpoints.OnButtonClick not implemented');
}

sub on_raw_clicked {
	$_[0]->main->error('Handler method on_raw_clicked for event raw.OnButtonClick not implemented');
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

