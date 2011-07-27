package Padre::Wx::Dialog::PerlFilter;

# Filter text through Perl source

use 5.008;
use strict;
use warnings;
use Padre::Wx             ();
use Padre::Wx::Icon       ();
use Padre::Wx::Role::Main ();

# RichTextCtrl
use Wx::RichText ();

our $VERSION = '0.89';
our @ISA     = qw{
	Padre::Wx::Role::Main
	Wx::Dialog
};


######################################################################
# Constructor

sub new {
	my $class  = shift;
	my $parent = shift;

	# Create the basic object
	my $self = $class->SUPER::new(
		$parent,
		-1,
		Wx::gettext('Perl Filter'),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxDEFAULT_FRAME_STYLE,
	);

	# Set basic dialog properties
	$self->SetIcon(Padre::Wx::Icon::PADRE);
	$self->SetMinSize( [ 380, 500 ] );

	# create sizer that will host all controls
	my $sizer = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$self->{sizer} = $sizer;

	# Create the controls
	$self->_create_controls($sizer);

	# Bind the control events
	$self->_bind_events;

	# Tune the size and position it appears
	$self->SetSizer($sizer);
	$self->Fit;
	$self->CentreOnParent;

	return $self;
}

sub _create_controls {
	my ( $self, $sizer ) = @_;

	# Dialog Controls, created in keyboard navigation order

	# Perl source
	my $source_label = Wx::StaticText->new( $self, -1, Wx::gettext('&Perl filter source:') );
	$self->{source} = Wx::TextCtrl->new(
		$self, -1, '', Wx::wxDefaultPosition, Wx::wxDefaultSize,
		Wx::wxRE_MULTILINE | Wx::wxWANTS_CHARS
	);

	# Input text
	my $original_label = Wx::StaticText->new( $self, -1, Wx::gettext('Or&iginal text:') );
	$self->{original_text} = Wx::TextCtrl->new(
		$self, -1, '', Wx::wxDefaultPosition, Wx::wxDefaultSize,
		Wx::wxTE_MULTILINE | Wx::wxNO_FULL_REPAINT_ON_RESIZE
	);

	# Matched readonly text field
	my $result_label = Wx::StaticText->new( $self, -1, Wx::gettext('&Output text:') );
	$self->{result_text} = Wx::RichTextCtrl->new(
		$self, -1, '', Wx::wxDefaultPosition, Wx::wxDefaultSize,
		Wx::wxRE_MULTILINE | Wx::wxRE_READONLY | Wx::wxWANTS_CHARS # Otherwise arrows will not work on win32
	);

	# Run the filter
	$self->{run_button} = Wx::Button->new(
		$self, -1, Wx::gettext('Run filter'),
	);

	# Insert result into current document button_name
	$self->{insert_button} = Wx::Button->new(
		$self, -1, Wx::gettext('Insert'),
	);

	# Close button
	$self->{close_button} = Wx::Button->new(
		$self, Wx::wxID_CANCEL, Wx::gettext('&Close'),
	);

	my $buttons = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$buttons->AddStretchSpacer;
	$buttons->Add( $self->{run_button},    0, Wx::wxALL, 1 );
	$buttons->Add( $self->{insert_button}, 0, Wx::wxALL, 1 );
	$buttons->Add( $self->{close_button},  0, Wx::wxALL, 1 );
	$buttons->AddStretchSpacer;

	# Dialog Layout

	# Vertical layout of the left hand side
	my $left = Wx::BoxSizer->new(Wx::wxVERTICAL);

	$left->Add( $source_label,   0, Wx::wxALL | Wx::wxEXPAND, 1 );
	$left->Add( $self->{source}, 1, Wx::wxALL | Wx::wxEXPAND, 1 );

	$left->Add( $original_label,        0, Wx::wxALL | Wx::wxEXPAND, 1 );
	$left->Add( $self->{original_text}, 1, Wx::wxALL | Wx::wxEXPAND, 1 );
	$left->Add( $result_label,          0, Wx::wxALL | Wx::wxEXPAND, 1 );
	$left->Add( $self->{result_text},   1, Wx::wxALL | Wx::wxEXPAND, 1 );
	$left->AddSpacer(5);
	$left->Add( $buttons, 0, Wx::wxALL | Wx::wxEXPAND, 1 );

	# Main sizer
	$sizer->Add( $left, 1, Wx::wxALL | Wx::wxEXPAND, 5 );
}

