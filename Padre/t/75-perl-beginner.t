#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::NoWarnings;
use Data::Dumper qw(Dumper);
use File::Spec   ();

my $tests;
plan tests => $tests+1;

use Padre::Document::Perl::Beginner;
my $b = Padre::Document::Perl::Beginner->new;

isa_ok $b, 'Padre::Document::Perl::Beginner';
BEGIN { $tests += 1; }

my %tests;
BEGIN {
	%tests = (
	'split1.pl'                    => "The second parameter of split is a string, not an array",
	'split2.pl'                    => "The second parameter of split is a string, not an array",
	'warning.pl'                   => "You need to write use warnings (with an s at the end) and not use warning.",
	'boolean_expressions_or.pl'    => 'TODO',
	'boolean_expressions_pipes.pl' => 'TODO',
	'match_default_scalar.pl'      => 'TODO',
	'chomp.pl'                     => 'TODO',
	'substitute_in_map.pl'         => 'TODO',
	);
}

foreach my $file (keys %tests) {
	if ($tests{$file} eq 'TODO') {
		TODO: {
			local $TODO = "$file not yet implemented";
			ok(0);
			ok(0);
		}
		next;
	}

	my $data = slurp (File::Spec->catfile('t', 'files', 'beginner', $file));
	ok(! defined($b->check($data)), $file);
	is($b->error, $tests{$file}, "$file error");
	BEGIN { $tests += 2 * keys %tests; }
}

sub slurp {
	my $file = shift;
	open my $fh, '<', $file or die $!;
	local $/ = undef;
	return <$fh>;
}