package Padre::Plugin::Debug::Panel::Debugger;


use 5.010;
use strict;
use warnings;
use Padre::Constant ();
use Padre::Current  ();
use Padre::Wx       ();

# Turn on $OUTPUT_AUTOFLUSH
$| = 1;
use diagnostics;
use utf8;

use Padre::Logger qw(TRACE DEBUG);
use Padre::Wx::Role::View;
use Padre::Plugin::Debug::FBP::Debugger ();
use Data::Printer { caller_info => 1, colored => 1, };
our $VERSION = '0.13';

our @ISA = qw{
	Padre::Wx::Role::View
	Padre::Plugin::Debug::FBP::Debugger
};

use constant {
	BLANK      => qq{},
	RED        => Wx::Colour->new('red'),
	DARK_GREEN => Wx::Colour->new( 0x00, 0x90, 0x00 ),
	BLUE       => Wx::Colour->new('blue'),
	GRAY       => Wx::Colour->new('gray'),
	BLACK      => Wx::Colour->new('black'),
};


#######
# new
#######
# sub new { # todo use a better object constructor
# my $class = shift; # What class are we constructing?
# my $self  = {};    # Allocate new memory
# bless $self, $class; # Mark it of the right type
# $self->_init(@_);    # Call _init with remaining args
# return $self;
# } #new

# sub _init {
# my ( $self, $main, @args ) = @_;

# # 	$self->{main} = $main;

# # 	$self->{client}       = undef;
# $self->{file}         = undef;
# $self->{save}         = {};
# $self->{trace_status} = 'Trace = off';
# $self->{var_val}      = {};
# $self->{auto_var_val} = {};
# $self->{auto_x_var}   = {};
# $self->{set_bp}       = 0;
# $self->{fudge}        = 0;

# # 	return $self;
# } #_init


#######
# new
#######
sub new {
	my $class = shift;
	my $main  = shift;
	my $panel = shift || $main->right;

	# Create the panel
	my $self = $class->SUPER::new($panel);

	$self->set_up();

	return $self;
}

###############
# Make Padre::Wx::Role::View happy
###############

sub view_panel {
	my $self = shift;

	# This method describes which panel the tool lives in.
	# Returns the string 'right', 'left', or 'bottom'.

	return 'right';
}

sub view_label {
	my $self = shift;

	# The method returns the string that the notebook label should be filled
	# with. This should be internationalised properly. This method is called
	# once when the object is constructed, and again if the user triggers a
	# C<relocale> cascade to change their interface language.

	return Wx::gettext('Debugger');
}


sub view_close {
	my $self = shift;

	# This method is called on the object by the event handler for the "X"
	# control on the notebook label, if it has one.

	# The method should generally initiate whatever is needed to close the
	# tool via the highest level API. Note that while we aren't calling the
	# equivalent menu handler directly, we are calling the high-level method
	# on the main window that the menu itself calls.
	return;
}

#
#  sub view_icon {
#  	my $self = shift;
#
# 	# This method should return a valid Wx bitmap to be used as the icon for
# 	# a notebook page (displayed alongside C<view_label>).
# 	return;
# }
#
sub view_start {
	my $self = shift;

	# Called immediately after the view has been displayed, to allow the view
	# to kick off any timers or do additional post-creation setup.
	return;
}

sub view_stop {
	my $self = shift;

	# Called immediately before the view is hidden, to allow the view to cancel
	# any timers, cancel tasks or do pre-destruction teardown.
	return;
}

sub gettext_label {
	Wx::gettext('Debugger');
}
###############
# Make Padre::Wx::Role::View happy end
###############


