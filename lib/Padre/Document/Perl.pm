package Padre::Document::Perl;

use 5.008;
use strict;
use warnings;
use Carp            ();
use Params::Util    '_INSTANCE';
use Padre::Document ();
use YAML::Tiny      ();
use PPI;

our $VERSION = '0.15';
our @ISA     = 'Padre::Document';





#####################################################################
# Padre::Document::Perl Methods

sub ppi_get {
	my $self = shift;
	my $text = $self->text_get;
	require PPI::Document;
	PPI::Document->new( \$text );
}

sub ppi_set {
	my $self     = shift;
	my $document = _INSTANCE(shift, 'PPI::Document');
	unless ( $document ) {
		Carp::croak("Did not provide a PPI::Document");
	}

	# Serialize and overwrite the current text
	$self->text_set( $document->serialize );
}

sub ppi_find {
	my $self     = shift;
	my $document = $self->ppi_get;
	return $document->find( @_ );
}

sub ppi_find_first {
	my $self     = shift;
	my $document = $self->ppi_get;
	return $document->find_first( @_ );
}

sub ppi_transform {
	my $self      = shift;
	my $transform = _INSTANCE(shift, 'PPI::Transform');
	unless ( $transform ) {
		Carp::croak("Did not provide a PPI::Transform");
	}

	# Apply the transform to the document
	my $document = $self->ppi_get;
	unless ( $transform->document($document) ) {
		Carp::croak("Transform failed");
	}
	$self->ppi_set($document);

	return 1;
}

sub ppi_select {
	my $self     = shift;
	my $location = shift;
	if ( _INSTANCE($location, 'PPI::Element') ) {
		$location = $location->location;
	}
	my $editor   = $self->editor or return;
	my $line     = $editor->PositionFromLine( $location->[0] - 1 );
	my $start    = $line + $location->[1] - 1;
	$editor->SetSelection( $start, $start + 1 );
}

my $keywords;

sub keywords {
	unless ( defined $keywords ) {
		$keywords = YAML::Tiny::LoadFile(
			Padre::Wx::sharefile( 'languages', 'perl5', 'perl5.yml' )
		);
	}
	return $keywords;
}

sub get_functions {
	my $self = shift;
	my $text = $self->text_get;
	return reverse sort $text =~ m{^sub\s+(\w+(?:::\w+)*)}gm;
}

sub get_function_regex {
	my ( $self, $sub ) = @_;
	return qr{sub\s+$sub\b};
}


sub get_command {
	my $self     = shift;

	# Check the file name
	my $filename = $self->filename;
	unless ( $filename =~ /\.pl$/i ) {
		die "Only .pl files can be executed\n";
	}

	# Run with the same Perl that launched Padre
	# TODO: get preferred Perl from configuration
	my $perl = Padre->perl_interpreter;

	my $dir = File::Basename::dirname($filename);
	chdir $dir;
	return qq{"$perl" "$filename"};
}

