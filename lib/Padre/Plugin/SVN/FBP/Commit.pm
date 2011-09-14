package Padre::Plugin::SVN::FBP::Commit;

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
		Wx::gettext("SVN Commit"),
		Wx::DefaultPosition(),
		[ 879, 678 ],
		Wx::DEFAULT_DIALOG_STYLE() | Wx::RESIZE_BORDER(),
	);

	$self->{m_panel1} = Wx::Panel->new(
		$self,
		-1,
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
		Wx::TAB_TRAVERSAL(),
	);

	$self->{m_staticText4} = Wx::StaticText->new(
		$self->{m_panel1},
		-1,
		Wx::gettext("File Path"),
	);

	$self->{txtFilePath} = Wx::StaticText->new(
		$self->{m_panel1},
		-1,
		Wx::gettext("path"),
	);

	$self->{m_staticText6} = Wx::StaticText->new(
		$self->{m_panel1},
		-1,
		Wx::gettext("Repository"),
	);

	$self->{txtRepo} = Wx::StaticText->new(
		$self->{m_panel1},
		-1,
		Wx::gettext("repo"),
	);

	$self->{m_staticText8} = Wx::StaticText->new(
		$self->{m_panel1},
		-1,
		Wx::gettext("Current Revision"),
	);

	$self->{txtCurrentRevision} = Wx::StaticText->new(
		$self->{m_panel1},
		-1,
		Wx::gettext("currentRevision"),
	);

	$self->{m_textCtrl4} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
		Wx::TE_MULTILINE ()| Wx::TE_WORDWRAP(),
	);

	$self->{btnCancel} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Cancel"),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{btnCancel},
		sub {
			shift->on_click_cancel(@_);
		},
	);

	$self->{btnOK} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("OK"),
		Wx::DefaultPosition(),
		Wx::DefaultSize(),
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{btnOK},
		sub {
			shift->on_click_ok(@_);
		},
	);

	my $gSizer2 = Wx::GridSizer->new( 2, 2, 2, 5 );
	$gSizer2->Add( $self->{m_staticText4}, 0, Wx::ALIGN_RIGHT() | Wx::EXPAND(), 5 );
	$gSizer2->Add( $self->{txtFilePath}, 0, Wx::ALIGN_LEFT() | Wx::EXPAND(), 5 );
	$gSizer2->Add( $self->{m_staticText6}, 0, Wx::ALIGN_RIGHT() | Wx::EXPAND() | Wx::RIGHT(), 5 );
	$gSizer2->Add( $self->{txtRepo}, 0, Wx::ALIGN_LEFT ()| Wx::EXPAND(), 5 );
	$gSizer2->Add( $self->{m_staticText8}, 0, Wx::ALIGN_RIGHT ()| Wx::EXPAND() | Wx::RIGHT(), 5 );
	$gSizer2->Add( $self->{txtCurrentRevision}, 0, Wx::ALIGN_LEFT() | Wx::EXPAND(), 5 );

	$self->{m_panel1}->SetSizerAndFit($gSizer2);
	$self->{m_panel1}->Layout;

	my $bSizer7 = Wx::BoxSizer->new(Wx::HORIZONTAL());
	$bSizer7->Add( $self->{btnCancel}, 0, Wx::ALL(), 5 );
	$bSizer7->Add( $self->{btnOK}, 0, Wx::ALL(), 5 );

	my $bSizer6 = Wx::BoxSizer->new(Wx::VERTICAL());
	$bSizer6->Add( $bSizer7, 1, Wx::ALIGN_BOTTOM() | Wx::ALIGN_RIGHT(), 5 );

	my $bSizer1 = Wx::BoxSizer->new(Wx::VERTICAL());
	$bSizer1->Add( $self->{m_panel1}, 0, Wx::EXPAND(), 5 );
	$bSizer1->Add( $self->{m_textCtrl4}, 1, Wx::ALL() | Wx::EXPAND(), 5 );
	$bSizer1->Add( $bSizer6, 0, Wx::ALIGN_BOTTOM() | Wx::EXPAND(), 5 );

	$self->SetSizer($bSizer1);
	$self->Layout;

	return $self;
}

sub txtFilePath {
	$_[0]->{txtFilePath};
}

sub txtRepo {
	$_[0]->{txtRepo};
}

sub txtCurrentRevision {
	$_[0]->{txtCurrentRevision};
}

sub on_click_cancel {
	$_[0]->main->error('Handler method on_click_cancel for event btnCancel.OnButtonClick not implemented');
}

sub on_click_ok {
	$_[0]->main->error('Handler method on_click_ok for event btnOK.OnButtonClick not implemented');
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