#######
# Method set_up
#######
sub set_up {
	my $self = shift;
	my $main = $self->main;

	$self->{client}           = undef;
	$self->{file}             = undef;
	$self->{save}             = {};
	$self->{trace_status}     = 'Trace = off';
	$self->{var_val}          = {};
	$self->{auto_var_val}     = {};
	$self->{auto_x_var}       = {};
	$self->{set_bp}           = 0;
	$self->{fudge}            = 0;
	$self->{local_variables}  = 0;
	$self->{global_variables} = 0;

	#turn off unless in project
	$self->{show_global_variables}->Disable;

	# Setup the debug button icons
	$self->{debug}->SetBitmapLabel( Padre::Wx::Icon::find('actions/morpho2') );
	$self->{debug}->Enable;


	$self->{step_in}->SetBitmapLabel( Padre::Wx::Icon::find('actions/step_in') );
	$self->{step_in}->Hide;

	$self->{step_over}->SetBitmapLabel( Padre::Wx::Icon::find('actions/step_over') );
	$self->{step_over}->Hide;

	$self->{step_out}->SetBitmapLabel( Padre::Wx::Icon::find('actions/step_out') );
	$self->{step_out}->Hide;

	$self->{run_till}->SetBitmapLabel( Padre::Wx::Icon::find('actions/run_till') );
	$self->{run_till}->Hide;

	$self->{display_value}->SetBitmapLabel( Padre::Wx::Icon::find('stock/code/stock_macro-watch-variable') );
	$self->{display_value}->Hide;

	$self->{quit_debugger}->SetBitmapLabel( Padre::Wx::Icon::find('actions/red_cross') );
	$self->{quit_debugger}->Enable;
	
	$self->{trace}->Disable;
	$self->{sub_names}->Disable;
	$self->{sub_name_regex}->Disable;
	$self->{backtrace}->Disable;
	$self->{list_actions}->Disable;
	$self->{show_buffer}->Disable;
	

	# $self->{refresh}->Disable;

	# Setup columns names and order here
	my @column_headers = qw( Variable Value );
	my $index          = 0;
	for my $column_header (@column_headers) {
		$self->{variables}->InsertColumn( $index++, Wx::gettext($column_header) );
	}

	# Tidy the list
	Padre::Util::tidy_list( $self->{variables} );

	return;
}

#######
# Composed Method,
# display any relation db
#######
sub update_variables {
	my $self             = shift;
	my $var_val_ref      = shift;
	my $auto_var_val_ref = shift;
	my $auto_x_var_ref   = shift;

	my $item = Wx::ListItem->new;

	# clear ListCtrl items
	$self->{variables}->DeleteAllItems;

	my $editor = Padre::Current->editor;

	my $index = 0;

	foreach my $var ( keys %{$var_val_ref} ) {

		$item->SetId($index);
		$self->{variables}->InsertItem($item);
		$self->{variables}->SetItemTextColour( $index, BLACK );

		$self->{variables}->SetItem( $index,   0, $var );
		$self->{variables}->SetItem( $index++, 1, $var_val_ref->{$var} );
	}

	if ( $self->{local_variables} == 1 ) {
		foreach my $var ( keys %{$auto_var_val_ref} ) {

			$item->SetId($index);
			$self->{variables}->InsertItem($item);
			$self->{variables}->SetItemTextColour( $index, DARK_GREEN );

			$self->{variables}->SetItem( $index,   0, $var );
			$self->{variables}->SetItem( $index++, 1, $auto_var_val_ref->{$var} );
		}
	}
	if ( $self->{global_variables} == 1 ) {
		foreach my $var ( keys %{$auto_x_var_ref} ) {

			$item->SetId($index);
			$self->{variables}->InsertItem($item);
			$self->{variables}->SetItemTextColour( $index, GRAY );

			$self->{variables}->SetItem( $index,   0, $var );
			$self->{variables}->SetItem( $index++, 1, $auto_x_var_ref->{$var} );
		}
	}
	Padre::Util::tidy_list( $self->{variables} );

	return;
}


sub on_debug_clicked {
	my $self = shift;
	my $main = $self->main;

	$self->{quit_debugger}->Enable;
	$self->show_debug_output(1);
	$self->{step_in}->Show;
	$self->{step_over}->Show;
	$self->{step_out}->Show;
	$self->{run_till}->Show;
	$self->{display_value}->Show;
	
	$self->{trace}->Enable;
	$self->{sub_names}->Enable;
	$self->{sub_name_regex}->Enable;
	$self->{backtrace}->Enable;
	$self->{list_actions}->Enable;
	$self->{show_buffer}->Enable;
	
	
	$self->{debug}->Hide;
	$self->debug_perl;
	$main->aui->Update;
	return;
}


sub show_local_variables_checked {
	my ( $self, $event ) = @_;

	if ( $event->IsChecked ) {
		$self->{local_variables} = 1;
	} else {
		$self->{local_variables} = 0;
	}

	return;
}

sub show_global_variables_checked {
	my ( $self, $event ) = @_;

	if ( $event->IsChecked ) {
		$self->{global_variables} = 1;

		# say 'show_global_variables_checked yes';
	} else {
		$self->{global_variables} = 0;

		# say 'show_global_variables_checked no';
	}

	return;
}




