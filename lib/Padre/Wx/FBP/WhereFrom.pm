package Padre::Wx::FBP::WhereFrom;

## no critic

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module, edit the original .fbp file and regenerate.
# DO NOT MODIFY BY HAND!

use 5.008;
use strict;
use warnings;
use Padre::Wx ();
use Padre::Wx::Role::Main ();

our $VERSION = '0.93';
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
		Wx::gettext("New Installation Survey"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::DEFAULT_DIALOG_STYLE,
	);

	my $label = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Where did you hear about Padre?"),
	);

	my $from = Wx::ComboBox->new(
		$self,
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
		[],
	);

	my $line = Wx::StaticLine->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::LI_HORIZONTAL,
	);

	my $ok = Wx::Button->new(
		$self,
		Wx::ID_OK,
		Wx::gettext("OK"),
	);

	my $cancel = Wx::Button->new(
		$self,
		Wx::ID_CANCEL,
		Wx::gettext("Skip question without giving feedback"),
	);

	my $question = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$question->Add( $label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::ALL, 5 );
	$question->Add( $from, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::ALL, 5 );

	my $buttons = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$buttons->Add( $ok, 0, Wx::ALL, 5 );
	$buttons->Add( 0, 0, 1, Wx::EXPAND, 5 );
	$buttons->Add( $cancel, 0, Wx::ALL, 5 );

	my $vsizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$vsizer->Add( $question, 1, Wx::ALIGN_RIGHT, 0 );
	$vsizer->Add( $line, 0, Wx::EXPAND | Wx::LEFT | Wx::RIGHT, 5 );
	$vsizer->Add( $buttons, 1, Wx::ALIGN_RIGHT | Wx::EXPAND, 0 );

	my $hsizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$hsizer->Add( $vsizer, 1, Wx::EXPAND, 5 );

	$self->SetSizer($hsizer);
	$self->Layout;
	$hsizer->Fit($self);

	return $self;
}

1;

# Copyright 2008-2012 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

