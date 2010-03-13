#!/usr/bin/perl

###
# Put any tests here which badly crash Padre
###

use strict;
use warnings;

# The real test...
package main;
use Test::More;

#use Test::NoWarnings;
use File::Temp ();
use File::Spec();

plan skip_all => 'DISPLAY not set'
 unless  $ENV{DISPLAY} or ($^O eq 'MSWin32');

# Don't run tests for installs
unless ( $ENV{AUTOMATED_TESTING} or $ENV{RELEASE_TESTING} ) {
	plan( skip_all => "Author tests not required for installation" );
}

my $devpl;
# Search for dev.pl
for ('.','blib/lib','lib') {
 if ($^O eq 'MSWin32') {
  next if ! -e File::Spec->catfile($_,'dev.pl');
 } else {
  next if ! -x File::Spec->catfile($_,'dev.pl');
 }
 $devpl = File::Spec->catfile($_,'dev.pl');
 last;
}

use_ok('Padre::Perl');

my $cmd;
if ($^O eq 'MSWin32') {
 # Look for Perl on Windows
 $cmd = Padre::Perl::cperl();
 plan skip_all => 'Need some Perl for this test' unless defined($cmd);
 $cmd .= ' ';
}

#plan( tests => scalar( keys %TEST ) * 2 + 20 );

# Create temp dir
my $dir = File::Temp->newdir;
$ENV{PADRE_HOME} = $dir->dirname;

# Complete the dev.pl - command
$cmd .= $devpl . ' --invisible -- --home=' . $dir->dirname;
$cmd .= ' ' . File::Spec->catfile($dir->dirname,'newfile.txt');
$cmd .= ' --actionqueue=file.new,edit.goto,edit.join_lines,edit.comment_toggle,edit.comment,edit.uncomment,edit.tabs_to_spaces,edit.spaces_to_tabs,edit.show_as_hex,help.current,help.about,file.quit';

my $output = `$cmd 2>&1`;

is($? & 127,0,'Check exitcode');
is($output,'','Check output');

done_testing();
