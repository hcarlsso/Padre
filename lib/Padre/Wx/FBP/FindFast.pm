package Padre::Wx::FBP::FindFast;

## no critic

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module, edit the original .fbp file and regenerate.
# DO NOT MODIFY BY HAND!

use 5.008;
use strict;
use warnings;
use Padre::Wx ();
use Padre::Wx::Role::Main ();

our $VERSION = '0.89';
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
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxNO_BORDER | Wx::wxTAB_TRAVERSAL,
	);

	my $cancel = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("X"),
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$cancel,
		sub {
			shift->close_clicked(@_);
		},
	);

	my $find_label = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Find:"),
	);

	my $find_text = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxTE_NO_VSCROLL,
	);

	Wx::Event::EVT_TEXT(
		$self,
		$find_text,
		sub {
			shift->find_text_changed(@_);
		},
	);

	my $find_next = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Next"),
	);
	$find_next->SetDefault;

	Wx::Event::EVT_BUTTON(
		$self,
		$find_next,
		sub {
			shift->find_next_clicked(@_);
		},
	);

	my $find_previous = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Previous"),
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$find_previous,
		sub {
			shift->find_previous_clicked(@_);
		},
	);

	my $find_case = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Match Case"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	my $sizer = Wx::FlexGridSizer->new( 1, 6, 0, 0 );
	$sizer->AddGrowableRow(0);
	$sizer->SetFlexibleDirection(Wx::wxBOTH);
	$sizer->SetNonFlexibleGrowMode(Wx::wxFLEX_GROWMODE_SPECIFIED);
	$sizer->Add( $cancel, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 5 );
	$sizer->Add( $find_label, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 5 );
	$sizer->Add( $find_text, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 5 );
	$sizer->Add( $find_next, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 5 );
	$sizer->Add( $find_previous, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 5 );
	$sizer->Add( $find_case, 1, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 5 );

	$self->SetSizer($sizer);
	$self->Layout;
	$sizer->Fit($self);

	$self->{find_text} = $find_text->GetId;
	$self->{find_next} = $find_next->GetId;
	$self->{find_previous} = $find_previous->GetId;
	$self->{find_case} = $find_case->GetId;

	return $self;
}

sub find_text {
	Wx::Window::FindWindowById($_[0]->{find_text});
}

sub find_next {
	Wx::Window::FindWindowById($_[0]->{find_next});
}

sub find_previous {
	Wx::Window::FindWindowById($_[0]->{find_previous});
}

sub find_case {
	Wx::Window::FindWindowById($_[0]->{find_case});
}

sub close_clicked {
	$_[0]->main->error('Handler method close_clicked for event cancel.OnButtonClick not implemented');
}

sub find_text_changed {
	$_[0]->main->error('Handler method find_text_changed for event find_text.OnText not implemented');
}

sub find_next_clicked {
	$_[0]->main->error('Handler method find_next_clicked for event find_next.OnButtonClick not implemented');
}

sub find_previous_clicked {
	$_[0]->main->error('Handler method find_previous_clicked for event find_previous.OnButtonClick not implemented');
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

