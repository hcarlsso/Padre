package Padre::Pod::Frame;
use strict;
use warnings;

our $VERSION = '0.12';

use Data::Dumper qw(Dumper);

use Wx        qw(:everything);
use Wx::Event qw(:everything);

use base 'Wx::Frame';

use Padre::Pod::Viewer;

my $search_term = '';
my $choice;
my $choices;

sub new {
    my ($class) = @_;

    my $self = $class->SUPER::new( undef,
                                 -1,
                                 'PodViewer ',
                                 wxDefaultPosition,
                                 [750, 700],
                                 );
    $self->_setup_podviewer();
    $self->_create_menu_bar;
    return $self;
}


sub _setup_podviewer {
    my ($self) = @_;

    my $panel = Wx::Panel->new( $self, -1,);

    my $html    = Padre::Pod::Viewer->new( $panel, -1 );
    my $top_s   = Wx::BoxSizer->new( wxVERTICAL );
    my $but_s   = Wx::BoxSizer->new( wxHORIZONTAL );
    my $forward = Wx::Button->new( $panel, -1, "Forward" );
    my $back    = Wx::Button->new( $panel, -1, "Back" );
    $but_s->Add( $back );
    $but_s->Add( $forward );

    # TODO: remove magic values and just add the Choice box after the buttons
    # TODO: update list when a file is opened
    $choice = Wx::Choice->new(
        $panel,
        -1,
        [ 175, 5 ],
        [ -1, 32 ],
        [
            Padre::DB->get_recent_pod
        ]
    );
    EVT_CHOICE( $panel, $choice, \&on_selection );

    $choices = Padre::DB->find_modules;
    my @ch = @{$choices}[0..10];
    my $combobox = Wx::ComboBox->new($panel, -1, '', [375, 5], [-1, 32], []); #, $self->style);
    EVT_COMBOBOX(   $panel, $combobox, \&on_combobox);
    EVT_TEXT(       $panel, $combobox, sub { on_combobox_text_changed($combobox, @_) } );
    EVT_TEXT_ENTER( $panel, $combobox, \&on_combobox_text_enter);

    $top_s->Add( $but_s, 0, wxALL, 5 );
    $top_s->Add( $html,  1, wxGROW|wxALL, 5 );

    $panel->SetSizer( $top_s );
    $panel->SetAutoLayout( 1 );

    EVT_BUTTON( $panel, $back,    sub { on_back($self, @_)    } );
    EVT_BUTTON( $panel, $forward, sub { on_forward($self, @_) } );

    $self->{html} = $html;

    return;
}


sub on_combobox_text_changed {
    my ( $combobox, $self ) = @_;
    my $text              = $combobox->GetValue;
    my $choices           = Padre::DB->find_modules($text);
    my $pod_maxlist = Padre->ide->config->{pod_maxlist};
    my $pod_minlist = Padre->ide->config->{pod_minlist};
    if ( $pod_minlist < @$choices and @$choices < $pod_maxlist ) {
        $combobox->Clear;
        foreach my $name (@$choices) {
            $combobox->Append($name);
        }
    } elsif ($pod_maxlist < @$choices) {
        $combobox->Clear;
    }
    return;
}

sub on_combobox_text_enter {
    my ($self, $event) = @_;
    on_selection($self, $event);
}
sub on_combobox {
    my ($self, $event) = @_;
    on_selection($self, $event);
}

sub on_selection {
    my ($self, $event) = @_;
    my $current = $choice->GetCurrentSelection;
    my $module  = (Padre::DB->get_recent_pod)[$current];
    if ( $module ) {
        $self->{html}->display($module);
    } # TODO: else error message?
    return;
}

sub _create_menu_bar {
    my ($self) = @_;

    my $bar  = Wx::MenuBar->new;
    my $file = Wx::Menu->new;
    my $edit = Wx::Menu->new;
    $bar->Append( $file, "&File" );
    $bar->Append( $edit, "&Edit" );
    $self->SetMenuBar( $bar );

    EVT_MENU(  $self, $file->Append( wxID_OPEN, ''),  \&on_open);
    EVT_MENU(  $self, $file->Append( wxID_EXIT, ''),  sub { $self->Close } );
    EVT_MENU(  $self, $edit->Append( wxID_FIND, ''),  \&on_find);
   
    EVT_CLOSE( $self,             \&on_close);

    return;
}


sub on_find {
    my ( $self ) = @_;

    my $dialog = Wx::TextEntryDialog->new( $self, "", "Type in search term", $search_term );
    if ($dialog->ShowModal == wxID_CANCEL) {
        return;
    }   
    $search_term = $dialog->GetValue;
    $dialog->Destroy;
    return if not defined $search_term or $search_term eq '';

    my $text = $self->{html}->ToText();
    #use Wx::Point;
    #$self->{html}->SelectLine(Wx::Point->new(0,0));
    #$self->{html}->SelectLine(1);
    #my $point = $self->{html}->Point();
    #$self->{html}->SelectAll();
    print "$search_term\n";
    return;
}

sub on_open {
    my( $self ) = @_;

    my $dialog = Wx::TextEntryDialog->new( $self, "", "Type in module name", '' );
    if ($dialog->ShowModal == wxID_CANCEL) {
        return;
    }   
    my $module = $dialog->GetValue;
    $dialog->Destroy;
    return if not $module;

    my $path = $self->{html}->module_to_path($module);
    if (not $path) {
        # TODO put exclamation mark on the window!
        Wx::MessageBox( "Could not find module $module", "Invalid module name", wxOK|wxCENTRE, $self );
        return;
    }

    Padre::DB->add_recent_pod( $module);
    $self->{html}->display($module);

    return;
}

sub show {
    my ($self, $text) = @_;
    if (not $text) {
        # should not happen
        return;
    }
    # for now assume it is a module
    # later look it up in the indexed list of perl/module functions
    Padre::DB->add_recent_pod( $text);
    $self->{html}->display($text);

    return;
}


sub on_forward {
    my ( $self ) = @_;
    my $module = Padre->ide->next_module;
    if ( $module ) {
        $self->{html}->display($module);
    }
    return;
}

sub on_back {
    my ( $self ) = @_;
    my $module = Padre->ide->prev_module;
    if ( $module ) {
        $self->{html}->display($module);
    }
    return;
}

sub on_close {
    my ( $self, $event ) = @_;
    $self->Hide();
    #$event->Skip;
}


#sub OnClick {
#    my( $self, $event ) = @_;
#
#    $self->SetTitle( 'Clicked' );
#}


1;


