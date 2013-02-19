package Padre::Wx::FBP::FindFast;

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
use File::ShareDir ();

our $VERSION = '0.99';
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
		Wx::DefaultSize,
		Wx::NO_BORDER,
	);

	$self->{cancel} = Wx::BitmapButton->new(
		$self,
		Wx::ID_CANCEL,
		Wx::Bitmap->new( File::ShareDir::dist_file( "Padre", "icons/padre/16x16/actions/x-document-close.png" ), Wx::BITMAP_TYPE_ANY ),
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::NO_BORDER,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{cancel},
		sub {
			shift->cancel(@_);
		},
	);

	my $m_staticText154 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Find:"),
	);

	$self->{find_term} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TE_NO_VSCROLL | Wx::TE_PROCESS_ENTER | Wx::WANTS_CHARS,
	);

	Wx::Event::EVT_CHAR(
		$self->{find_term},
		sub {
			$self->on_char($_[1]);
		},
	);

	Wx::Event::EVT_TEXT(
		$self,
		$self->{find_term},
		sub {
			shift->on_text(@_);
		},
	);

	$self->{find_previous} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("&Previous"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{find_previous},
		sub {
			shift->search_previous(@_);
		},
	);

	$self->{find_next} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("&Next"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{find_next},
		sub {
			shift->search_next(@_);
		},
	);

	my $bSizer79 = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$bSizer79->Add( $self->{cancel}, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::BOTTOM | Wx::LEFT | Wx::RIGHT, 3 );
	$bSizer79->Add( $m_staticText154, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::BOTTOM | Wx::LEFT | Wx::RIGHT, 3 );
	$bSizer79->Add( $self->{find_term}, 1, Wx::ALIGN_CENTER_VERTICAL | Wx::BOTTOM | Wx::LEFT | Wx::RIGHT, 3 );
	$bSizer79->Add( $self->{find_previous}, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::BOTTOM | Wx::LEFT | Wx::RIGHT, 3 );
	$bSizer79->Add( $self->{find_next}, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::BOTTOM | Wx::LEFT | Wx::RIGHT, 3 );

	$self->SetSizerAndFit($bSizer79);
	$self->Layout;

	return $self;
}

sub find_term {
	$_[0]->{find_term};
}

sub cancel {
	$_[0]->main->error('Handler method cancel for event cancel.OnButtonClick not implemented');
}

sub on_char {
	$_[0]->main->error('Handler method on_char for event find_term.OnChar not implemented');
}

sub on_text {
	$_[0]->main->error('Handler method on_text for event find_term.OnText not implemented');
}

sub search_previous {
	$_[0]->main->error('Handler method search_previous for event find_previous.OnButtonClick not implemented');
}

sub search_next {
	$_[0]->main->error('Handler method search_next for event find_next.OnButtonClick not implemented');
}

1;

# Copyright 2008-2013 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

