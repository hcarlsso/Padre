package Padre::Config::Project;

use 5.008;
use strict;
use warnings;
use YAML::Tiny   ();
use Params::Util qw{_HASH0};

our $VERSION = '0.25';





######################################################################
# Constructor

sub new {
	my $class = shift;
	my $self  = bless { @_ }, $class;

	# Check the config

	return $self;
}

sub read {
	my $class = shift;

	# Check the file
	my $file = shift;
	unless ( defined $file and -f $file and -r $file ) {
		return;
	}

	# Load the user configuration
	my $hash = YAML::Tiny::LoadFile($file);
	return unless _HASH0($hash);

	# Create the object
	return $class->new( %$hash );
}

1;