#######
# sub debug_perl
#######
sub debug_perl {
	my $self     = shift;
	my $main     = $self->main;
	my $current  = Padre::Current->new;
	my $document = $current->document;
	my $editor   = $current->editor;

	# display panels
	$self->show_debug_output(1);

	# $self->show_debug_variable(1);

	if ( $self->{client} ) {
		$main->error( Wx::gettext('Debugger is already running') );
		return;
	}
	unless ( $document->isa('Padre::Document::Perl') ) {
		$main->error( Wx::gettext('Not a Perl document') );
		return;
	}

	# Apply the user's save-on-run policy
	# TO DO: Make this code suck less
	my $config = $main->config;
	if ( $config->run_save eq 'same' ) {
		$main->on_save;
	} elsif ( $config->run_save eq 'all_files' ) {
		$main->on_save_all;
	} elsif ( $config->run_save eq 'all_buffer' ) {
		$main->on_save_all;
	}

	# Get the filename
	my $filename = defined( $document->{file} ) ? $document->{file}->filename : undef;

	# TODO: improve the message displayed to the user
	# If the document is not saved, simply return for now
	return unless $filename;

	# Set up the debugger
	my $host = 'localhost';
	my $port = 12345 + int rand(1000); # TODO make this configurable?
	SCOPE: {
		local $ENV{PERLDB_OPTS} = "RemotePort=$host:$port";
		$main->run_command( $document->get_command( { debug => 1 } ) );
	}

	# Bootstrap the debugger
	require Debug::Client;
	$self->{client} = Debug::Client->new(
		host => $host,
		port => $port,
	);
	$self->{client}->listener;

	$self->{file} = $filename;

	my ( $module, $file, $row, $content ) = $self->{client}->get;

	my $save = ( $self->{save}->{$filename} ||= {} );

	# get bp's from db
	# $self->_get_bp_db();
	if ( $self->{set_bp} == 0 ) {

		# get bp's from db
		$self->_get_bp_db();
		$self->{set_bp} = 1;
		say "set_bp debug run";
	}

	unless ( $self->_set_debugger ) {
		$main->error( Wx::gettext('Debugging failed. Did you check your program for syntax errors?') );
		$self->debug_quit;
		return;
	}

	return 1;
}

#######
# sub _set_debugger
#######
sub _set_debugger {
	my $self    = shift;
	my $main    = $self->main;
	my $current = Padre::Current->new;

	my $editor = $current->editor            or return;
	my $file   = $self->{client}->{filename} or return;
	p $file;
	my $row = $self->{client}->{row} or return;

	# Open the file if needed
	if ( $editor->{Document}->filename ne $file ) {
		$main->setup_editor($file);
		$editor = $main->current->editor;
		$self->_show_bp_autoload();
	}

	$editor->goto_line_centerize( $row - 1 );

	#### TODO this was taken from the Padre::Wx::Syntax::start() and  changed a bit.
	# They should be reunited soon !!!! (or not)

	$editor->MarkerDeleteAll( Padre::Constant::MARKER_LOCATION() );
	$editor->MarkerAdd( $row - 1, Padre::Constant::MARKER_LOCATION() );

	# update variables and output
	$self->_output_variables();

	return 1;
}

#######
# sub running
#######
sub running {
	my $self = shift;
	my $main = $self->main;

	unless ( $self->{client} ) {
		# $main->message(
			# Wx::gettext(
				# "The debugger is not running.\nYou can start the debugger using one of the commands 'Step In', 'Step Over', or 'Run till Breakpoint' in the Debug menu."
			# ),
			# Wx::gettext('Debugger not running')
		# );
		return;
	}

	return !!Padre::Current->editor;
}

#######
# sub debug_perl_jumpt_to
#######
sub debug_perl_jumpt_to {
	my $self = shift;
	$self->running or return;
	$self->_set_debugger;
	return;
}

#######
# sub debug_quit
#######
sub debug_quit {
	my $self = shift;
	$self->running or return;

	# Clean up the GUI artifacts
	my $current = Padre::Current->new;

	# $current->main->show_debug(0);
	# $self->show_debug_output(0);
	# $self->show_debug_variable(0);
	$current->editor->MarkerDeleteAll( Padre::Constant::MARKER_LOCATION() );

	# Detach the debugger
	$self->{client}->quit;
	delete $self->{client};
	
	$self->{trace_status}     = 'Trace = off';
	$self->{trace}->SetValue(0);
	$self->{trace}->Disable;
	$self->{sub_names}->Disable;
	$self->{sub_name_regex}->Disable;
	$self->{backtrace}->Disable;
	$self->{list_actions}->Disable;
	$self->{show_buffer}->Disable;
	
	$self->{step_in}->Hide;
	$self->{step_over}->Hide;
	$self->{step_out}->Hide;
	$self->{run_till}->Hide;
	$self->{display_value}->Hide;
	
	$self->{var_val} = {};
	$self->{auto_var_val} = {};
	$self->{auto_x_var} = {};
	$self->update_variables( $self->{var_val}, $self->{auto_var_val}, $self->{auto_x_var} );
	
	$self->{debug}->Show;
	$self->show_debug_output(0);
	return;
}

