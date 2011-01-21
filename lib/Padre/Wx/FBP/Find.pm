package Padre::Wx::FBP::Find;

# This module was generated by Padre::Plugin::FormBuilder::Perl. DO NOT MODIFY BY HAND!
# To change this module, edit the original .fbp file and regenerate.

use 5.008;
use strict;
use warnings;
use Padre::Wx ();
use Padre::Wx::Role::Main ();
use Padre::Wx::History::ComboBox ();

our $VERSION = '0.78';
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
		Wx::gettext("Find"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxDEFAULT_DIALOG_STYLE,
	);

	my $m_staticText2 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Search Term:"),
	);

	$self->{find_term} = Padre::Wx::History::ComboBox->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		[
			"search",
		],
	);

	my $m_staticline2 = Wx::StaticLine->new(
		$self,
		-1,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxLI_HORIZONTAL,
	);

	$self->{find_regex} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Regular Expression"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	$self->{find_reverse} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Search Backwards"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	$self->{find_case} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Case Sensitive"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	$self->{find_first} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Close Window on Hit"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	my $m_staticline1 = Wx::StaticLine->new(
		$self,
		-1,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxLI_HORIZONTAL,
	);

	$self->{find_next} = Wx::Button->new(
		$self,
		Wx::wxID_OK,
		Wx::gettext("Find Next"),
	);
	$self->{find_next}->SetDefault;

	$self->{find_all} = Wx::Button->new(
		$self,
		Wx::wxID_OK,
		Wx::gettext("Find All"),
	);

	$self->{cancel} = Wx::Button->new(
		$self,
		Wx::wxID_CANCEL,
		Wx::gettext("Cancel"),
	);

	my $fgSizer2 = Wx::FlexGridSizer->new( 2, 2, 0, 10 );
	$fgSizer2->AddGrowableCol( 1 );
	$fgSizer2->SetFlexibleDirection( Wx::wxBOTH );
	$fgSizer2->SetNonFlexibleGrowMode( Wx::wxFLEX_GROWMODE_SPECIFIED );
	$fgSizer2->Add( $self->{find_regex}, 1, Wx::wxALL, 5 );
	$fgSizer2->Add( $self->{find_reverse}, 1, Wx::wxALL, 5 );
	$fgSizer2->Add( $self->{find_case}, 1, Wx::wxALL, 5 );
	$fgSizer2->Add( $self->{find_first}, 1, Wx::wxALL, 5 );

	my $buttons = Wx::BoxSizer->new( Wx::wxHORIZONTAL );
	$buttons->Add( $self->{find_next}, 0, Wx::wxALL, 5 );
	$buttons->Add( $self->{find_all}, 0, Wx::wxALL, 5 );
	$buttons->Add( 20, 0, 1, Wx::wxEXPAND, 5 );
	$buttons->Add( $self->{cancel}, 0, Wx::wxALL, 5 );

	my $vsizer = Wx::BoxSizer->new( Wx::wxVERTICAL );
	$vsizer->Add( $m_staticText2, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxLEFT | Wx::wxRIGHT | Wx::wxTOP, 5 );
	$vsizer->Add( $self->{find_term}, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL | Wx::wxEXPAND, 5 );
	$vsizer->Add( $m_staticline2, 0, Wx::wxALL | Wx::wxEXPAND, 5 );
	$vsizer->Add( $fgSizer2, 1, Wx::wxBOTTOM | Wx::wxEXPAND, 5 );
	$vsizer->Add( $m_staticline1, 0, Wx::wxALL | Wx::wxEXPAND, 5 );
	$vsizer->Add( $buttons, 0, Wx::wxEXPAND, 5 );

	my $hsizer = Wx::BoxSizer->new( Wx::wxHORIZONTAL );
	$hsizer->Add( $vsizer, 1, Wx::wxALL | Wx::wxEXPAND, 5 );

	$self->SetSizer($hsizer);
	$self->Layout;
	$hsizer->Fit($self);

	return $self;
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

