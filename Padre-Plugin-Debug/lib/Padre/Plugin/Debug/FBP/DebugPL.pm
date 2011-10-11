package Padre::Plugin::Debug::FBP::DebugPL;

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

	$self->{status} = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Status"),
	);

	$self->{m_textCtrl1} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	my $top_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$top_sizer->Add( $self->{status}, 1, Wx::ALIGN_CENTER_VERTICAL | Wx::ALL | Wx::EXPAND, 8 );

	my $main_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$main_sizer->Add( $top_sizer, 0, Wx::ALIGN_RIGHT | Wx::ALL | Wx::EXPAND, 2 );
	$main_sizer->Add( $self->{m_textCtrl1}, 1, Wx::ALL | Wx::EXPAND, 5 );

	$self->SetSizer($main_sizer);
	$self->Layout;

	return $self;
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