#######
# Method debug_step_in
#######
sub debug_step_in {
	my $self = shift;
	my $main = $self->main;

	unless ( $self->{client} ) {
		unless ( $self->debug_perl ) {
			$main->error( Wx::gettext('Debugger not running') );
			return;
		}

# 		# No need to make first step
		return;
	}

	my ( $module, $file, $row, $content ) = $self->{client}->step_in;
	if ( $module eq '<TERMINATED>' ) {
		TRACE('TERMINATED') if DEBUG;
		$self->{trace_status} = 'Trace = off';
		$self->{panel_debug_output}->debug_status( $self->{trace_status} );
		$self->debug_quit;
		return;
	}

	# p $self->{client}->show_breakpoints();
	my $output = $self->{client}->buffer;
	$output .= "\n" . $self->{client}->get_y_zero();
	$self->{panel_debug_output}->debug_output($output);

	if ( $self->{set_bp} == 0 ) {

		# get bp's from db
		$self->_get_bp_db();
		$self->{set_bp} = 1;
		say "set_bp step in";
	}

	$self->_set_debugger;

	return;
}

#######
# Method debug_step_over
#######
sub debug_step_over {
	my $self = shift;
	my $main = $self->main;

	unless ( $self->{client} ) {
		unless ( $self->debug_perl ) {
			$main->error( Wx::gettext('Debugger not running') );
			return;
		}
	}

	my ( $module, $file, $row, $content ) = $self->{client}->step_over;
	if ( $module eq '<TERMINATED>' ) {
		TRACE('TERMINATED') if DEBUG;
		$self->{trace_status} = 'Trace = off';
		$self->{panel_debug_output}->debug_status( $self->{trace_status} );

		$self->debug_quit;
		return;
	}

	# $self->{client}->show_breakpoints();
	my $output = $self->{client}->buffer;
	$output .= "\n" . $self->{client}->get_y_zero();
	$self->{panel_debug_output}->debug_output($output);

	if ( $self->{set_bp} == 0 ) {
		$self->_get_bp_db();
		$self->{set_bp} = 1;
		say "set_bp step over";
	}

	$self->_set_debugger;

	return;
}

#######
# Method debug_run_till
#######
sub debug_run_till {
	my $self  = shift;
	my $param = shift;
	my $main  = $self->main;

	unless ( $self->{client} ) {
		unless ( $self->debug_perl ) {
			$main->error( Wx::gettext('Debugger not running') );
			return;
		}
	}

	my ( $module, $file, $row, $content ) = $self->{client}->run($param);
	if ( $module eq '<TERMINATED>' ) {
		TRACE('TERMINATED') if DEBUG;
		$self->{trace_status} = 'Trace = off';
		$self->{panel_debug_output}->debug_status( $self->{trace_status} );
		$self->debug_quit;
		return;
	}

	# $self->{client}->show_breakpoints();
	my $output = $self->{client}->buffer;
	$output .= "\n" . $self->{client}->get_y_zero();
	$self->{panel_debug_output}->debug_output($output);

	if ( $self->{set_bp} == 0 ) {
		$self->_get_bp_db();
		$self->{set_bp} = 1;
		say "set_bp run till";
	}

	$self->_set_debugger;

	return;
}

#######
# Method debug_step_out
#######
sub debug_step_out {
	my $self = shift;
	my $main = $self->main;

	unless ( $self->{client} ) {
		$main->error( Wx::gettext('Debugger not running') );
		return;
	}

	my ( $module, $file, $row, $content ) = $self->{client}->step_out;
	if ( $module eq '<TERMINATED>' ) {
		TRACE('TERMINATED') if DEBUG;
		$self->{trace_status} = 'Trace = off';
		$self->{panel_debug_output}->debug_status( $self->{trace_status} );

		$self->debug_quit;
		return;
	}

	# $self->{client}->show_breakpoints();
	my $output = $self->{client}->buffer;
	$output .= "\n" . $self->{client}->get_y_zero();
	$self->{panel_debug_output}->debug_output($output);

	if ( $self->{set_bp} == 0 ) {
		$self->_get_bp_db();
		$self->{set_bp} = 1;
		say "set_bp step out";
	}

	$self->_set_debugger;

	return;
}

#######
# sub display_trace
#######
sub display_trace {
	my $self = shift;

	$self->running or return;
	my $trace_on = ( @_ ? ( $_[0] ? 1 : 0 ) : 1 );

	if ( $trace_on == 1 && $self->{trace_status} eq 'Trace = on' ) {
		return;
	}

	if ( $trace_on == 1 && $self->{trace_status} eq 'Trace = off' ) {
		$self->{trace_status} = $self->{client}->toggle_trace;
		$self->{panel_debug_output}->debug_status( $self->{trace_status} );
		return;
	}

	if ( $trace_on == 0 && $self->{trace_status} eq 'Trace = off' ) {
		return;
	}

	if ( $trace_on == 0 && $self->{trace_status} eq 'Trace = on' ) {
		$self->{trace_status} = $self->{client}->toggle_trace;
		$self->{panel_debug_output}->debug_status( $self->{trace_status} );
		return;
	}

	return;
}
#######
# sub display_trace
#######
sub display_sub_names {
	my $self  = shift;
	my $regex = shift;

	$self->{panel_debug_output}->debug_output( $self->{client}->list_subroutine_names($regex) );

	return;
}
#######
# Event handler sub_names_clicked
#######
sub sub_names_clicked {
	my $self = shift;

	$self->{panel_debug_output}->debug_output( $self->{client}->list_subroutine_names($self->{sub_name_regex}->GetValue() ));

	return;
}
#######
# sub display_backtrace
#######
sub display_backtrace {
	my $self = shift;

	$self->{panel_debug_output}->debug_output( $self->{client}->get_stack_trace() );

	return;
}
#######
# Event handler backtrace_clicked
#######
sub backtrace_clicked {
	my $self = shift;

	$self->{panel_debug_output}->debug_output( $self->{client}->get_stack_trace() );

	return;
}
#######
# sub display_buffer pass through
#######
sub display_buffer {
	my $self = shift;

	$self->{panel_debug_output}->debug_output( $self->{client}->buffer() );

	return;
}
#######
# Event handler show_buffer_clicked
#######
sub show_buffer_clicked {
	my $self = shift;

	$self->{panel_debug_output}->debug_output( $self->{client}->buffer() );

	return;
}
#######
# sub display_list_actions pass through
#######
sub display_list_actions {
	my $self = shift;

	$self->{panel_debug_output}->debug_output( $self->{client}->show_breakpoints() );

	return;
}
#######
# Event handler list_actions_clicked
#######
sub list_actions_clicked {
	my $self = shift;

	$self->{panel_debug_output}->debug_output( $self->{client}->show_breakpoints() );

	return;
}
#######
#TODO Debug -> menu when in trunk
#######
# sub debug_perl_show_stack_trace {
# my $self = shift;
# $self->running or return;

# # 	my $trace = $self->{client}->get_stack_trace;
# my $str   = $trace;
# if ( ref($trace) and ref($trace) eq 'ARRAY' ) {
# $str = join "\n", @$trace;
# }
# $self->message($str);

# # 	return;
# }

#######
#TODO Debug -> menu when in trunk
#######
sub debug_perl_show_value {
	my $self = shift;
	my $main = $self->main;
	$self->running or return;

	my $text = $self->_debug_get_variable or return;

	my $value = eval { $self->{client}->get_value($text) };
	if ($@) {
		$main->error( sprintf( Wx::gettext("Could not evaluate '%s'"), $text ) );
		return;
	}
	say "text: $text => value: $value";
	$self->message("$text = $value");

	return;
}

#######
# sub _debug_get_variable$line
#######
sub _debug_get_variable {
	my $self     = shift;
	my $main     = $self->main;
	my $document = Padre::Current->document or return;

	#my $text = $current->text;
	my ( $location, $text ) = $document->get_current_symbol;

	# p $location;
	# p $text;
	if ( not $text or $text !~ m/^[\$@%\\]/smx ) {
		$main->error(
			sprintf(
				Wx::gettext(
					"'%s' does not look like a variable. First select a variable in the code and then try again."),
				$text
			)
		);
		return;
	}
	return $text;
}

#######
# Method display_value
#######
sub display_value {
	my $self = shift;
	$self->running or return;

	my $variable = $self->_debug_get_variable or return;

	$self->{var_val}{$variable} = BLANK;
	$self->update_variables( $self->{var_val} );

	return;
}

