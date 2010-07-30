package Madre::Sync::Model::padreDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

our $VERSION = '0.01';

__PACKAGE__->config(
	schema_class => 'Madre::Sync::Schema',
	connect_info => {
		dsn      => 'dbi:SQLite:db/data.db',
		user     => '',
		password => '',
	}
);

1;

__END__

=pod

=head1 NAME

Madre::Sync::Model::padreDB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Madre::Sync>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Madre::Sync::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.4

=head1 AUTHOR

Adam Kennedy E<lt>adamk@cpan.orgE<gt>

Matthew Phillips E<lt>mattp@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
