package Padre::Wx::AuiManager;

# Sub-class of Wx::AuiManager that implements various custom
# tweaks and behaviours.

use strict;
use warnings;
use Params::Util qw{_INSTANCE};
use Padre::Wx    ();

our $VERSION = '0.30';

# Due to an overly simplistic implementation at the C level,
# Wx::AuiManager is only a SCALAR reference and cannot be
# sub-classed.
# Instead, we will do inheritance by composition.
use Class::Adapter::Builder
	ISA      => 'Wx::AuiManager',
	AUTOLOAD => 1;

# The custom AUI Manager takes the parent window as a param
sub new {
	my $class  = shift;
	my $object = Wx::AuiManager->new;
	my $self   = $class->SUPER::new( $object );

	# Locale caption gettext values
	$self->{caption} = {};

	# Set the managed window
	$self->SetManagedWindow($_[0]);

	# Set/fix the flags
	# Do NOT use hints other than Rectangle on Linux/GTK
	# or the app will crash.
	my $flags = $self->GetFlags;
	$flags &= ~Wx::wxAUI_MGR_TRANSPARENT_HINT;
	$flags &= ~Wx::wxAUI_MGR_VENETIAN_BLINDS_HINT;
	$self->SetFlags( $flags ^ Wx::wxAUI_MGR_RECTANGLE_HINT );

	return $self;
}

sub caption {
	my $self = shift;
	$self->{caption}->{$_[0]} = $_[1];
	$self->GetPane($_[0])->Caption( $_[1] );
	return 1;
}

sub relocale {
	my $self = shift;

	# Update the pane captions
	foreach my $name ( sort keys %{ $self->{caption} } ) {
		my $pane = $self->GetPane($name) or next;
		$pane->Caption( Wx::gettext($self->{caption}->{$name}) );
	}

	return $self;
}

# Set the lock status of the panels
sub lock_panels {
	my $self   = shift;
	my $unlock = $_[0] ? 0 : 1;

	$self->Update;

	$self->GetPane('bottom')
		->CaptionVisible($unlock)
		->Floatable($unlock)
		->Dockable($unlock)
		->Movable($unlock);

	$self->GetPane('right')
		->CaptionVisible($unlock)
		->Floatable($unlock)
		->Dockable($unlock)
		->Movable($unlock);

	$self->Update;

	return;
}

# This is so wrong that I am even reluctant to describe it.
# We're seeing occasional double-frees from the Wx::AuiManager
# DESTROY XSUB. That will give a segmentation fault during
# global destruction.
# Now, I failed to track down WHY perl tries to call DESTROY
# multiple times. Maybe it's related to Class::Adapter::Builder,
# but I don't want to go around pointing fingers.
# What we'll do below is trade the SEGV for a small leak.
# We check whether the specific object at hand had been
# DESTROYed earlier and if so, we do nothing. If it hasn't been
# DESTROYed yet, we mark it as an ex-AUIManager and proceed to
# call the DESTROY XSUB.
# You may be appropriately appalled now. --Steffen

# PS: Uncomment those lines for getting a "manual" stack
#     trace. Calling cluck() or similar during global destruction
#     won't work.
# PPS: Anybody who manages to fix this for real AND explain to me
#      what the HELL is happening will get a beer on the next
#      occasion!
{
	no warnings 'redefine';
	no strict;
	my $destroy = \&Wx::AuiManager::DESTROY;
	my %destroyed_managers;
	*Wx::AuiManager::DESTROY = sub {
#		print "$_[0]\n";
#		my $i = 0;
#		while (1) {
#			my @c = caller($i++);
#			last if @c < 3;
#			print "$i: $c[0] - $c[1] - $c[2] - $c[3]\n";
#		}

		if (not exists $destroyed_managers{"$_[0]"}) {
			$destroyed_managers{"$_[0]"}++;
			goto &$destroy;
		}
	};
}


1;
# Copyright 2008-2009 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself
