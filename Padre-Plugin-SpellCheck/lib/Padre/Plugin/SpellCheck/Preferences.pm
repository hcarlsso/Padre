package Padre::Plugin::SpellCheck::Preferences;

# ABSTRACT: Preferences dialog for padre spell check

use warnings;
use strict;

use Class::XSAccessor accessors => {
	_dict_combo => '_dict_combo', # combo box holding dictionary
	_plugin     => '_plugin',     # plugin to be configured
	_sizer      => '_sizer',      # window sizer
};

use Padre::Current;
use Padre::Wx   ();
use Padre::Util ('_T');

use base 'Wx::Dialog';


# -- constructor

sub new {
	my ( $class, $plugin ) = @_;

	# create object
	my $self = $class->SUPER::new(
		Padre::Current->main,
		-1,
		_T('Spelling preferences'),
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxDEFAULT_FRAME_STYLE | Wx::wxTAB_TRAVERSAL,
	);
	$self->SetIcon( Wx::GetWxPerlIcon() );
	$self->_plugin($plugin);

	# create dialog
	$self->_create;

	return $self;
}


# -- event handler

#
# $self->_on_butok_clicked;
#
# handler called when the ok button has been clicked.
#
sub _on_butok_clicked {
	my ($self) = @_;
	my $plugin = $self->_plugin;

	# read plugin preferences
	my $prefs = $plugin->config;

	# overwrite dictionary preference
	my $dic = $self->_dict_combo->GetValue;
	$prefs->{dictionary} = $dic;

	# store plugin preferences
	$plugin->config_write($prefs);
	$self->Destroy;
}


# -- private methods

#
# $self->_create;
#
# create the dialog itself.
#
# no params, no return values.
#
sub _create {
	my ($self) = @_;

	# create sizer that will host all controls
	my $sizer = Wx::BoxSizer->new(Wx::wxVERTICAL);
	$self->_sizer($sizer);

	# create the controls
	$self->_create_dictionaries;
	$self->_create_buttons;

	# setting focus on dictionary first
	$self->_dict_combo->SetFocus;

	# wrap everything in a vbox to add some padding
	$self->SetSizerAndFit($sizer);
	$sizer->SetSizeHints($self);
}

#
# $dialog->_create_buttons;
#
# create the buttons pane.
#
# no params. no return values.
#
sub _create_buttons {
	my ($self) = @_;
	my $sizer = $self->_sizer;

	my $butsizer = $self->CreateStdDialogButtonSizer( Wx::wxOK | Wx::wxCANCEL );
	$sizer->Add( $butsizer, 0, Wx::wxALL | Wx::wxEXPAND | Wx::wxALIGN_CENTER, 5 );
	Wx::Event::EVT_BUTTON( $self, Wx::wxID_OK, \&_on_butok_clicked );
}

#
# $dialog->_create_dictionaries;
#
# create the pane to choose the spelling dictionary.
#
# no params. no return values.
#
sub _create_dictionaries {
	my ($self) = @_;

	my $engine  = Padre::Plugin::SpellCheck::Engine->new( $self->_plugin );
	my @choices = $engine->dictionaries;
	my %choices = map { $_ => 1 } @choices;
	my $deflang = $self->_plugin->config->{dictionary};
	my $default = exists $choices{$deflang} ? $deflang : $choices[0];

	# create the controls
	my $label = Wx::StaticText->new( $self, -1, _T('Dictionary:') );
	my $combo = Wx::ComboBox->new(
		$self, -1,
		$default,
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		\@choices,
		Wx::wxCB_READONLY | Wx::wxCB_SORT,
	);
	$self->_dict_combo($combo);

	# pack the controls in a box
	my $box = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	$box->Add( $label, 0, Wx::wxALL | Wx::wxEXPAND | Wx::wxALIGN_CENTER, 5 );
	$box->Add( $combo, 1, Wx::wxALL | Wx::wxEXPAND | Wx::wxALIGN_CENTER, 5 );
	$self->_sizer->Add( $box, 0, Wx::wxALL | Wx::wxEXPAND | Wx::wxALIGN_CENTER, 5 );
}


1;

__END__

=head1 DESCRIPTION

This module implements the dialog window that will be used to set the
spell check preferences.



=head1 PUBLIC METHODS

=head2 Constructor

=over 4

=item my $dialog = PPS::Preferences->new( %params );

Create and return a new dialog window.


=back




=head1 SEE ALSO

For all related information (bug reporting, source code repository,
etc.), refer to L<Padre::Plugin::SpellCheck>.

=cut