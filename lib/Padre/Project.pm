package Padre::Project;

# Base project functionality for Padre

use 5.008;
use strict;
use warnings;
use File::Spec     ();
use YAML::Tiny     ();
use Padre::Config  ();
use Padre::Current ();

our $VERSION = '0.54';

use Class::XSAccessor {
	getters => {
		root      => 'root',
		padre_yml => 'padre_yml',
	}
};





######################################################################
# Class Methods

sub class {
	my $class = shift;
	my $root  = shift;
	unless ( -d $root ) {

		#		Carp::croak("Project directory '$root' does not exist");
		# Project root doesn't exist, this might cause problems
		# but croaking completly crashs Padre. Fix for #819
		Padre->ide->wx->main->error(
			sprintf(
				Wx::gettext(
					      'Project directory %s does not exist (any longer). '
						. 'This is fatal and will cause problems, please close or '
						. 'save-as this file unless you know what you are doing.'
				),
				$root
			)
		);
		return 'Padre::Project::Null';
	}
	if ( -f File::Spec->catfile( $root, 'Makefile.PL' ) ) {
		return 'Padre::Project::Perl';
	}
	if ( -f File::Spec->catfile( $root, 'Build.PL' ) ) {
		return 'Padre::Project::Perl';
	}
	if ( -f File::Spec->catfile( $root, 'dist.ini' ) ) {
		return 'Padre::Project::Perl';
	}
	if ( -f File::Spec->catfile( $root, 'padre.yml' ) ) {
		return 'Padre::Project';
	}
	return 'Padre::Project::Null';

}





######################################################################
# Constructor and Accessors

sub new {
	my $class = shift;
	my $self = bless {@_}, $class;

	# Check the root directory
	unless ( defined $self->root ) {
		Carp::croak("Did not provide a root directory");
	}
	unless ( -d $self->root ) {
		return undef;

		#		Carp::croak( "Root directory " . $self->root . " does not exist" );
	}

	# Check for a padre.yml file
	my $padre_yml = File::Spec->catfile(
		$self->root,
		'padre.yml',
	);
	if ( -f $padre_yml ) {
		$self->{padre_yml} = $padre_yml;
	}

	return $self;
}





######################################################################
# Configuration Support

sub config {
	my $self = shift;
	unless ( $self->{config} ) {

		# Get the default config object
		my $config = Padre::Current->config;

		# If we have a padre.yml file create a custom config object
		if ( $self->{padre_yml} ) {
			require Padre::Config::Project;
			$self->{config} = Padre::Config->new(
				$config->host,
				$config->human,
				Padre::Config::Project->read(
					$self->{padre_yml},
				),
			);
		} else {
			$self->{config} = Padre::Config->new(
				$config->host,
				$config->human,
			);
		}
	}
	return $self->{config};
}





######################################################################
# Directory Integration

# A file/directory pattern to support the directory browser.
# The function takes three parameters of the full file path,
# the directory path, and the file name.
# Returns true if the file is visible.
# Returns false if the file is ignored.
# This method is used to support the functionality of the directory browser.
sub ignore_rule {
	return sub {
		if ( $_->{name} =~ /^\./ ) {
			return 0;
		} else {
			return 1;
		}
	};
}

1;

# Copyright 2008-2010 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
