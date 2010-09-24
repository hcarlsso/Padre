package Padre::Task::FindInFiles;

use 5.008;
use strict;
use warnings;
use File::Spec    ();
use Time::HiRes   ();
use Padre::Search ();
use Padre::Task   ();
use Padre::Logger;

our $VERSION = '0.71';
our @ISA     = 'Padre::Task';





######################################################################
# Constructor

sub new {
	my $self = shift->SUPER::new(@_);

	# Automatic project integration
	if ( exists $self->{project} ) {
		$self->{root} = $self->{project}->root;
		$self->{skip} = $self->{project}->ignore_skip;
		delete $self->{project};
	}

	# Property defaults
	unless ( defined $self->{skip} ) {
		$self->{skip} = [];
	}

	# Create the embedded search object
	unless ( $self->{search} ) {
		$self->{search} = Padre::Search->new(
			find_term  => $self->{find_term},
			find_case  => $self->{find_case},
			find_regex => $self->{find_regex},
		) or return;
	}

	return $self;
}





######################################################################
# Padre::Task Methods

sub run {
	require Module::Manifest;
	require Padre::Wx::Directory::Path;
	my $self  = shift;
	my $root  = $self->{root};
	my @queue = Padre::Wx::Directory::Path->directory;

	# Prepare the skip rules
	my $rule = Module::Manifest->new;
	$rule->parse( skip => $self->{skip} );

	# Recursively scan for files
	while (@queue) {
		my $parent = shift @queue;
		my @path   = $parent->path;
		my $dir    = File::Spec->catdir( $root, @path );

		# Read the file list for the directory
		# NOTE: Silently ignore any that fail. Anything we don't have
		# permission to see inside of them will just be invisible.
		opendir DIRECTORY, $dir or next;
		my @list = readdir DIRECTORY;
		closedir DIRECTORY;

		# Notify our parent we are working on this directory
		$self->handle->message( STATUS => "Searching... " . $parent->unix );

		foreach my $file (@list) {
			my $skip = 0;
			next if $file =~ /^\.+\z/;
			my $fullname = File::Spec->catdir( $dir, $file );
			my @fstat = stat($fullname);

			# Handle non-files
			if ( -d _ ) {
				my $object = Padre::Wx::Directory::Path->directory( @path, $file );
				next if $rule->skipped( $object->unix );
				unshift @queue, $object;
				next;
			}
			unless ( -f _ ) {
				warn "Unknown or unsupported file type for $fullname";
				next;
			}

			# This is a file
			my $object = Padre::Wx::Directory::Path->file( @path, $file );
			next if $rule->skipped( $object->unix );

			# Read the entire file
			open( my $fh, '<', $fullname ) or next;
			my $buffer = do { local $/; <$fh> };
			close $fh;

			# Hand off to the compiled search object
			my @lines = $self->{search}->match_lines(
				$buffer,
				$self->{search}->search_regex,
			);
			TRACE("Found " . scalar(@lines) . " matches in " . $fullname) if DEBUG;
			next unless @lines;

			# Found results, inform our owner
			$self->handle->message( OWNER => $object, @lines );
		}
	}

	# Notify our parent we are finished searching
	$self->handle->message( STATUS => '' );

	return 1;
}

1;

# Copyright 2008-2010 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
