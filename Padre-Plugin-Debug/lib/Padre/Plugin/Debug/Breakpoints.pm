package Padre::Plugin::Debug::Breakpoints;

use 5.008;
use strict;
use warnings;

# Turn on $OUTPUT_AUTOFLUSH
# $| = 1;
# use diagnostics;
# use utf8;

# use English qw( -no_match_vars ); # Avoids regex performance penalty

our $VERSION = '0.13';

# use Data::Printer { caller_info => 1, colored => 1, };


#######
# function set_breakpoints_clicked
# this is a toggle function based on current status
#######
sub set_breakpoints_clicked {

	my $debug_breakpoints = ('Padre::DB::DebugBreakpoints');

	my $editor  = Padre::Current->editor;
	my $bp_file = $editor->{Document}->filename;
	my $bp_line = $editor->GetCurrentLine + 1;

	if ( $#{ $debug_breakpoints->select("WHERE filename = \"$bp_file\" AND line_number = \"$bp_line\"") } >= 0 ) {

		# say 'delete me';
		$editor->MarkerDelete( $bp_line - 1, Padre::Constant::MARKER_BREAKPOINT() );
		$editor->MarkerDelete( $bp_line - 1, Padre::Constant::MARKER_NOT_BREAKABLE() );
		$debug_breakpoints->delete("WHERE filename = \"$bp_file\" AND line_number = \"$bp_line\"");

	} else {

		# say 'create me';
		$editor->MarkerAdd( $bp_line - 1, Padre::Constant::MARKER_BREAKPOINT() );
		$debug_breakpoints->create(
			filename    => $bp_file,
			line_number => $bp_line,
			active      => 1,
			last_used   => time(),
		);
	}

	return;
}

#TODO finish when in trunk
#######
# function show_breakpoints
# to be called when showing current file
#######
sub show_breakpoints {

	my $editor            = Padre::Current->editor;
	my $debug_breakpoints = ('Padre::DB::DebugBreakpoints');
	my $bp_file           = $editor->{Document}->filename;
	my $sql_select        = "WHERE BY filename = \"$bp_file\" ASC, line_number ASC";
	my @tuples            = $debug_breakpoints->select($sql_select);

	for ( 0 .. $#tuples ) {

		if ( $tuples[$_][3] == 1 ) {
			$editor->MarkerAdd( $tuples[$_][2] - 1, Padre::Constant::MARKER_BREAKPOINT() );
		} else {
			$editor->MarkerAdd( $tuples[$_][2] - 1, Padre::Constant::MARKER_NOT_BREAKABLE() );
		}
	}
	return;
}

1;

__END__