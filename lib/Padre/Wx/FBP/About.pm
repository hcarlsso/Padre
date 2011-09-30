package Padre::Wx::FBP::About;

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
		Wx::gettext("About 2"),
		Wx::DefaultPosition,
		[ 600, 600 ],
		Wx::DEFAULT_DIALOG_STYLE,
	);

	$self->{m_notebook3} = Wx::Notebook->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{m_panel9} = Wx::Panel->new(
		$self->{m_notebook3},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TAB_TRAVERSAL,
	);
	$self->{m_panel9}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 91, 0, "" )
	);

	$self->{m_staticText651} = Wx::StaticText->new(
		$self->{m_panel9},
		-1,
		Wx::gettext("Padre:-"),
	);
	$self->{m_staticText651}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText6511} = Wx::StaticText->new(
		$self->{m_panel9},
		-1,
		Wx::gettext("Perl Application Development and Refactoring Environment"),
	);
	$self->{m_staticText6511}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText65111} = Wx::StaticText->new(
		$self->{m_panel9},
		-1,
		Wx::gettext("Created by Gabor Szabo"),
	);
	$self->{m_staticText65111}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 90, 0, "" )
	);

	$self->{splash} = Wx::StaticBitmap->new(
		$self->{m_panel9},
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{m_staticText67} = Wx::StaticText->new(
		$self->{m_panel9},
		-1,
		Wx::gettext("Blue butterfly on a green leaf splash image is based on work \nby Jerry Charlotte (blackbutterfly)"),
	);
	$self->{m_staticText67}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 90, 0, "" )
	);

	$self->{m_staticline27} = Wx::StaticLine->new(
		$self->{m_panel9},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::LI_HORIZONTAL,
	);

	$self->{m_staticText34} = Wx::StaticText->new(
		$self->{m_panel9},
		-1,
		Wx::gettext("Copyright 2008\x{2013}2011 The Padre Development Team Padre is free software; \nyou can redistribute it and/or modify it under the same terms as Perl 5."),
	);

	$self->{m_staticline28} = Wx::StaticLine->new(
		$self->{m_panel9},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::LI_HORIZONTAL,
	);

	$self->{m_staticText35} = Wx::StaticText->new(
		$self->{m_panel9},
		-1,
		Wx::gettext("\"Padre contains icons from GNOME, you can redistribute it and/or \nmodify then under the terms of the GNU General Public License as published by the \nFree Software Foundation; version 2 dated June, 1991.\""),
	);

	$self->{m_panel10} = Wx::Panel->new(
		$self->{m_notebook3},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TAB_TRAVERSAL,
	);

	$self->{m_staticText47} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Core Team"),
	);
	$self->{m_staticText47}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticline1} = Wx::StaticLine->new(
		$self->{m_panel10},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::LI_HORIZONTAL,
	);

	$self->{m_staticText1} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Gabor Szabo: Project Manager"),
	);

	$self->{m_staticText2} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Adam Kennedy: Chief Bugger"),
	);

	$self->{m_staticText3} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Ahmad Zawawi: Developer"),
	);

	$self->{m_staticText4} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Peter Lavender: Release Manager"),
	);

	$self->{m_staticText471} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Current Developers"),
	);
	$self->{m_staticText471}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticline11} = Wx::StaticLine->new(
		$self->{m_panel10},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::LI_HORIZONTAL,
	);

	$self->{m_staticText5} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Aaron Trevena"),
	);

	$self->{m_staticText6} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Alexandr Ciornii"),
	);

	$self->{m_staticText7} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Blake Willmarth"),
	);

	$self->{m_staticText8} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Breno G. de Oliveira"),
	);

	$self->{m_staticText39} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Brian Cassidy"),
	);

	$self->{m_staticText40} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Cezary Morga"),
	);

	$self->{m_staticText411} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Chris Dolan"),
	);

	$self->{m_staticText42} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Claudio Ramirez"),
	);

	$self->{m_staticText53} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Tom Eliaz"),
	);

	$self->{m_staticText54} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("code4pay"),
	);

	$self->{m_staticText55} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Fayland Lam"),
	);

	$self->{m_staticText56} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Gabriel Vieira"),
	);

	$self->{m_staticText561} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Heiko Jansen"),
	);

	$self->{m_staticText571} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Jerome Quelin"),
	);

	$self->{m_staticText58} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Kaare Rasmussen"),
	);

	$self->{m_staticText59} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Kartik Thakore"),
	);

	$self->{m_staticText60} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Keedi Kim"),
	);

	$self->{m_staticText611} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Kenichi Ishigaki"),
	);

	$self->{m_staticText621} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Max Maischein"),
	);

	$self->{m_staticText63} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Olivier Mengue"),
	);

	$self->{m_staticText64} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Patrick Donelan"),
	);

	$self->{m_staticText671} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Pawe\x{142} Murias"),
	);

	$self->{m_staticText68} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Petar Shangov"),
	);

	$self->{m_staticText65} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Ryan Niebur"),
	);

	$self->{m_staticText66} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Sebastian Willing"),
	);

	$self->{m_staticText69} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Steffen Muller"),
	);

	$self->{m_staticText70} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Zeno Gantner"),
	);

	$self->{m_staticText711} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Burak Gursoy"),
	);

	$self->{m_staticText721} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Andrew Bramble"),
	);

	$self->{m_staticText73} = Wx::StaticText->new(
		$self->{m_panel10},
		-1,
		Wx::gettext("Kevin Dawson"),
	);

	$self->{m_panel11} = Wx::Panel->new(
		$self->{m_notebook3},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TAB_TRAVERSAL,
	);

	$self->{m_staticText4723} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Arabic"),
	);
	$self->{m_staticText4723}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText813} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Ahmad Zawawi"),
	);

	$self->{m_staticText4721} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Chinese (Simplified)"),
	);
	$self->{m_staticText4721}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText811} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Fayland Lam"),
	);

	$self->{m_staticText712} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Chuanren Wu"),
	);

	$self->{m_staticText4722} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Chinese (Traditional)"),
	);
	$self->{m_staticText4722}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText812} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Matthew Lien"),
	);

	$self->{m_staticText47221} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Czech"),
	);
	$self->{m_staticText47221}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText8121} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Marcela Maslanova"),
	);

	$self->{m_staticText47222} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Dutch"),
	);
	$self->{m_staticText47222}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText8122} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Dirk De Nijs"),
	);

	$self->{m_staticText47223} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("French"),
	);
	$self->{m_staticText47223}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText8123} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Jerome Quelin"),
	);

	$self->{m_staticText7133} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Olivier Mengue"),
	);

	$self->{m_staticText47224} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("German"),
	);
	$self->{m_staticText47224}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText8124} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Heiko Jansen"),
	);

	$self->{m_staticText7134} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Sebastian Willing"),
	);

	$self->{m_staticText71341} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Zeno Gantner"),
	);

	$self->{m_staticText47225} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Hebrew"),
	);
	$self->{m_staticText47225}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText8125} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Omer Zak"),
	);

	$self->{m_staticText7135} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Shlomi Fish"),
	);

	$self->{m_staticText71351} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Amir E. Aharoni"),
	);

	$self->{m_staticText47226} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Hungarian"),
	);
	$self->{m_staticText47226}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText8126} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Gyorgy Pasztor"),
	);

	$self->{m_staticText47227} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Italian"),
	);
	$self->{m_staticText47227}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText8127} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Simone Blandino"),
	);

	$self->{m_staticText47228} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Japanese"),
	);
	$self->{m_staticText47228}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText8128} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Kenichi Ishigaki"),
	);

	$self->{m_staticText47229} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Korean"),
	);
	$self->{m_staticText47229}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText8129} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Keedi Kim"),
	);

	$self->{m_staticText472210} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Norwegian"),
	);
	$self->{m_staticText472210}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText81210} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Kjetil Skotheim"),
	);

	$self->{m_staticText472211} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Polish"),
	);
	$self->{m_staticText472211}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText81211} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Cezary Morga"),
	);

	$self->{m_staticText472212} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Portuguese (Brazil)"),
	);
	$self->{m_staticText472212}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText81212} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Breno G. de Oliveira"),
	);

	$self->{m_staticText71312} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Gabriel Vieira"),
	);

	$self->{m_staticText472213} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Spanish"),
	);
	$self->{m_staticText472213}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText81213} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Paco Alguacil"),
	);

	$self->{m_staticText71313} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Enrique Nell"),
	);

	$self->{m_staticText472214} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Russian"),
	);
	$self->{m_staticText472214}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText81214} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Andrew Shitov"),
	);

	$self->{m_staticText472215} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Turkish"),
	);
	$self->{m_staticText472215}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" )
	);

	$self->{m_staticText81215} = Wx::StaticText->new(
		$self->{m_panel11},
		-1,
		Wx::gettext("Burak Gursoy"),
	);

	$self->{m_panel12} = Wx::Panel->new(
		$self->{m_notebook3},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TAB_TRAVERSAL,
	);

	$self->{output} = Wx::TextCtrl->new(
		$self->{m_panel12},
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TE_MULTILINE | Wx::TE_NO_VSCROLL | Wx::TE_READONLY,
	);
	$self->{output}->SetMaxLength(62);
	$self->{output}->SetMinSize( [ -1, 400 ] );
	$self->{output}->SetFont(
		Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 76, 90, 90, 0, "" )
	);

	$self->{m_sdbSizer1_cancel} = Wx::Button->new(
		$self,
		Wx::ID_CANCEL,
	);

	my $bSizer471 = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$bSizer471->Add( $self->{m_staticText651}, 0, Wx::ALL, 5 );
	$bSizer471->Add( $self->{m_staticText6511}, 0, Wx::ALL, 5 );

	my $bSizer4711 = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$bSizer4711->Add( $self->{m_staticText65111}, 0, Wx::ALL, 5 );

	my $bSizer18 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer18->Add( $self->{splash}, 0, Wx::ALIGN_CENTER | Wx::ALL, 5 );

	my $bSizer81 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer81->Add( $self->{m_staticText67}, 0, Wx::ALL, 5 );
	$bSizer81->Add( $self->{m_staticline27}, 0, Wx::EXPAND | Wx::ALL, 5 );
	$bSizer81->Add( $self->{m_staticText34}, 0, Wx::ALL, 5 );
	$bSizer81->Add( $self->{m_staticline28}, 0, Wx::EXPAND | Wx::ALL, 5 );
	$bSizer81->Add( $self->{m_staticText35}, 0, Wx::ALL, 5 );

	my $bSizer17 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer17->Add( $bSizer471, 0, Wx::EXPAND, 5 );
	$bSizer17->Add( $bSizer4711, 0, Wx::EXPAND, 5 );
	$bSizer17->Add( $bSizer18, 1, Wx::EXPAND, 5 );
	$bSizer17->Add( $bSizer81, 0, Wx::EXPAND, 5 );

	$self->{m_panel9}->SetSizerAndFit($bSizer17);
	$self->{m_panel9}->Layout;

	my $bSizer6 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer6->Add( $self->{m_staticText47}, 0, Wx::ALL, 5 );
	$bSizer6->Add( $self->{m_staticline1}, 0, Wx::EXPAND | Wx::ALL, 5 );

	my $gSizer2 = Wx::GridSizer->new( 0, 2, 0, 0 );
	$gSizer2->Add( $self->{m_staticText1}, 0, Wx::ALL, 5 );
	$gSizer2->Add( $self->{m_staticText2}, 0, Wx::ALL, 5 );
	$gSizer2->Add( $self->{m_staticText3}, 0, Wx::ALL, 5 );
	$gSizer2->Add( $self->{m_staticText4}, 0, Wx::ALL, 5 );

	my $bSizer61 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer61->Add( $self->{m_staticText471}, 0, Wx::ALL, 5 );
	$bSizer61->Add( $self->{m_staticline11}, 0, Wx::EXPAND | Wx::ALL, 5 );

	my $gSizer3 = Wx::GridSizer->new( 0, 4, 0, 0 );
	$gSizer3->Add( $self->{m_staticText5}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText6}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText7}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText8}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText39}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText40}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText411}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText42}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText53}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText54}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText55}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText56}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText561}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText571}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText58}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText59}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText60}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText611}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText621}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText63}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText64}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText671}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText68}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText65}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText66}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText69}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText70}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText711}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText721}, 0, Wx::ALL, 5 );
	$gSizer3->Add( $self->{m_staticText73}, 0, Wx::ALL, 5 );

	my $bSizer3 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer3->Add( $bSizer6, 0, Wx::EXPAND, 5 );
	$bSizer3->Add( $gSizer2, 0, Wx::ALIGN_LEFT | Wx::EXPAND, 5 );
	$bSizer3->Add( $bSizer61, 0, Wx::EXPAND, 5 );
	$bSizer3->Add( $gSizer3, 0, Wx::EXPAND, 5 );

	$self->{m_panel10}->SetSizerAndFit($bSizer3);
	$self->{m_panel10}->Layout;

	my $bSizer623 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer623->Add( $self->{m_staticText4723}, 0, Wx::ALL, 4 );
	$bSizer623->Add( $self->{m_staticText813}, 0, Wx::ALL, 2 );

	my $bSizer621 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer621->Add( $self->{m_staticText4721}, 0, Wx::ALL, 4 );
	$bSizer621->Add( $self->{m_staticText811}, 0, Wx::ALL, 2 );
	$bSizer621->Add( $self->{m_staticText712}, 0, Wx::ALL, 2 );

	my $bSizer622 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer622->Add( $self->{m_staticText4722}, 0, Wx::ALL, 4 );
	$bSizer622->Add( $self->{m_staticText812}, 0, Wx::ALL, 2 );

	my $bSizer6221 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer6221->Add( $self->{m_staticText47221}, 0, Wx::ALL, 4 );
	$bSizer6221->Add( $self->{m_staticText8121}, 0, Wx::ALL, 2 );

	my $bSizer6222 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer6222->Add( $self->{m_staticText47222}, 0, Wx::ALL, 4 );
	$bSizer6222->Add( $self->{m_staticText8122}, 0, Wx::ALL, 2 );

	my $bSizer6223 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer6223->Add( $self->{m_staticText47223}, 0, Wx::ALL, 4 );
	$bSizer6223->Add( $self->{m_staticText8123}, 0, Wx::ALL, 2 );
	$bSizer6223->Add( $self->{m_staticText7133}, 0, Wx::ALL, 2 );

	my $bSizer6224 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer6224->Add( $self->{m_staticText47224}, 0, Wx::ALL, 4 );
	$bSizer6224->Add( $self->{m_staticText8124}, 0, Wx::ALL, 2 );
	$bSizer6224->Add( $self->{m_staticText7134}, 0, Wx::ALL, 2 );
	$bSizer6224->Add( $self->{m_staticText71341}, 0, Wx::ALL, 2 );

	my $bSizer6225 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer6225->Add( $self->{m_staticText47225}, 0, Wx::ALL, 5 );
	$bSizer6225->Add( $self->{m_staticText8125}, 0, Wx::ALL, 2 );
	$bSizer6225->Add( $self->{m_staticText7135}, 0, Wx::ALL, 2 );
	$bSizer6225->Add( $self->{m_staticText71351}, 0, Wx::ALL, 2 );

	my $bSizer6226 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer6226->Add( $self->{m_staticText47226}, 0, Wx::ALL, 5 );
	$bSizer6226->Add( $self->{m_staticText8126}, 0, Wx::ALL, 5 );

	my $bSizer6227 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer6227->Add( $self->{m_staticText47227}, 0, Wx::ALL, 4 );
	$bSizer6227->Add( $self->{m_staticText8127}, 0, Wx::ALL, 2 );

	my $bSizer6228 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer6228->Add( $self->{m_staticText47228}, 0, Wx::ALL, 4 );
	$bSizer6228->Add( $self->{m_staticText8128}, 0, Wx::ALL, 2 );

	my $bSizer6229 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer6229->Add( $self->{m_staticText47229}, 0, Wx::ALL, 4 );
	$bSizer6229->Add( $self->{m_staticText8129}, 0, Wx::ALL, 2 );

	my $bSizer62210 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer62210->Add( $self->{m_staticText472210}, 0, Wx::ALL, 4 );
	$bSizer62210->Add( $self->{m_staticText81210}, 0, Wx::ALL, 2 );

	my $bSizer62211 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer62211->Add( $self->{m_staticText472211}, 0, Wx::ALL, 4 );
	$bSizer62211->Add( $self->{m_staticText81211}, 0, Wx::ALL, 2 );

	my $bSizer62212 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer62212->Add( $self->{m_staticText472212}, 0, Wx::ALL, 4 );
	$bSizer62212->Add( $self->{m_staticText81212}, 0, Wx::ALL, 2 );
	$bSizer62212->Add( $self->{m_staticText71312}, 0, Wx::ALL, 2 );

	my $bSizer62213 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer62213->Add( $self->{m_staticText472213}, 0, Wx::ALL, 4 );
	$bSizer62213->Add( $self->{m_staticText81213}, 0, Wx::ALL, 2 );
	$bSizer62213->Add( $self->{m_staticText71313}, 0, Wx::ALL, 2 );

	my $bSizer62214 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer62214->Add( $self->{m_staticText472214}, 0, Wx::ALL, 4 );
	$bSizer62214->Add( $self->{m_staticText81214}, 0, Wx::ALL, 2 );

	my $bSizer62215 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer62215->Add( $self->{m_staticText472215}, 0, Wx::ALL, 4 );
	$bSizer62215->Add( $self->{m_staticText81215}, 0, Wx::ALL, 2 );

	my $gSizer311 = Wx::GridSizer->new( 0, 3, 0, 0 );
	$gSizer311->Add( $bSizer623, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer621, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer622, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer6221, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer6222, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer6223, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer6224, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer6225, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer6226, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer6227, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer6228, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer6229, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer62210, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer62211, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer62212, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer62213, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer62214, 0, Wx::EXPAND, 4 );
	$gSizer311->Add( $bSizer62215, 0, Wx::EXPAND, 4 );

	my $bSizer31 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer31->Add( $gSizer311, 0, Wx::EXPAND, 2 );

	$self->{m_panel11}->SetSizerAndFit($bSizer31);
	$self->{m_panel11}->Layout;

	my $bSizer32 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer32->Add( $self->{output}, 0, Wx::ALIGN_CENTER | Wx::ALL | Wx::EXPAND, 10 );

	$self->{m_panel12}->SetSizerAndFit($bSizer32);
	$self->{m_panel12}->Layout;

	$self->{m_notebook3}->AddPage( $self->{m_panel9}, Wx::gettext("Padre"), 1 );
	$self->{m_notebook3}->AddPage( $self->{m_panel10}, Wx::gettext("Development"), 0 );
	$self->{m_notebook3}->AddPage( $self->{m_panel11}, Wx::gettext("Translation"), 0 );
	$self->{m_notebook3}->AddPage( $self->{m_panel12}, Wx::gettext("System Info"), 0 );

	$self->{m_sdbSizer1} = Wx::StdDialogButtonSizer->new;
	$self->{m_sdbSizer1}->AddButton( $self->{m_sdbSizer1_cancel} );
	$self->{m_sdbSizer1}->Realize;

	my $bSizer45 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer45->Add( $self->{m_notebook3}, 0, Wx::EXPAND | Wx::ALL, 5 );
	$bSizer45->Add( $self->{m_sdbSizer1}, 1, Wx::EXPAND, 5 );

	$self->SetSizer($bSizer45);
	$self->Layout;

	return $self;
}

sub output {
	$_[0]->{output};
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

