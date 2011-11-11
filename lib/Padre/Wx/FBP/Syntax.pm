package Padre::Wx::FBP::Syntax;

## no critic

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module edit the original .fbp file and regenerate.
# DO NOT MODIFY THIS FILE BY HAND!

use 5.008;
use strict;
use warnings;
use Padre::Wx ();
use Padre::Wx::Role::Main ();
use Padre::Wx::HtmlWindow ();
use Padre::Wx::TreeCtrl ();

our $VERSION = '0.93';
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
		[ 500, 300 ],
		Wx::TAB_TRAVERSAL,
	);

	$self->{tree} = Padre::Wx::TreeCtrl->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TR_FULL_ROW_HIGHLIGHT | Wx::TR_SINGLE,
	);

	Wx::Event::EVT_TREE_ITEM_ACTIVATED(
		$self,
		$self->{tree},
		sub {
			shift->on_tree_item_activated(@_);
		},
	);

	Wx::Event::EVT_TREE_SEL_CHANGED(
		$self,
		$self->{tree},
		sub {
			shift->on_tree_item_selection_changed(@_);
		},
	);

	$self->{help} = Padre::Wx::HtmlWindow->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::STATIC_BORDER,
	);

	$self->{show_stderr} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Show Standard Error"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{show_stderr},
		sub {
			shift->show_stderr(@_);
		},
	);

	my $bSizer38 = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$bSizer38->Add( $self->{tree}, 3, Wx::ALL | Wx::EXPAND, 0 );
	$bSizer38->Add( $self->{help}, 2, Wx::ALL | Wx::EXPAND, 0 );

	my $bSizer39 = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$bSizer39->Add( $self->{show_stderr}, 0, Wx::ALL | Wx::BOTTOM | Wx::TOP, 2 );

	my $bSizer37 = Wx::BoxSizer->new(Wx::VERTICAL);
	$bSizer37->Add( $bSizer38, 1, Wx::EXPAND, 0 );
	$bSizer37->Add( $bSizer39, 0, Wx::EXPAND, 0 );

	$self->SetSizer($bSizer37);
	$self->Layout;

	return $self;
}

sub on_tree_item_activated {
	$_[0]->main->error('Handler method on_tree_item_activated for event tree.OnTreeItemActivated not implemented');
}

sub on_tree_item_selection_changed {
	$_[0]->main->error('Handler method on_tree_item_selection_changed for event tree.OnTreeSelChanged not implemented');
}

sub show_stderr {
	$_[0]->main->error('Handler method show_stderr for event show_stderr.OnButtonClick not implemented');
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