#######
#TODO Debug -> menu when in trunk
#######
sub debug_perl_evaluate_expression {
	my $self = shift;
	$self->running or return;

	my $expression = Padre::Current->main->prompt(
		Wx::gettext('Expression:'),
		Wx::gettext('Expr'),
		'EVAL_EXPRESSION'
	);
	$self->{client}->execute_code($expression);

	return;
}
#######
# Method quit
#######
sub quit {
	my $self = shift;
	if ( $self->{client} ) {
		$self->debug_quit;
	}
	return;
}

#######
# Composed Method _output_variables
#######
sub _output_variables {
	my $self = shift;

	foreach my $variable ( keys $self->{var_val} ) {
		my $value;
		eval { $value = $self->{client}->get_value($variable); };
		if ($@) {

			#ignore error
		} else {
			my $search_text = 'Use of uninitialized value';
			unless ( $value =~ m/$search_text/ ) {
				$self->{var_val}{$variable} = $value;
			}
		}
	}

	# only get local variables if required
	if ( $self->{local_variables} == 1 ) {
		$self->get_local_variables();
	}


	# Only enable global variables if we are debuging in a project
	# why dose $self->{project_dir} contain the root when no magic file present
	#TODO trying to stop debug X & V from crashing
	my @magic_files = qw { Makefile.PL Build.PL dist.ini };
	require File::Spec;
	foreach (@magic_files) {
		if ( -e File::Spec->catfile( $self->{project_dir}, $_ ) ) {

			$self->{show_global_variables}->Enable;
			if ( $self->{current_file} =~ m/[^(pm)]$/ ) {
				$self->{show_global_variables}->Disable;

				# get ride of stale values
				$self->{auto_x_var} = {};

			} else {
				$self->get_global_variables();
			}
		}
	}

	# the preciding global variables is due to errors from following
	# only get global variables if required
	# if ( $self->{global_variables} == 1 ) {
	# $self->get_global_variables();
	# }

	$self->update_variables( $self->{var_val}, $self->{auto_var_val}, $self->{auto_x_var} );

	return;
}

