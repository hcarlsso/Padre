package Padre::Plugin::ParserTool::FBP;

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
		Wx::gettext("Parser Tool"),
		Wx::DefaultPosition,
		[ 459, 480 ],
		Wx::DEFAULT_DIALOG_STYLE | Wx::RESIZE_BORDER,
	);

	my $input_label = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Input Text"),
	);
	$input_label->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{input} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::DefaultPosition,
		[ 200, 100 ],
		Wx::TE_DONTWRAP | Wx::TE_MULTILINE,
	);
	$self->{input}->SetMinSize( [ 200, 100 ] );

	Wx::Event::EVT_TEXT(
		$self,
		$self->{input},
		sub {
			shift->refresh(@_);
		},
	);

	my $module_label = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Parser Module"),
	);
	$module_label->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{module} = Wx::ComboBox->new(
		$self,
		-1,
		"PPI",
		Wx::DefaultPosition,
		Wx::DefaultSize,
		[
			"PPI",
		],
		Wx::CB_DROPDOWN,
	);

	my $function_label = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Parser Function"),
	);
	$function_label->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{function} = Wx::ComboBox->new(
		$self,
		-1,
		"PPI::Document->new(\\\$_)",
		Wx::DefaultPosition,
		Wx::DefaultSize,
		[],
	);

	my $dumper_label = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Dumper Format"),
	);
	$dumper_label->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{dumper} = Wx::Choice->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		[
			"Stringify",
			"Devel::Dumpvar",
			"Data::Dumper",
			"PPI::Dumper",
		],
	);
	$self->{dumper}->SetSelection(3);

	Wx::Event::EVT_CHOICE(
		$self,
		$self->{dumper},
		sub {
			shift->refresh(@_);
		},
	);

	my $output_label = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Output Structure"),
	);
	$output_label->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{output} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::DefaultPosition,
		[ 400, 200 ],
		Wx::TE_DONTWRAP | Wx::TE_MULTILINE | Wx::TE_READONLY,
	);
	$self->{output}->SetMinSize( [ 400, 200 ] );
	$self->{output}->SetBackgroundColour(
		Wx::Colour->new( 240, 240, 240 )
	);

	my $input_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$input_sizer->Add( $input_label, 0, Wx::ALL | Wx::EXPAND, 5 );
	$input_sizer->Add( $self->{input}, 1, Wx::EXPAND, 0 );

	my $options_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$options_sizer->SetMinSize( [ 200, -1 ] );
	$options_sizer->Add( $module_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::ALIGN_LEFT | Wx::ALL, 5 );
	$options_sizer->Add( $self->{module}, 0, Wx::EXPAND | Wx::LEFT, 5 );
	$options_sizer->Add( $function_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::ALIGN_LEFT | Wx::ALL, 5 );
	$options_sizer->Add( $self->{function}, 0, Wx::EXPAND | Wx::LEFT, 3 );
	$options_sizer->Add( $dumper_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::ALIGN_LEFT | Wx::ALL, 5 );
	$options_sizer->Add( $self->{dumper}, 0, Wx::EXPAND | Wx::LEFT, 3 );

	my $top_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$top_sizer->Add( $input_sizer, 1, Wx::EXPAND, 5 );
	$top_sizer->Add( $options_sizer, 1, Wx::EXPAND, 5 );

	my $left_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$left_sizer->Add( $top_sizer, 0, Wx::EXPAND, 5 );
	$left_sizer->Add( $output_label, 0, Wx::ALL | Wx::EXPAND, 5 );
	$left_sizer->Add( $self->{output}, 1, Wx::EXPAND, 0 );

	my $sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$sizer->Add( $left_sizer, 1, Wx::ALL | Wx::EXPAND, 5 );

	$self->SetSizer($sizer);
	$self->Layout;

	return $self;
}

sub input {
	$_[0]->{input};
}

sub module {
	$_[0]->{module};
}

sub function {
	$_[0]->{function};
}

sub dumper {
	$_[0]->{dumper};
}

sub output {
	$_[0]->{output};
}

sub refresh {
	$_[0]->main->error('Handler method refresh for event input.OnText not implemented');
}

1;

# Copyright 2008-2012 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

