package Padre::Plugin::Debug::FBP::MainFB;

## no critic

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module edit the original .fbp file and regenerate.
# DO NOT MODIFY THIS FILE BY HAND!

use 5.008;
use strict;
use warnings;
use Padre::Wx ();
use Padre::Wx::Role::Main ();

our $VERSION = '0.01';
our @ISA     = qw{
	Padre::Wx::Role::Main
	Wx::Dialog
};

sub new {
	my $class  = shift;
	my $parent = shift;

	my $self = $class->SUPER::new(
		$parent,
		-1,
		Wx::gettext("Debug Simulator"),
		Wx::DefaultPosition(),
		[ 360, 160 ],
		Wx::DEFAULT_DIALOG_STYLE() | Wx::RESIZE_BORDER(),
	);

	$self->{debug_output} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Debug Output"),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
	);

	Wx::Event::EVT_CHECKBOX(
		$self,
		$self->{debug_output},
		sub {
			shift->on_debug_output_clicked(@_);
		},
	);

	$self->{breakpoints} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Breakpoints"),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
	);

	Wx::Event::EVT_CHECKBOX(
		$self,
		$self->{breakpoints},
		sub {
			shift->on_breakpoints_clicked(@_);
		},
	);

	$self->{m_checkBox3} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Variables"),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
	);
	$self->{m_checkBox3}->Disable;

	$self->{step_in} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap(),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
		Wx::BU_AUTODRAW() | Wx::NO_BORDER(),
	);
	$self->{step_in}->SetToolTip(
		Wx::gettext("Step In")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{step_in},
		sub {
			shift->step_in_clicked(@_);
		},
	);

	$self->{step_over} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap(),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
		Wx::BU_AUTODRAW() | Wx::NO_BORDER(),
	);
	$self->{step_over}->SetToolTip(
		Wx::gettext("Step Over")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{step_over},
		sub {
			shift->step_over_clicked(@_);
		},
	);

	$self->{step_out} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap(),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
		Wx::BU_AUTODRAW() | Wx::NO_BORDER(),
	);
	$self->{step_out}->SetToolTip(
		Wx::gettext("Step Out")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{step_out},
		sub {
			shift->step_out_clicked(@_);
		},
	);

	$self->{run_till} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap(),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
		Wx::BU_AUTODRAW() | Wx::NO_BORDER(),
	);
	$self->{run_till}->SetToolTip(
		Wx::gettext("Run Till Breakpoint")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{run_till},
		sub {
			shift->run_till_clicked(@_);
		},
	);

	$self->{set_breakpoints} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap(),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
		Wx::BU_AUTODRAW() | Wx::NO_BORDER(),
	);
	$self->{set_breakpoints}->SetToolTip(
		Wx::gettext("Set Breakpoint")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{set_breakpoints},
		sub {
			shift->set_breakpoints_clicked(@_);
		},
	);

	$self->{trace} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Trace"),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
	);
	$self->{trace}->SetToolTip(
		Wx::gettext("Trace On, Trace Off see status in Debug Output")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{trace},
		sub {
			shift->trace_clicked(@_);
		},
	);

	$self->{display_value} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap(),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
		Wx::BU_AUTODRAW() | Wx::NO_BORDER(),
	);
	$self->{display_value}->SetToolTip(
		Wx::gettext("Display Value")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{display_value},
		sub {
			shift->display_value_clicked(@_);
		},
	);

	$self->{quit_debugger} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap(),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
		Wx::BU_AUTODRAW() | Wx::NO_BORDER(),
	);
	$self->{quit_debugger}->SetToolTip(
		Wx::gettext("Quit Debugger")
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{quit_debugger},
		sub {
			shift->quit_debugger_clicked(@_);
		},
	);

	$self->{m_staticText31} = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("info: trace is a toggle \n it in not reset upon compleation"),
	);

	my $close_button = Wx::Button->new(
		$self,
		Wx::ID_CANCEL(),
		Wx::gettext("Close"),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
	);
	$close_button->SetDefault;

	$self->{m_staticline5} = Wx::StaticLine->new(
		$self,
		-1,
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
		Wx::LI_HORIZONTAL(),
	);

	my $file_1 = Wx::StaticBoxSizer->new(
		Wx::StaticBox->new(
			$self,
			-1,
			Wx::gettext("View -> Show Debug"),
		),
		Wx::HORIZONTAL(),
	);
	$file_1->Add( $self->{debug_output}, 0, Wx::ALL(), 5 );
	$file_1->Add( $self->{breakpoints}, 0, Wx::ALL(), 5 );
	$file_1->Add( $self->{m_checkBox3}, 0, Wx::ALL(), 5 );

	my $file_2 = Wx::StaticBoxSizer->new(
		Wx::StaticBox->new(
			$self,
			-1,
			Wx::gettext("Debug Buttons"),
		),
		Wx::HORIZONTAL(),
	);
	$file_2->Add( $self->{step_in}, 0, Wx::ALL(), 5 );
	$file_2->Add( $self->{step_over}, 0, Wx::ALL(), 5 );
	$file_2->Add( $self->{step_out}, 0, Wx::ALL(), 5 );
	$file_2->Add( $self->{run_till}, 0, Wx::ALL(), 5 );
	$file_2->Add( $self->{set_breakpoints}, 0, Wx::ALL(), 5 );
	$file_2->Add( $self->{trace}, 0, Wx::ALL(), 5 );
	$file_2->Add( $self->{display_value}, 0, Wx::ALL(), 5 );
	$file_2->Add( $self->{quit_debugger}, 0, Wx::ALL(), 5 );

	my $buttons = Wx::BoxSizer->new(Wx::HORIZONTAL());
	$buttons->Add( $self->{m_staticText31}, 0, Wx::ALL(), 5 );
	$buttons->Add( 0, 0, 1, Wx::EXPAND(), 5 );
	$buttons->Add( $close_button, 0, Wx::ALL(), 5 );

	my $vsizer = Wx::BoxSizer->new(Wx::VERTICAL());
	$vsizer->Add( $file_1, 0, Wx::EXPAND(), 5 );
	$vsizer->Add( $file_2, 0, Wx::EXPAND(), 5 );
	$vsizer->Add( $buttons, 0, Wx::EXPAND(), 3 );
	$vsizer->Add( $self->{m_staticline5}, 0, Wx::EXPAND() | Wx::ALL(), 5 );

	my $sizer = Wx::BoxSizer->new(Wx::HORIZONTAL());
	$sizer->Add( $vsizer, 0, Wx::ALL(), 1 );

	$self->SetSizer($sizer);
	$self->Layout;

	return $self;
}

