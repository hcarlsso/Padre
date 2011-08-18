package Padre::Wx::FBP::Special;

## no critic

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module edit the original .fbp file and regenerate.
# DO NOT MODIFY THIS FILE BY HAND!

use 5.008;
use strict;
use warnings;
use Padre::Wx ();
use Padre::Wx::Role::Main ();

our $VERSION = '0.91';
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
		Wx::gettext("Insert Special Values"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::wxDEFAULT_DIALOG_STYLE,
	);

	$self->{select} = Wx::Choice->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		[],
	);
	$self->{select}->SetSelection(0);

	Wx::Event::EVT_CHOICE(
		$self,
		$self->{select},
		sub {
			shift->refresh(@_);
		},
	);

	$self->{preview} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::DefaultPosition,
		[ 300, 50 ],
		Wx::TE_MULTILINE | Wx::TE_READONLY,
	);
	$self->{preview}->SetBackgroundColour(
		Wx::SystemSettings::GetColour( Wx::wxSYS_COLOUR_MENU )
	);
	$self->{preview}->SetFont(
		Wx::Font->new( Wx::wxNORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticline221} = Wx::StaticLine->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::wxLI_HORIZONTAL,
	);

	$self->{insert} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Insert"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);
	$self->{insert}->SetDefault;

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{insert},
		sub {
			shift->insert_preview(@_);
		},
	);

	$self->{cancel} = Wx::Button->new(
		$self,
		Wx::ID_CANCEL,
		Wx::gettext("Cancel"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	my $buttons = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$buttons->Add( $self->{insert}, 0, Wx::wxALL, 5 );
	$buttons->Add( 0, 0, 1, Wx::wxEXPAND, 5 );
	$buttons->Add( $self->{cancel}, 0, Wx::wxALL, 5 );

	my $vsizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$vsizer->Add( $self->{select}, 0, Wx::wxALL | Wx::wxEXPAND, 5 );
	$vsizer->Add( $self->{preview}, 0, Wx::wxALL | Wx::wxEXPAND, 5 );
	$vsizer->Add( $self->{m_staticline221}, 0, Wx::wxEXPAND | Wx::wxALL, 5 );
	$vsizer->Add( $buttons, 0, Wx::wxEXPAND, 5 );

	my $hsizer = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$hsizer->Add( $vsizer, 1, Wx::wxEXPAND, 5 );

	$self->SetSizerAndFit($hsizer);
	$self->Layout;

	return $self;
}

sub select {
	$_[0]->{select};
}

sub preview {
	$_[0]->{preview};
}

sub insert {
	$_[0]->{insert};
}

sub cancel {
	$_[0]->{cancel};
}

sub refresh {
	$_[0]->main->error('Handler method refresh for event select.OnChoice not implemented');
}

sub insert_preview {
	$_[0]->main->error('Handler method insert_preview for event insert.OnButtonClick not implemented');
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

