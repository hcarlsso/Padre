package Padre::Plugin::Debug::Panel::DebugVariable;

use 5.010;
use strict;
use warnings;

use Padre::Wx::Role::View;
use Padre::Plugin::Debug::FBP::DebugVariable ();
use Data::Printer { caller_info => 1, colored => 1, };
our $VERSION = '0.01';

our @ISA = qw{
	Padre::Wx::Role::View
	Padre::Plugin::Debug::FBP::DebugVariable
};

use constant {
	RED        => Wx::Colour->new('red'),
	DARK_GREEN => Wx::Colour->new( 0x00, 0x90, 0x00 ),
	BLUE       => Wx::Colour->new('blue'),
	GRAY       => Wx::Colour->new('gray'),
	BLACK      => Wx::Colour->new('black'),
};

#######
# new
#######
sub new {
	my $class = shift;
	my $main  = shift;
	my $panel = shift || $main->right;

	# 	# Create the panel
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

	return Wx::gettext('Debug Variables');
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
	Wx::gettext('Debug Variables');
}
###############
# Make Padre::Wx::Role::View happy end
###############


#######
# Method set_up
#######
sub set_up {
	my $self = shift;

	# $self->{debug_visable}       = 0;
	# $self->{breakpoints_visable} = 0;

	# Setup the debug button icons
	$self->{refresh}->SetBitmapLabel( Padre::Wx::Icon::find('actions/view-refresh') );
	$self->{refresh}->Enable;

# # 	$self->{set_breakpoints}->SetBitmapLabel( Padre::Wx::Icon::find('stock/code/stock_macro-insert-breakpoint') );
	# $self->{set_breakpoints}->Enable;

	# Update the checkboxes with their corresponding values in the
	# configuration
	# $self->{show_project}->SetValue(0);
	# $self->{show_project} = 0;

# # 	$self->_setup_db();('Variable') if $c == 0;
	# return Wx::gettext('Value')

	# Setup columns names and order here
	my @column_headers = qw( Variable Value );
	my $index          = 0;
	for my $column_header (@column_headers) {
		$self->{variables}->InsertColumn( $index++, Wx::gettext($column_header) );
	}

	# Tidy the list
	Padre::Util::tidy_list( $self->{variables} );

	# $self->on_refresh_click();

	return;
}

#######
# Composed Method,
# display any relation db
#######
sub update_variables {
	my $self = shift;
	my $var_val_ref = shift;

	my $item = Wx::ListItem->new;

	# clear ListCtrl items
	$self->{variables}->DeleteAllItems;

	my $editor = Padre::Current->editor;

	my $index = 0;

	foreach my $var ( keys %{ $var_val_ref } ) {

				$item->SetId($index);
				$self->{variables}->InsertItem($item);
				$self->{variables}->SetItemTextColour( $index, BLUE );

				$self->{variables}->SetItem( $index, 0, $var );
				$self->{variables}->SetItem( $index++, 1, $var_val_ref->{$var} );
			}

		Padre::Util::tidy_list( $self->{variables} );

	return;
}


sub on_refresh_click {
	my $self = shift;

	return;
}


sub on_show_package_click {
	my $self = shift;

	return;
}





1;

__END__
