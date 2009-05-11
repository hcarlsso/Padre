#
# This file is part of Padre::Plugin::Nopaste.
# Copyright (c) 2009 Jerome Quelin, all rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#

package Padre::Plugin::Nopaste;

use strict;
use warnings;

use parent qw{ Padre::Plugin Padre::Task };

our $VERSION = '0.1.0';


# -- padre plugin api, refer to Padre::Plugin

# plugin name
sub plugin_name { 'Nopaste' }

# padre interface
sub padre_interface {
    'Padre::Plugin' => 0.28,
    'Padre::Task'   => 0.30,
}

# plugin menu.
sub menu_plugins_simple {
    my ($self) = @_;
    'Nopaste' => [
        "Nopaste\tCtrl+Shift+V" => 'schedule',  # launch thread, see Padre::Task
    ];
}


# -- padre task api, refer to Padre::Task

sub prepare {
    my ($self) = @_;

    my $main     = $self->main;
    my $current  = $main->current;
    my $editor   = $current->editor;
    return unless $editor;

    # no selection means send current file
    $self->{text} = $editor->GetSelectedText || $editor->GetText;
}


sub run {
    my ($self) = @_;

    require App::Nopaste;
    my $url = App::Nopaste::nopaste($self->{text});

    # show result in output section
    $self->task_print("\n");
    if ( defined $url ) {
        my $text = "Text successfully nopasted at: $url\n";
        $self->task_print($text);
    } else {
        my $text = "Error while nopasting text\n";
        $self->task_warn($text);
    }
}


# -- public methods


# -- private methods



1;
__END__

=head1 NAME

Padre::Plugin::Nopaste - send code on a nopaste website from padre



=head1 SYNOPSIS

    $ padre
    Ctrl+Shift+V



=head1 DESCRIPTION

This plugin allows one to send stuff from Padre to a nopaste website,
allowing for easy code / whatever sharing without having to open a
browser.

It is using C<App::Nopaste> underneath, so check this module's pod for
more information.


=head1 PUBLIC METHODS

=head2 Standard Padre::Plugin API

C<Padre::Plugin::Nopaste> defines a plugin which follows C<Padre::Plugin>
API. Refer to this module's documentation for more information.

The following methods are implemented:

=over 4

=item menu_plugins_simple()

=item padre_interface()

=item plugin_name()

=back



=head2 Standard Padre::Task API

In order not to freeze Padre during web access, nopasting is done in a thread,
as implemented by C<Padre::Task>. Refer to this module's documentation for more
information.

The following methods are implemented:

=over 4

=item * prepare()

=item * run()

=back



=head1 BUGS

Please report any bugs or feature requests to C<padre-plugin-nopaste at
rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Padre-Plugin-Nopaste>. I will
be notified, and then you'll automatically be notified of progress on
your bug as I make changes.



=head1 SEE ALSO

Our git repository is located at L<git://repo.or.cz/padre-plugin-nopaste.git>,
and can be browsed at L<http://repo.or.cz/w/padre-plugin-nopaste.git>.


You can also look for information on this module at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Padre-Plugin-Nopaste>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Padre-Plugin-Nopaste>

=item * Open bugs

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Padre-Plugin-Nopaste>

=back



=head1 AUTHOR

Jerome Quelin, C<< <jquelin@cpan.org> >>



=head1 COPYRIGHT & LICENSE

Copyright (c) 2009 Jerome Quelin, all rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
