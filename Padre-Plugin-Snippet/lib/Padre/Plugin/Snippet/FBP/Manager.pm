package Padre::Plugin::Snippet::FBP::Manager;

## no critic

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module edit the original .fbp file and regenerate.
# DO NOT MODIFY THIS FILE BY HAND!

use 5.008005;
use utf8;
use strict;
use warnings;
use Padre::Wx             ();
use Padre::Wx::Role::Main ();
use Padre::Wx::Editor     ();

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
		Wx::gettext("Snippet Manager"),
		Wx::DefaultPosition,
		[ 441, 385 ],
		Wx::DEFAULT_DIALOG_STYLE | Wx::RESIZE_BORDER,
	);

	$self->{tree} = Wx::TreeCtrl->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TR_DEFAULT_STYLE | Wx::TR_HIDE_ROOT,
	);

	Wx::Event::EVT_TREE_SEL_CHANGED(
		$self,
		$self->{tree},
		sub {
			shift->on_tree_selection_change(@_);
		},
	);

	$self->{add_button} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{add_button}->SetToolTip( Wx::gettext("Add Snippet") );
	$self->{delete_button} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);
	$self->{delete_button}->SetToolTip( Wx::gettext("Delete Snippet") );
	$self->{delete_button}->SetToolTip( Wx::gettext("Delete Snippet") );

	$self->{trigger_label} = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Tab Trigger:"),
	);
	$self->{trigger_label}->SetFont( Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" ) );

	$self->{trigger_text} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{snippet_label} = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Snippet:"),
	);
	$self->{snippet_label}->SetFont( Wx::Font->new( Wx::NORMAL_FONT->GetPointSize, 70, 90, 92, 0, "" ) );

	$self->{snippet_editor} = Padre::Wx::Editor->new(
		$self,
		-1,
	);

	$self->{prefs_button} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("&Preferences"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{prefs_button},
		sub {
			shift->on_prefs_button_clicked(@_);
		},
	);

	$self->{close_button} = Wx::Button->new(
		$self,
		Wx::ID_CANCEL,
		Wx::gettext("&Close"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	my $tree_button_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$tree_button_sizer->Add( 0, 0, 1, Wx::EXPAND, 5 );
	$tree_button_sizer->Add( $self->{add_button},    0, Wx::ALL, 0 );
	$tree_button_sizer->Add( $self->{delete_button}, 0, Wx::ALL, 0 );
	$tree_button_sizer->Add( 0, 0, 1, Wx::EXPAND, 5 );

	my $left_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$left_sizer->Add( $self->{tree},      1, Wx::ALL | Wx::EXPAND, 5 );
	$left_sizer->Add( $tree_button_sizer, 0, Wx::EXPAND,           5 );

	my $form_sizer = Wx::FlexGridSizer->new( 2, 2, 0, 0 );
	$form_sizer->SetFlexibleDirection(Wx::BOTH);
	$form_sizer->SetNonFlexibleGrowMode(Wx::FLEX_GROWMODE_SPECIFIED);
	$form_sizer->Add( $self->{trigger_label}, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::ALL, 5 );
	$form_sizer->Add( $self->{trigger_text}, 0, Wx::ALL, 5 );

	my $right_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$right_sizer->Add( $form_sizer,             0, Wx::EXPAND,           5 );
	$right_sizer->Add( $self->{snippet_label},  0, Wx::ALL,              5 );
	$right_sizer->Add( $self->{snippet_editor}, 1, Wx::ALL | Wx::EXPAND, 5 );

	my $content_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$content_sizer->Add( $left_sizer,  1, Wx::EXPAND, 5 );
	$content_sizer->Add( $right_sizer, 2, Wx::EXPAND, 5 );

	my $button_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$button_sizer->Add( 0, 0, 1, Wx::EXPAND, 5 );
	$button_sizer->Add( $self->{prefs_button}, 0, Wx::ALL, 5 );
	$button_sizer->Add( $self->{close_button}, 0, Wx::ALL, 5 );

	my $sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$sizer->Add( $content_sizer, 1, Wx::EXPAND, 5 );
	$sizer->Add( $button_sizer,  0, Wx::EXPAND, 5 );

	$self->SetSizer($sizer);
	$self->Layout;

	return $self;
}

sub on_tree_selection_change {
	$_[0]->main->error('Handler method on_tree_selection_change for event tree.OnTreeSelChanged not implemented');
}

sub on_prefs_button_clicked {
	$_[0]->main->error('Handler method on_prefs_button_clicked for event prefs_button.OnButtonClick not implemented');
}

1;

# Copyright 2008-2012 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

