#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

BEGIN {
	unless ( $ENV{DISPLAY} or $^O eq 'MSWin32' ) {
		plan skip_all => 'Needs DISPLAY';
		exit 0;
	}
	plan tests => 9;
}

use Test::NoWarnings;
use t::lib::Padre;
use Padre::Wx;
use Padre;
use_ok('Padre::Wx::Dialog::Preferences');

# Create the IDE
my $padre = new_ok('Padre');
my $main  = $padre->wx->main;
isa_ok( $main, 'Padre::Wx::Main' );

# Create the Preferences 2.0 dialog
my $dialog = new_ok( 'Padre::Wx::Dialog::Preferences', [$main] );

# Check the listview properties
my $treebook = $dialog->treebook;
isa_ok( $treebook, 'Wx::Treebook' );

#my $listview = $treebook->GetListView;
#isa_ok( $listview, 'Wx::ListView' );
#is( $listview->,       8,   'Found siz items' );
#is( $listview->GetColumnCount,     0,   'Found one column' );
#is( $listview->GetColumnWidth(-1), 100, 'Got column width' );

# Load the dialog from configuration
my $config = $main->config;
isa_ok( $config, 'Padre::Config' );
ok( $dialog->config_load($config), '->load ok' );

# The diff (extracted from dialog) to the config should be null
my $diff = $dialog->config_diff($config);
is_deeply( $diff, undef, '->diff returns an empty HASH' );
