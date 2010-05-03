package Padre::Task2::Addition;

use 5.008005;
use strict;
use warnings;
use Padre::Task2 ();

our $VERSION = '0.59';
our @ISA     = 'Padre::Task2';

sub new {
	shift->SUPER::new(
		prepare => 0,
		run     => 0,
		finish  => 0,
		@_,
	);
}

sub prepare {
	$_[0]->{prepare}++;
	return 1;
}

sub run {
	my $self = shift;
	$self->{run}++;
	$self->{z} = $self->{x} + $self->{y};
	return 1;
}

sub finish {
	$_[0]->{finish}++;
	return 1;
}

1;