sub colourise {
	my ($self) = @_;
	
	$self->remove_color;

	my $editor = $self->editor;
	my $text   = $self->text_get;
	
	my $ppi_doc = PPI::Document->new( \$text );
	if (not defined $ppi_doc) {
		Wx::LogMessage( 'PPI::Document Error %s', PPI::Document->errstr );
		Wx::LogMessage( 'Original text: %s', $text );
		return;
	}
    #my @tokens = @{ $ppi_doc->find('PPI::Token') };

	# color 1 is for keywords
	my $keywords = $self->keywords;
    my %colors = (
		keyword   => 4,
		structure => 6,
		core      => 2,
		pragma    => 3,
		'PPI::Token::Whitespace' => 0,
		'PPI::Token::Structure'  => 0,

		'PPI::Token::Number'        => 0,
		'PPI::Token::Number::Float' => 0,
		
		'PPI::Token::HereDoc'       => 4,
		'PPI::Token::Data'          => 4,
		'PPI::Token::Operator'      => 6,
		'PPI::Token::Comment'       => 2, # it's good, it's green
		'PPI::Token::Pod'           => 2,
		'PPI::Token::End'           => 2,
		'PPI::Token::Word'          => 0, # stay the black
		'PPI::Token::Quote'            => 9,
		'PPI::Token::Quote::Single'    => 9,
		'PPI::Token::Quote::Double'      => 9,
		'PPI::Token::Quote::Interpolate'    => 9,
		'PPI::Token::QuoteLike' => 7,
		'PPI::Token::QuoteLike::Regexp'   => 7,
		'PPI::Token::QuoteLike::Words' => 7,
		'PPI::Token::QuoteLike::Readline' => 7,
		'PPI::Token::Regexp::Match'         => 3,
		'PPI::Token::Regexp::Substitute'    => 5,
		'PPI::Token::Regexp::Transliterate' => 5,
		'PPI::Token::Symbol'                => 0,
		'PPI::Token::Prototype' => 0,
		'PPI::Token::ArrayIndex' => 0,
		'PPI::Token::Cast' => 0,
		'PPI::Token::Magic' => 0,
		'PPI::Token::Magic' => 0,
    );

	my @tokens = $ppi_doc->tokens;
	$ppi_doc->index_locations;
	my $first = $editor->GetFirstVisibleLine();
	my $lines = $editor->LinesOnScreen();
	#print "First $first lines $lines\n";
	foreach my $t (@tokens) {
		#print $t->content;
		my ($row, $rowchar, $col) = @{ $t->location };
#		next if $row < $first;
#		next if $row > $first + $lines;
		my $css = $self->_css_class($t);
#		if ($row > $first and $row < $first + 5) {
#			print "$row, $rowchar, ", $t->length, "  ", $t->class, "  ", $css, "  ", $t->content, "\n";
#		}
#		last if $row > 10;
		my $color = $colors{$css};
		if (not defined $color) {
			Wx::LogMessage("Missing definition fir '$css'\n");
			next;
		}
		next if not $color;

		my $start  = $editor->PositionFromLine($row-1) + $rowchar-1;
		my $len = $t->length;

		$editor->StartStyling($start, $color);
		$editor->SetStyling($len, $color);
	}
}


sub _css_class {
	my ($self, $Token) = @_;
	if ( $Token->isa('PPI::Token::Word') ) {
		# There are some words we can be very confident are
		# being used as keywords
		unless ( $Token->snext_sibling and $Token->snext_sibling->content eq '=>' ) {
			if ( $Token->content eq 'sub' ) {
				return 'keyword';
			} elsif ( $Token->content eq 'return' ) {
				return 'keyword';
			} elsif ( $Token->content eq 'undef' ) {
				return 'core';
			} elsif ( $Token->content eq 'shift' ) {
				return 'core';
			} elsif ( $Token->content eq 'defined' ) {
				return 'core';
			}
		}

		if ( $Token->parent->isa('PPI::Statement::Include') ) {
			if ( $Token->content =~ /^(?:use|no)$/ ) {
				return 'keyword';
			}
			if ( $Token->content eq $Token->parent->pragma ) {
				return 'pragma';
			}
		} elsif ( $Token->parent->isa('PPI::Statement::Variable') ) {
			if ( $Token->content =~ /^(?:my|local|our)$/ ) {
				return 'keyword';
			}
		} elsif ( $Token->parent->isa('PPI::Statement::Compond') ) {
			if ( $Token->content =~ /^(?:if|else|elsif|unless|for|foreach|while|my)$/ ) {
				return 'keyword';
			}
		} elsif ( $Token->parent->isa('PPI::Statement::Package') ) {
			if ( $Token->content eq 'package' ) {
				return 'keyword';
			}
		} elsif ( $Token->parent->isa('PPI::Statement::Scheduled') ) {
			return 'keyword';
		}
	}

	# Normal colouring
	return $Token->class;
	my $css = lc ref $Token;
	$css =~ s/^.+:://;
	$css;
}

1;

# Copyright 2008 Gabor Szabo.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