sub debug_output {
	$_[0]->{debug_output};
}

sub breakpoints {
	$_[0]->{breakpoints};
}

sub on_debug_output_clicked {
	$_[0]->main->error('Handler method on_debug_output_clicked for event debug_output.OnCheckBox not implemented');
}

sub on_breakpoints_clicked {
	$_[0]->main->error('Handler method on_breakpoints_clicked for event breakpoints.OnCheckBox not implemented');
}

sub step_in_clicked {
	$_[0]->main->error('Handler method step_in_clicked for event step_in.OnButtonClick not implemented');
}

sub step_over_clicked {
	$_[0]->main->error('Handler method step_over_clicked for event step_over.OnButtonClick not implemented');
}

sub step_out_clicked {
	$_[0]->main->error('Handler method step_out_clicked for event step_out.OnButtonClick not implemented');
}

sub run_till_clicked {
	$_[0]->main->error('Handler method run_till_clicked for event run_till.OnButtonClick not implemented');
}

sub set_breakpoints_clicked {
	$_[0]->main->error('Handler method set_breakpoints_clicked for event set_breakpoints.OnButtonClick not implemented');
}

sub trace_clicked {
	$_[0]->main->error('Handler method trace_clicked for event trace.OnButtonClick not implemented');
}

sub display_value_clicked {
	$_[0]->main->error('Handler method display_value_clicked for event display_value.OnButtonClick not implemented');
}

sub quit_debugger_clicked {
	$_[0]->main->error('Handler method quit_debugger_clicked for event quit_debugger.OnButtonClick not implemented');
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