#######
# Composed Method get_variables
#######
sub get_local_variables {
	my $self = shift;

	my $auto_values = $self->{client}->get_y_zero();

	# p $auto_values;

	$auto_values =~ s/^([\$\@\%]\w+)/:;$1/xmg;

	# p $auto_values;

	my @auto = split m/^:;/xm, $auto_values;

	#remove ghost at begining
	shift @auto;

	# p @auto;

	# This is better I think, it's quicker
	$self->{auto_var_val} = {};
	foreach (@auto) {
		$_ =~ m/ = /;

		# $` before and $' after $#
		if ( defined $` ) {
			if ( defined $' ) {
				$self->{auto_var_val}{$`} = $';
			} else {
				$self->{auto_var_val}{$`} = BLANK;
			}
		}
	}

	return;
}

#######
# Composed Method get_variables
#######
sub get_global_variables {
	my $self = shift;

	my $var_regex   = '!(INC|ENV|SIG)';
	my $auto_values = $self->{client}->get_x_vars($var_regex);

	# p $auto_values;

	$auto_values =~ s/^((?:[\$\@\%]\w+)|(?:[\$\@\%]\S+)|(?:File\w+))/:;$1/xmg;

	# p $auto_values;

	my @auto = split m/^:;/xm, $auto_values;

	#remove ghost at begining
	shift @auto;

	# p @auto;

	# This is better I think, it's quicker
	$self->{auto_x_var} = {};

	foreach (@auto) {
		$_ =~ m/ = | => /;

		# $` before and $' after $#
		if ( defined $` ) {
			if ( defined $' ) {
				$self->{auto_x_var}{$`} = $';
			} else {
				$self->{auto_x_var}{$`} = BLANK;
			}
		}
	}

	# p $self->{auto_x_var};
	return;
}

#######
# Internal method _setup_db connector
#######
sub _setup_db {
	my $self = shift;

	# set padre db relation
	$self->{debug_breakpoints} = ('Padre::DB::DebugBreakpoints');

	# p $self->{debug_breakpoints};
	# p $self->{debug_breakpoints}->table_info;
	# p $self->{debug_breakpoints}->select;
	return;
}

#######
# Internal Method _get_bp_db
# display relation db
#######
sub _get_bp_db {
	my $self = shift;

	$self->_setup_db();
	my $editor = Padre::Current->editor;

	$self->{project_dir} = Padre::Current->document->project_dir;

	p $self->{project_dir};
	$self->{current_file} = Padre::Current->document->filename;

	# p $self->{current_file};

	TRACE("current file from _get_bp_db: $self->{current_file}") if DEBUG;

	my $sql_select = 'ORDER BY filename ASC, line_number ASC';
	my @tuples     = $self->{debug_breakpoints}->select($sql_select);

	for ( 0 .. $#tuples ) {

		if ( $tuples[$_][1] =~ m/$self->{current_file}/ ) {

			if ( $self->{client}->set_breakpoint( $tuples[$_][1], $tuples[$_][2] ) ) {
				$editor->MarkerAdd( $tuples[$_][2] - 1, Padre::Constant::MARKER_BREAKPOINT() );
			} else {
				$editor->MarkerAdd( $tuples[$_][2] - 1, Padre::Constant::MARKER_NOT_BREAKABLE() );

				#wright $tuples[$_][3] = 0
				Padre::DB->do( 'update debug_breakpoints SET active = ? WHERE id = ?', {}, 0, $tuples[$_][0], );
			}

		}

	}
	for ( 0 .. $#tuples ) {

		if ( $tuples[$_][1] =~ m/$self->{project_dir}/ ) {

			# set common project files bp's in debugger
			$self->{client}->set_breakpoint( $tuples[$_][1], $tuples[$_][2] );
		}
	}

	# $self->{client}->show_breakpoints();
	# my $output = $self->{client}->buffer;
	# $self->{panel_debug_output}->debug_output($output);

	return;
}

#######
# Composed Method, _show_bp_autoload
# for an autoloaded file (current) display breakpoints in editor if any
#######
sub _show_bp_autoload {
	my $self = shift;

	$self->_setup_db();

	#TODO is there a better way
	my $editor = Padre::Current->editor;
	$self->{current_file} = Padre::Current->document->filename;

	my $sql_select = "WHERE filename = \"$self->{current_file}\"";
	my @tuples     = $self->{debug_breakpoints}->select($sql_select);

	for ( 0 .. $#tuples ) {

		TRACE("show breakpoints autoload: self->{client}->set_breakpoint: $tuples[$_][1] => $tuples[$_][2]") if DEBUG;

		# autoload of breakpoints and mark file
		if ( $self->{client}->set_breakpoint( $tuples[$_][1], $tuples[$_][2] ) ) {
			$editor->MarkerAdd( $tuples[$_][2] - 1, Padre::Constant::MARKER_BREAKPOINT() );
		} else {
			$editor->MarkerAdd( $tuples[$_][2] - 1, Padre::Constant::MARKER_NOT_BREAKABLE() );

			#wright $tuples[$_][3] = 0
			Padre::DB->do( 'update debug_breakpoints SET active = ? WHERE id = ?', {}, 0, $tuples[$_][0], );
		}

	}

	# $self->{client}->show_breakpoints();
	# my $output = $self->{client}->buffer;
	# $self->{panel_debug_output}->debug_output($output);

	return;
}

########
# Panel Controler show debug output
########
sub show_debug_output {
	my $self = shift;
	my $main = $self->main;


	# This is the conditional operator. It works much like an if-then-else.
	# If the X is true then Y is evaluated and returned otherwise Z is evaluated and returned.

	# The context it is called in propagates to Y and Z, so if the operator is called in
	# scalar context and X is true then Y will be evaluated in scalar context.

	# The result of the operator is a valid lvalue (i.e. it can be assigned to).
	# Note, normal rules about lvalues (e.g. you can't assign to constants) still apply.
	my $show = ( @_ ? ( $_[0] ? 1 : 0 ) : 1 );


	# This needs to be added, to catch case not running
	if ( !$self->{panel_debug_output} && $show == 0 ) {
		return;
	}


	# Construct debug output panel if it is not there
	unless ( $self->{panel_debug_output} ) {
		require Padre::Plugin::Debug::Panel::DebugOutput;
		$self->{panel_debug_output} = Padre::Plugin::Debug::Panel::DebugOutput->new($main);
	}

	$self->_show_debug_output($show);

	$main->aui->Update;

	return;
}
########
# Panel Launcher show debug output
########
sub _show_debug_output {
	my $self = shift;
	my $main = $self->main;

	if ( $_[0] ) {
		$main->bottom->show( $self->{panel_debug_output} );
	} else {
		$main->bottom->hide( $self->{panel_debug_output} );
		delete $self->{panel_debug_output};
	}

	return;
}

########
# Panel Controler show debug output
########
# sub show_debug_variable {
# my $self = shift;
# my $main = $self->main;
# my $show = shift;

# This is the conditional operator. It works much like an if-then-else.
# If the X is true then Y is evaluated and returned otherwise Z is evaluated and returned.

# The context it is called in propagates to Y and Z, so if the operator is called in
# scalar context and X is true then Y will be evaluated in scalar context.

# The result of the operator is a valid lvalue (i.e. it can be assigned to).
# Note, normal rules about lvalues (e.g. you can't assign to constants) still apply.
# my $show = ( @_ ? ( $_[0] ? 1 : 0 ) : 1 );

# Construct debug output panel if it is not there
# unless ( $self->{panel_debug_variable} && $show == 1) {
# require Padre::Plugin::Debug::Panel::DebugVariable;
# $self->{panel_debug_variable} = Padre::Plugin::Debug::Panel::DebugVariable->new($main);
# }

# # 	$self->_show_debug_variable($show);

# # 	$main->aui->Update;

# # 	return;
# }
########
# Panel Launcher show debug variable
########
# sub _show_debug_variable {
# my $self = shift;
# my $main = $self->main;
# my $show = shift;

# # 	if ( $show == 1 ) {
# $main->right->show( $self->{panel_debug_variable} );
# } else {
# $main->right->hide( $self->{panel_debug_variable} );
# delete $self->{panel_debug_variable};
# }

# # 	return;
# }

#######
# sub step_in_clicked
#######
sub step_in_clicked {
	my $self = shift;

	TRACE('step_in_clicked') if DEBUG;
	$self->debug_step_in();

	# $self->{step_over}->Enable;
	# $self->{step_out}->Enable;
	# $self->{run_till}->Enable;
	# $self->{display_value}->Enable;
	# $self->{quit_debugger}->Enable;
	# $self->{trace}->Enable;
	# $self->{sub_names}->Enable;
	# $self->{sub_name_regex}->Enable;
	# $self->{backtrace}->Enable;
	# $self->{list_actions}->Enable;
	# $self->{show_buffer}->Enable;

	return;
}
#######
# sub step_over_clicked
#######
sub step_over_clicked {
	my $self = shift;

	TRACE('step_over_clicked') if DEBUG;
	$self->debug_step_over;

	return;
}
#######
# sub step_out_clicked
#######
sub step_out_clicked {
	my $self = shift;

	TRACE('step_out_clicked') if DEBUG;
	$self->debug_step_out;

	return;
}
#######
# sub run_till_clicked
#######
sub run_till_clicked {
	my $self = shift;

	TRACE('run_till_clicked') if DEBUG;
	$self->debug_run_till;

	return;
}
#######
# event handler breakpoint_clicked
#######
sub set_breakpoints_clicked {
	my $self = shift;

	TRACE('set_breakpoints_clicked') if DEBUG;
	$self->{panel_breakpoints}->set_breakpoints_clicked();

	return;
}
#######
# sub trace_clicked
#######
sub trace_checked {
	my ( $self, $event ) = @_;

	if ( $event->IsChecked ) {
		$self->display_trace(1);
	} else {
		$self->display_trace(0);
	}

	return;
}
#######
# sub display_value
#######
sub display_value_clicked {
	my $self = shift;

	TRACE('display_value') if DEBUG;
	$self->display_value();

	return;
}
#######
# sub quit_debugger_clicked
#######
sub quit_debugger_clicked {
	my $self = shift;

	# my $main = $self->main;

	TRACE('quit_debugger_clicked') if DEBUG;
	$self->debug_quit;

	# $self->{step_over}->Disable;
	# $self->{step_out}->Disable;
	# $self->{run_till}->Disable;
	# $self->{display_value}->Disable;
	# $self->{trace}->Disable;

	$self->show_debug_output(0);

	# $main->left->hide( $self->{panel_breakpoints} );
	# $self->{breakpoints}->SetValue(0);

	return;
}
1;


__END__

=pod

=head1 NAME

Padre::Wx::Debugger - Interface to the Perl debugger.

=head1 DESCRIPTION

Padre::Wx::Debugger provides a wrapper for the generalised L<Debug::Client>.

It should really live at Padre::Debugger, but does not currently have
sufficient abstraction from L<Wx>.

=head1 METHODS

=head2 new

Simple constructor.

=head2 debug_perl

  $main->debug_perl;

Run current document under Perl debugger. An error is reported if
current is not a Perl document.

Returns true if debugger successfully started.

=cut

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
