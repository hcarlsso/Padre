package Padre::Plugin::FormBuilder::FBP;

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module, edit the original .fbp file and regenerate.
# DO NOT MODIFY BY HAND!

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
		Wx::gettext("Padre FormBuilder"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxDEFAULT_DIALOG_STYLE,
	);
	$self->SetSizeHints( Wx::wxDefaultSize, Wx::wxDefaultSize );

	my $file = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Dialog Source"),
	);
	$file->SetFont(
		Wx::Font->new( Wx::wxNORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{browse} = Wx::FilePickerCtrl->new(
		$self,
		-1,
		"",
		"Select a file",
		"*.*",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxFLP_DEFAULT_STYLE,
	);

	Wx::Event::EVT_FILEPICKER_CHANGED(
		$self,
		$self->{browse},
		sub {
			shift->browse_changed(@_);
		},
	);

	my $line1 = Wx::StaticLine->new(
		$self,
		-1,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxLI_HORIZONTAL,
	);

	my $m_staticText4 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Generate Single Dialog"),
	);
	$m_staticText4->SetFont(
		Wx::Font->new( Wx::wxNORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{associate} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("...and associate with current project"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);
	$self->{associate}->SetToolTip(
		Wx::gettext("Generates embedded tracking data in the dialog code")
	);
	$self->{associate}->Disable;

	$self->{select} = Wx::Choice->new(
		$self,
		-1,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		[],
	);
	$self->{select}->SetSelection(0);
	$self->{select}->Disable;

	$self->{preview} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Preview"),
	);
	$self->{preview}->Disable;

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{preview},
		sub {
			shift->preview_clicked(@_);
		},
	);

	my $m_staticText6 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Encapsulation:"),
	);

	$self->{encapsulation} = Wx::Choice->new(
		$self,
		-1,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		[
			"Naive",
			"Strict",
		],
	);
	$self->{encapsulation}->SetSelection(0);
	$self->{encapsulation}->Disable;

	my $m_staticText5 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("\$VERSION ="),
	);

	$self->{version} = Wx::TextCtrl->new(
		$self,
		-1,
		"0.01",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxTE_LEFT,
	);
	$self->{version}->SetMaxLength(10);
	$self->{version}->Disable;

	$self->{generate} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Generate Dialog"),
	);
	$self->{generate}->Disable;

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{generate},
		sub {
			shift->generate_clicked(@_);
		},
	);

	my $line2 = Wx::StaticLine->new(
		$self,
		-1,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxLI_HORIZONTAL,
	);

	my $m_staticText3 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Common Settings"),
	);
	$m_staticText3->SetFont(
		Wx::Font->new( Wx::wxNORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{padre} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Generate dialog code for use in Padre or a Padre plugin"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);
	$self->{padre}->Disable;

	my $m_staticline4 = Wx::StaticLine->new(
		$self,
		-1,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxLI_HORIZONTAL,
	);

	my $cancel = Wx::Button->new(
		$self,
		Wx::wxID_CANCEL,
		Wx::gettext("Close"),
	);

	my $bSizer6 = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$bSizer6->Add( $self->{browse}, 1, Wx::wxALL | Wx::wxEXPAND, 5 );

	my $bSizer5 = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$bSizer5->Add( $self->{select}, 1, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL | Wx::wxEXPAND, 5 );
	$bSizer5->Add( $self->{preview}, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 5 );

	my $fgSizer2 = Wx::FlexGridSizer->new( 2, 2, 0, 0 );
	$fgSizer2->SetFlexibleDirection(Wx::wxBOTH);
	$fgSizer2->SetNonFlexibleGrowMode(Wx::wxFLEX_GROWMODE_SPECIFIED);
	$fgSizer2->Add( $m_staticText6, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 5 );
	$fgSizer2->Add( $self->{encapsulation}, 0, Wx::wxALL | Wx::wxEXPAND, 5 );
	$fgSizer2->Add( $m_staticText5, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALIGN_RIGHT | Wx::wxALL, 5 );
	$fgSizer2->Add( $self->{version}, 0, Wx::wxALL, 5 );

	my $buttons = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$buttons->Add( 50, 0, 1, Wx::wxEXPAND, 5 );
	$buttons->Add( $cancel, 0, Wx::wxALL, 5 );

	my $sizer2 = Wx::BoxSizer->new(Wx::wxVERTICAL);
	$sizer2->Add( $file, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 5 );
	$sizer2->Add( $bSizer6, 0, Wx::wxEXPAND, 5 );
	$sizer2->Add( 0, 5, 0, Wx::wxEXPAND, 5 );
	$sizer2->Add( $line1, 0, Wx::wxBOTTOM | Wx::wxEXPAND | Wx::wxTOP, 0 );
	$sizer2->Add( $m_staticText4, 0, Wx::wxALL | Wx::wxEXPAND, 5 );
	$sizer2->Add( $self->{associate}, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 5 );
	$sizer2->Add( $bSizer5, 0, Wx::wxEXPAND, 0 );
	$sizer2->Add( $fgSizer2, 0, Wx::wxEXPAND, 5 );
	$sizer2->Add( 0, 20, 0, Wx::wxEXPAND, 5 );
	$sizer2->Add( $self->{generate}, 0, Wx::wxALIGN_CENTER_HORIZONTAL | Wx::wxALL, 5 );
	$sizer2->Add( $line2, 0, Wx::wxBOTTOM | Wx::wxEXPAND | Wx::wxTOP, 5 );
	$sizer2->Add( $m_staticText3, 0, Wx::wxALL | Wx::wxEXPAND, 5 );
	$sizer2->Add( $self->{padre}, 0, Wx::wxALL, 5 );
	$sizer2->Add( 0, 10, 0, Wx::wxEXPAND, 5 );
	$sizer2->Add( $m_staticline4, 0, Wx::wxEXPAND, 5 );
	$sizer2->Add( $buttons, 0, Wx::wxEXPAND, 5 );

	my $sizer1 = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$sizer1->Add( $sizer2, 1, Wx::wxEXPAND, 5 );

	$self->SetSizer($sizer1);
	$self->Layout;
	$sizer1->Fit($self);

	return $self;
}

sub browse {
	$_[0]->{browse};
}

sub associate {
	$_[0]->{associate};
}

sub select {
	$_[0]->{select};
}

sub preview {
	$_[0]->{preview};
}

sub encapsulation {
	$_[0]->{encapsulation};
}

sub version {
	$_[0]->{version};
}

sub generate {
	$_[0]->{generate};
}

sub padre {
	$_[0]->{padre};
}

sub browse_changed {
	$_[0]->main->error('Handler method browse_changed for event browse.OnFileChanged not implemented');
}

sub preview_clicked {
	$_[0]->main->error('Handler method preview_clicked for event preview.OnButtonClick not implemented');
}

sub generate_clicked {
	$_[0]->main->error('Handler method generate_clicked for event generate.OnButtonClick not implemented');
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

