#!/usr/bin/perl

use strict;
use warnings;
use Perl::Tidy ();

my $filename     = '../wx-scintilla/src/scintilla/include/Scintilla.iface';
my $constants_pm = '../lib/Wx/Scintilla/Constants.pm';

print "Parsing $filename\n";
open my $fh, $filename or die "Cannot open $filename\n";
my $source = <<'CODE';
use constant {
CODE
my $doc_comment = undef;
my $pod         = '';
while ( my $line = <$fh> ) {
    if ( $line =~ /^\s*$/ ) {

        # Empty line separator
        $doc_comment = undef;
        $source .= "\n";
    }
    elsif ( $line =~ /^##/ ) {

        # ignore pure comments
    }
    elsif ( $line =~ /^(get|fun)/ ) {

        # Ignore documentation comment for functions
        $doc_comment = undef;
    }
    elsif ( $line =~ /^(#.+?)$/ ) {

        # Store documentation comments
        $doc_comment .= "$1\n";

    }
    elsif ( $line =~ /^\s*enu\s+(\w+)\s*=\s*(\w+)\s*$/ ) {

        # Enumeration
        $doc_comment = "# $1 enumeration\n";

    }
    elsif ( $line =~ /^\s*val\s+(\w+)\s*=(.+?)\s*$/ ) {
        if ( defined $doc_comment ) {
            if ( $doc_comment =~ /#\s+(Lexical states for (?:.+?))$/ ) {
                $pod .= "\n=head2 $1\n\n";
            }
            elsif ( $doc_comment =~ /#\s(\S+\s(?:enumeration))/ ) {
                $pod .= "\n=head2 $1\n\n";
            }
            else {
                my $pod_comment = $doc_comment;
                $pod_comment =~ s/\s*#\s+//g;
                $pod .= "\n$pod_comment\n";
            }

            $source .= $doc_comment if defined $doc_comment;
            $doc_comment = undef;
        }
        $source .= "\t$1 => $2,\n";
        $pod .= sprintf( "\t%-30s (%s)\n", $1, $2 );
    }
}
close $fh;

$source .= <<"POD";
};

1;

__END__

=pod

=head1 NAME

Wx::Scintilla::Constants - A list of Wx::Scintilla constants

=head1 CONSTANTS

$pod

=head1 AUTHOR

Ahmad M. Zawawi <ahmad.zawawi\@gmail.com>

=head1 COPYRIGHT

Copyright 2011 Ahmad M. Zawawi.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=cut
POD

print "Perl tidy output in memory\n";
my $output = '';
Perl::Tidy::perltidy(
    source      => \$source,
    destination => \$output,
    argv        => '--indent-block-comments',
);

print "Writing to $constants_pm\n";
open my $constants_fh, '>', $constants_pm
  or die "Cannot open $constants_pm\n";
binmode $constants_fh;
print $constants_fh $output;
close $constants_fh;
