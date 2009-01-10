package Padre::Wx::Syntax;

use 5.008;
use strict;
use warnings;
use Params::Util qw{_INSTANCE};
use Padre::Wx    ();

our $VERSION = '0.25';
our @ISA     = 'Wx::ListView';

sub new {
	my $class = shift;
	my $main  = shift;

	# Create the underlying object
	my $self = $class->SUPER::new(
		$main->bottom,
		-1,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxLC_REPORT
		| Wx::wxLC_SINGLE_SEL
	);

	$self->InsertColumn( 0, Wx::gettext('Line')        );
	$self->InsertColumn( 1, Wx::gettext('Type')        );
	$self->InsertColumn( 2, Wx::gettext('Description') );

	Wx::Event::EVT_LIST_ITEM_ACTIVATED( $self,
		$self,
		sub {
			$self->list_item_activated($_[1]);
		},
	);

	$self->Hide;

	return $self;
}

sub bottom {
	$_[0]->GetParent;
}

sub main {
	$_[0]->GetGrandParent;
}

sub gettext_label {
	Wx::gettext('Syntax Check');
}

# Remove all markers and empty the list
sub clear {
	my $self = shift;

	# Remove the margins for the syntax markers
	foreach my $editor ( $self->main->editors ) {
		$editor->MarkerDeleteAll( Padre::Wx::MarkError );
		$editor->MarkerDeleteAll( Padre::Wx::MarkWarn  );		
	}

	# Remove all items from the tool
	$self->DeleteAllItems;

	return;
}





#####################################################################
# Timer Control

sub start {
	my $self = shift;

	# Add the margins for the syntax markers
	foreach my $editor ( $self->main->editors ) {
		# Margin number 1 for symbols
		$editor->SetMarginType(1, Wx::wxSTC_MARGIN_SYMBOL);

		# Set margin 1 16 px wide
		$editor->SetMarginWidth(1, 16);
	}

	# Set the column widths to use
	my $width0 = $self->GetCharWidth * ( length( Wx::gettext('Line') ) + 3 );
	my $width1 = $self->GetCharWidth * ( length( Wx::gettext('Type') ) + 3 );
	my $width2 = $self->GetSize->GetWidth - $width0 - $width1;
	$self->SetColumnWidth( 0, $width0 );
	$self->SetColumnWidth( 1, $width1 );
	$self->SetColumnWidth( 2, $width2 );

	if ( _INSTANCE($self->{timer}, 'Wx::Timer') ) {
		Wx::Event::EVT_IDLE( $self,
			sub {
				$self->on_idle($_[1]);
			},
		);
		$self->on_timer( undef, 1 );
	} else {
		$self->{timer} = Wx::Timer->new(
			$self,
			Padre::Wx::ID_TIMER_SYNTAX
		);
		Wx::Event::EVT_TIMER( $self,
			Padre::Wx::ID_TIMER_SYNTAX,
			sub {
				$self->on_timer($_[1], $_[2]);
			},
		);
		Wx::Event::EVT_IDLE( $self,
			sub {
				$self->on_idle($_[1]);
			},
		);
	}

	return;
}

sub stop {
	my $self = shift;

	# Stop the timer
	if ( _INSTANCE($self->{timer}, 'Wx::Timer') ) {
		$self->{timer}->Stop;
		Wx::Event::EVT_IDLE( $self, sub { return } );
	}

	# Clear out the existing data
	$self->clear;

	# Remove the editor margin
	foreach my $editor ( $self->main->editors ) {
		$editor->SetMarginWidth(1, 0);
	}

	return;
}

sub running {
	!! ($_[0]->{timer} and $_[0]->{timer}->IsRunning);
}





#####################################################################
# Event Handlers

sub on_list_item_activated {
	my $self   = shift;
	my $event  = shift;
	my $editor = $self->main->current->editor;
	my $line   = $event->GetItem->GetText;

	if (
		not defined($line)
		or $line !~ /^\d+$/o
		or $editor->GetLineCount < $line
	) {
		return;
	}

	$line--;
	$editor->EnsureVisible($line);
	$editor->GotoPos(
		$editor->GetLineIndentPosition($line)
	);
	$editor->SetFocus;

	return;
}

sub on_timer {
	my $self   = shift;
	my $event  = shift;
	my $force  = shift;
	my $editor = $self->main->current->editor or return;

	my $document = $editor->{Document};
	unless ( $document and $document->can('check_syntax') ) {
		$self->clear;
		return;
	}

	my $pre_exec_result = $document->check_syntax_in_background(force => $force);

	# In case we have created a new and still completely empty doc we
	# need to clean up the message list
	if ( ref $pre_exec_result eq 'ARRAY' && ! @{$pre_exec_result} ) {
		$self->clear;
	}

	if ( defined $event ) {
		$event->Skip(0);
	}

	return;
}

sub on_idle {
	my $self  = shift;
	my $event = shift;
	if ( $self->{timer}->IsRunning ) {
		$self->{timer}->Stop;
	}
	$self->{timer}->Start(300, 1);
	$event->Skip(0);
	return;
}

1;

# Copyright 2008 Gabor Szabo.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
