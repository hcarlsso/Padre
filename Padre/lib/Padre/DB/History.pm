package Padre::DB::History;

# This class is indented to be automatically loaded by Padre::DB,
# overlaying the code already auto-generated by Padre::DB.

use strict;
use warnings;
use Params::Util ();

our $VERSION = '0.27';

sub recent {
	my $class  = shift;
	my $type   = shift;
	my $limit  = Params::Util::_POSINT(shift) || 10;
	my $recent = Padre::DB->selectcol_arrayref(
		"select distinct name from history where type = ? order by id desc limit $limit",
		{}, $type,
	) or die "Failed to find recent values from history";
	return wantarray ? @$recent : $recent;
}

sub previous {
	my $class = shift;
	my @list  = $class->recent($_[0], 1);
	return $list[0];
}

1;

__END__

=pod

=head1 NAME

Padre::DB::History - Padre::DB class for the history table

=head1 SYNOPSIS

  TO BE COMPLETED

=head1 DESCRIPTION

TO BE COMPLETED

=head1 METHODS

=head2 recent

  # Get the values for a "Recent Files" menu
  my @files = Padre::DB::History->recent('files', 10);

The C<recent> method is non-ORLite method that is used to retrieve the
most recent distinct values for a particular history category.

It takes a compulory parameter of the history type to retrieve, and an
optional positive integer for the maximum number of distinct values to
retrieve (10 by default).

Returns a list of zero or more 'name' values in array context.

Returns a reference to an array of zero or more 'name' values in scalar context.

Throws an exception if the history query fails.

=head2 previous

  # Get the single most recent file
  my $file = Padre::DB::History->previous('files');

The C<previous> method is the single-value form of the C<recent> method.

It takes a compulsory parameter of the history type to retrieve.

Returns the single most recent value as a string.

Returns C<undef> if there are no values.

Throws an exception if the history query fails.

=head2 select

  # Get all objects in list context
  my @list = Padre::DB::History->select;
  
  # Get a subset of objects in scalar context
  my $array_ref = Padre::DB::History->select(
      'where id > ? order by id',
      1000,
  );

The C<select> method executes a typical SQL C<SELECT> query on the
history table.

It takes an optional argument of a SQL phrase to be added after the
C<FROM history> section of the query, followed by variables
to be bound to the placeholders in the SQL phrase. Any SQL that is
compatible with SQLite can be used in the parameter.

Returns a list of B<Padre::DB::History> objects when called in list context, or a
reference to an ARRAY of B<Padre::DB::History> objects when called in scalar context.

Throws an exception on error, typically directly from the L<DBI> layer.

=head2 count

  # How many objects are in the table
  my $rows = Padre::DB::History->count;
  
  # How many objects 
  my $small = Padre::DB::History->count(
      'where id > ?',
      1000,
  );

The C<count> method executes a C<SELECT COUNT(*)> query on the
history table.

It takes an optional argument of a SQL phrase to be added after the
C<FROM history> section of the query, followed by variables
to be bound to the placeholders in the SQL phrase. Any SQL that is
compatible with SQLite can be used in the parameter.

Returns the number of objects that match the condition.

Throws an exception on error, typically directly from the L<DBI> layer.

=head2 new

  TO BE COMPLETED

The C<new> constructor is used to create a new abstract object that
is not (yet) written to the database.

Returns a new L<Padre::DB::History> object.

=head2 create

  my $object = Padre::DB::History->create(

      id => 'value',

      type => 'value',

      name => 'value',

  );

The C<create> constructor is a one-step combination of C<new> and
C<insert> that takes the column parameters, creates a new
L<Padre::DB::History> object, inserts the appropriate row into the L<history>
table, and then returns the object.

If the primary key column C<id> is not provided to the
constructor (or it is false) the object returned will have
C<id> set to the new unique identifier.
 
Returns a new L<history> object, or throws an exception on error,
typically from the L<DBI> layer.

=head2 insert

  $object->insert;

The C<insert> method commits a new object (created with the C<new> method)
into the database.

If a the primary key column C<id> is not provided to the
constructor (or it is false) the object returned will have
C<id> set to the new unique identifier.

Returns the object itself as a convenience, or throws an exception
on error, typically from the L<DBI> layer.

=head2 delete

  # Delete a single instantiated object
  $object->delete;
  
  # Delete multiple rows from the history table
  Padre::DB::History->delete('where id > ?', 1000);

The C<delete> method can be used in a class form and an instance form.

When used on an existing B<Padre::DB::History> instance, the C<delete> method
removes that specific instance from the C<history>, leaving
the object ntact for you to deal with post-delete actions as you wish.

When used as a class method, it takes a compulsory argument of a SQL
phrase to be added after the C<DELETE FROM history> section
of the query, followed by variables to be bound to the placeholders
in the SQL phrase. Any SQL that is compatible with SQLite can be used
in the parameter.

Returns true on success or throws an exception on error, or if you
attempt to call delete without a SQL condition phrase.

=head2 truncate

  # Delete all records in the history table
  Padre::DB::History->truncate;

To prevent the common and extremely dangerous error case where
deletion is called accidentally without providing a condition,
the use of the C<delete> method without a specific condition
is forbidden.

Instead, the distinct method C<truncate> is provided to delete
all records in a table with specific intent.

Returns true, or throws an exception on error.

=head1 ACCESSORS

=head2 id

  if ( $object->id ) {
      print "Object has been inserted\n";
  } else {
      print "Object has not been inserted\n";
  }

Returns true, or throws an exception on error.


REMAINING ACCESSORS TO BE COMPLETED

=head1 SQL

The history table was originally created with the
following SQL command.

  CREATE TABLE history (id INTEGER PRIMARY KEY, type VARCHAR(100), name VARCHAR(100))

=head1 SUPPORT

Padre::DB::History is part of the L<Padre::DB> API.

See the documentation for L<Padre::DB> for more information.

=head1 AUTHOR

Adam Kennedy

=head1 COPYRIGHT

Copyright 2008-2009 The Padre development team as listed in Padre.pm.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

# Copyright 2008-2009 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
