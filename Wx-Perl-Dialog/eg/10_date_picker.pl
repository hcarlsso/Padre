#!/usr/bin/perl

use 5.008;
use strict;
use warnings;

use lib 'lib';
use Wx::Perl::Dialog::Simple;

my $empty = date_picker() || '';
print "$empty\n";
message(text => $empty);

