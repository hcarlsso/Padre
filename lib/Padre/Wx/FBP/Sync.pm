package Padre::Wx::FBP::Sync;

## no critic

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module edit the original .fbp file and regenerate.
# DO NOT MODIFY THIS FILE BY HAND!

use 5.008;
use strict;
use warnings;
use Padre::Wx ();
use Padre::Wx::Role::Main ();

our $VERSION = '0.88';
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
		Wx::gettext("Padre Sync"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxDEFAULT_DIALOG_STYLE,
	);

	my $m_staticText12 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Server"),
	);

	$self->{txt_remote} = Wx::TextCtrl->new(
		$self,
		-1,
		"http://sync.perlide.org/",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	my $m_staticText13 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Status"),
	);

	$self->{lbl_status} = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Logged out"),
	);
	$self->{lbl_status}->SetFont(
		Wx::Font->new( Wx::wxNORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	my $line1 = Wx::StaticLine->new(
		$self,
		-1,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxLI_HORIZONTAL,
	);

	my $m_staticText2 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Username"),
	);

	$self->{txt_login} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	my $m_staticText3 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Password"),
	);

	$self->{txt_password} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxTE_PASSWORD,
	);

	$self->{btn_login} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Login"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{btn_login},
		sub {
			shift->btn_login(@_);
		},
	);

	my $m_staticText5 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Username"),
	);

	$self->{txt_username} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	my $m_staticText6 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Password"),
	);

	$self->{txt_pw} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxTE_PASSWORD,
	);

	my $m_staticText7 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Confirm"),
	);

	$self->{txt_pw_confirm} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxTE_PASSWORD,
	);

	my $m_staticText8 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Email"),
	);

	$self->{txt_email} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	my $m_staticText9 = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Confirm"),
	);

	$self->{txt_email_confirm} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	$self->{btn_register} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Register"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{btn_register},
		sub {
			shift->btn_register(@_);
		},
	);

	my $line = Wx::StaticLine->new(
		$self,
		-1,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxLI_HORIZONTAL,
	);

	$self->{btn_local} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Upload"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);
	$self->{btn_local}->Disable;

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{btn_local},
		sub {
			shift->btn_local(@_);
		},
	);

	$self->{btn_remote} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Download"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);
	$self->{btn_remote}->Disable;

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{btn_remote},
		sub {
			shift->btn_remote(@_);
		},
	);

	$self->{btn_delete} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Delete"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);
	$self->{btn_delete}->Disable;

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{btn_delete},
		sub {
			shift->btn_delete(@_);
		},
	);

	$self->{btn_ok} = Wx::Button->new(
		$self,
		Wx::wxID_OK,
		Wx::gettext("Close"),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{btn_ok},
		sub {
			shift->btn_ok(@_);
		},
	);

	my $fgSizer3 = Wx::FlexGridSizer->new( 2, 2, 0, 0 );
	$fgSizer3->AddGrowableCol(1);
	$fgSizer3->SetFlexibleDirection(Wx::wxBOTH);
	$fgSizer3->SetNonFlexibleGrowMode(Wx::wxFLEX_GROWMODE_SPECIFIED);
	$fgSizer3->Add( $m_staticText12, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 3 );
	$fgSizer3->Add( $self->{txt_remote}, 0, Wx::wxALL | Wx::wxEXPAND, 3 );
	$fgSizer3->Add( $m_staticText13, 0, Wx::wxALL, 3 );
	$fgSizer3->Add( $self->{lbl_status}, 1, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL | Wx::wxEXPAND, 3 );

	my $fgSizer1 = Wx::FlexGridSizer->new( 3, 2, 0, 0 );
	$fgSizer1->AddGrowableCol(1);
	$fgSizer1->SetFlexibleDirection(Wx::wxHORIZONTAL);
	$fgSizer1->SetNonFlexibleGrowMode(Wx::wxFLEX_GROWMODE_SPECIFIED);
	$fgSizer1->Add( $m_staticText2, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 3 );
	$fgSizer1->Add( $self->{txt_login}, 1, Wx::wxALL | Wx::wxEXPAND, 3 );
	$fgSizer1->Add( $m_staticText3, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 3 );
	$fgSizer1->Add( $self->{txt_password}, 0, Wx::wxALL | Wx::wxEXPAND, 3 );
	$fgSizer1->Add( 0, 0, 1, Wx::wxEXPAND, 5 );
	$fgSizer1->Add( $self->{btn_login}, 0, Wx::wxALIGN_RIGHT | Wx::wxALL, 3 );

	my $sbSizer1 = Wx::StaticBoxSizer->new(
		Wx::StaticBox->new(
			$self,
			-1,
			Wx::gettext("Authentication"),
		),
		Wx::wxVERTICAL,
	);
	$sbSizer1->Add( $fgSizer1, 0, Wx::wxEXPAND, 5 );

	my $fgSizer2 = Wx::FlexGridSizer->new( 6, 2, 0, 0 );
	$fgSizer2->AddGrowableCol(1);
	$fgSizer2->SetFlexibleDirection(Wx::wxHORIZONTAL);
	$fgSizer2->SetNonFlexibleGrowMode(Wx::wxFLEX_GROWMODE_SPECIFIED);
	$fgSizer2->Add( $m_staticText5, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 3 );
	$fgSizer2->Add( $self->{txt_username}, 0, Wx::wxALL | Wx::wxEXPAND, 3 );
	$fgSizer2->Add( $m_staticText6, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 3 );
	$fgSizer2->Add( $self->{txt_pw}, 0, Wx::wxALL | Wx::wxEXPAND, 3 );
	$fgSizer2->Add( $m_staticText7, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 3 );
	$fgSizer2->Add( $self->{txt_pw_confirm}, 0, Wx::wxALL | Wx::wxEXPAND, 3 );
	$fgSizer2->Add( $m_staticText8, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 3 );
	$fgSizer2->Add( $self->{txt_email}, 0, Wx::wxALL | Wx::wxEXPAND, 3 );
	$fgSizer2->Add( $m_staticText9, 0, Wx::wxALIGN_CENTER_VERTICAL | Wx::wxALL, 3 );
	$fgSizer2->Add( $self->{txt_email_confirm}, 0, Wx::wxALL | Wx::wxEXPAND, 3 );
	$fgSizer2->Add( 0, 0, 1, Wx::wxEXPAND, 5 );
	$fgSizer2->Add( $self->{btn_register}, 0, Wx::wxALIGN_RIGHT | Wx::wxALL, 3 );

	my $sbSizer2 = Wx::StaticBoxSizer->new(
		Wx::StaticBox->new(
			$self,
			-1,
			Wx::gettext("Registration"),
		),
		Wx::wxVERTICAL,
	);
	$sbSizer2->Add( $fgSizer2, 1, Wx::wxEXPAND, 5 );

	my $bSizer7 = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$bSizer7->Add( $sbSizer1, 1, Wx::wxEXPAND, 5 );
	$bSizer7->Add( 10, 0, 0, Wx::wxEXPAND, 5 );
	$bSizer7->Add( $sbSizer2, 1, Wx::wxEXPAND, 5 );

	my $buttons = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$buttons->Add( $self->{btn_local}, 0, Wx::wxALL, 3 );
	$buttons->Add( $self->{btn_remote}, 0, Wx::wxALL, 3 );
	$buttons->Add( $self->{btn_delete}, 0, Wx::wxALL, 3 );
	$buttons->Add( 50, 0, 1, Wx::wxEXPAND, 3 );
	$buttons->Add( $self->{btn_ok}, 0, Wx::wxALL, 3 );

	my $vsizer = Wx::BoxSizer->new(Wx::wxVERTICAL);
	$vsizer->Add( $fgSizer3, 0, Wx::wxEXPAND, 5 );
	$vsizer->Add( $line1, 0, Wx::wxBOTTOM | Wx::wxEXPAND | Wx::wxTOP, 5 );
	$vsizer->Add( $bSizer7, 1, Wx::wxEXPAND, 5 );
	$vsizer->Add( $line, 0, Wx::wxBOTTOM | Wx::wxEXPAND | Wx::wxTOP, 5 );
	$vsizer->Add( $buttons, 0, Wx::wxALIGN_RIGHT | Wx::wxEXPAND, 0 );

	my $hsizer = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$hsizer->Add( $vsizer, 1, Wx::wxALL | Wx::wxEXPAND, 5 );

	$self->SetSizer($hsizer);
	$self->Layout;
	$hsizer->Fit($self);

	return $self;
}

sub btn_login {
	$_[0]->main->error('Handler method btn_login for event btn_login.OnButtonClick not implemented');
}

sub btn_register {
	$_[0]->main->error('Handler method btn_register for event btn_register.OnButtonClick not implemented');
}

sub btn_local {
	$_[0]->main->error('Handler method btn_local for event btn_local.OnButtonClick not implemented');
}

sub btn_remote {
	$_[0]->main->error('Handler method btn_remote for event btn_remote.OnButtonClick not implemented');
}

sub btn_delete {
	$_[0]->main->error('Handler method btn_delete for event btn_delete.OnButtonClick not implemented');
}

sub btn_ok {
	$_[0]->main->error('Handler method btn_ok for event btn_ok.OnButtonClick not implemented');
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