sub _bind_events {
	my $self = shift;

	# Wx::Event::EVT_KEY_DOWN(
	# $self,
	# sub {
	# my ($key_event) = $_[1];
	# $self->Hide if $key_event->GetKeyCode == Wx::WXK_ESCAPE;
	# return;
	# }
	# );
	Wx::Event::EVT_TEXT(
		$self,
		$self->{original_text},
		sub { $_[0]->run; },
	);

	# Wx::Event::EVT_KEY_DOWN(
	# $self->{source},
	# sub {
	# my ($key_event) = $_[1];
	# $self->Hide if $key_event->GetKeyCode == Wx::WXK_ESCAPE;
	# return;
	# }
	# );
	#
	# Wx::Event::EVT_KEY_DOWN(
	# $self->{original_text},
	# sub {
	# my ($key_event) = $_[1];
	# $self->Hide if $key_event->GetKeyCode == Wx::WXK_ESCAPE;
	# return;
	# }
	# );
	#
	# Wx::Event::EVT_KEY_DOWN(
	# $self->{result_text},
	# sub {
	# my ($key_event) = $_[1];
	# $self->Hide if $key_event->GetKeyCode == Wx::WXK_ESCAPE;
	# return;
	# }
	# );

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{run_button},
		sub { shift->run; },
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{insert_button},
		sub { shift->_insert_result; },
	);
}

#
# A private method that inserts the current regex into the current document
#
sub _insert_result {
	my $self = shift;

	my $editor = $self->current->editor or return;
	$editor->InsertText( $editor->GetCurrentPos, $self->{result_text}->GetValue );

	return;
}

# -- public methods

sub show {
	my $self = shift;

	if ( $self->IsShown ) {
		$self->SetFocus;
	} else {
		my $editor = $self->current->editor;

		# Insert sample, but do not overwrite an exisiting filter source
		$self->{source}->ChangeValue( Wx::gettext("# Input is in \$_\n\$_ = \$_;\n# Output goes to \$_\n") )
			unless $self->{source}->GetValue;

		if ($editor) {
			my $selection        = $editor->GetSelectedText;
			my $selection_length = length $selection;
			if ( $selection_length > 0 ) {
				$self->{original_text}->ChangeValue($selection);
			} else {
				$self->{original_text}->ChangeValue( $editor->GetText );
			}
		} else {
			$self->{original_text}->ChangeValue('');
		}

		$self->{result_text}->SetValue('');

		$self->Show;
	}

	$self->{source}->SetFocus;

	return;
}

#
# Returns the user input data of the dialog as a hashref
#
sub get_data {
	my $self = shift;

	my %data = (
		text => {
			source        => $self->{source}->GetValue,
			original_text => $self->{original_text}->GetValue,
			result_text   => $self->{result_text}->GetValue,
		},
	);

	return \%data;
}

#
# Sets the user input data of the dialog given a hashref containing the results of get_data
#
sub set_data {
	my ( $self, $data_ref ) = @_;

	foreach my $text_field ( keys %{ $data_ref->{text} } ) {
		$self->{$text_field}->SetValue( $data_ref->{text}->{$text_field} );
	}

	return;
}

sub run {
	my $self = shift;

	my $source        = $self->{source}->GetValue;
	my $original_text = $self->{original_text}->GetValue;

	$self->{result_text}->Clear;

	$_ = $original_text;
	my $result_text = eval $source;
	if ($@) {
		$result_text = Wx::gettext('Error') . ":\n" . $@;
	}

	if ( defined $result_text ) {
		$self->{result_text}->SetValue($result_text);
	}

	return;
}

1;

__END__

=pod

=head1 NAME

Padre::Wx::Dialog::PerlFilter - dialog to make it easy to create a regular expression

=head1 DESCRIPTION


The C<Regex Editor> provides an interface to easily create regular
expressions used in Perl.

The user can insert a regular expression (the surrounding C</> characters are not
needed) and a text. The C<Regex Editor> will automatically display the matching
text in the bottom right window.


At the top of the window the user can select any of the four
regular expression modifiers:

=over

=item Ignore case (i)

=item Single-line (s)

=item Multi-line (m)

=item Extended (x)

=back

Global match

Allow the change/replacement of the // around the regular expression

Highlight the match in the source text instead of in
a separate window

Display the captured groups in a tree hierarchy similar to Rx ?

  Group                  Span (character) Value
  Match 0 (Group 0)      4-7              the actual match

Display the various Perl variable containing the relevant values
e.g. the C<@-> and C<@+> arrays, the C<%+> hash
C<$1>, C<$2>...

point out what to use instead of C<$@> and C<$'> and C<$`>

English explanation of the regular expression

=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 The Padre development team as listed in Padre.pm.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5 itself.

=cut
