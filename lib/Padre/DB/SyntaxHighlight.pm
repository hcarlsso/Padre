package Padre::DB::SyntaxHighlight;

# NOTE: This class is loaded automatically by Padre::DB, overlaying the
# code already auto-generated by Padre::DB. Do not load manually, as this
# module will not function standalone.

# NOTE: Portable Perl support is NOT required for this class, as it does
# not contain any file paths.

use 5.008;
use strict;
use warnings;
use Padre::Current ();

our $VERSION = '0.81';

sub set_mime_type {
	my $class     = shift;
	my $mime_type = shift;
	my $module    = shift;

	my $transaction = Padre::Current->main->lock('DB');
	$class->delete(
		'where mime_type = ?', $mime_type,
	);
	$class->create(
		mime_type => $mime_type,
		value     => $module,
	);

	return;
}

1;

__END__

=pod

=head1 NAME

Padre::DB::SyntaxHighlight - Padre::DB class for the syntax_highlight table

=head1 SYNOPSIS

  my @files = Padre::DB::SyntaxHighlight->select(
      'where mime_type = ?', $mime_type,
  );

=head1 DESCRIPTION

This class allows storing in L<Padre>'s database the name of the 
syntax highlighter module.

=head1 METHODS

=head2 base

  # Returns 'Padre::DB'
  my $namespace = Padre::DB::SyntaxHighlight->base;

Normally you will only need to work directly with a table class,
and only with one ORLite package.

However, if for some reason you need to work with multiple ORLite packages
at the same time without hardcoding the root namespace all the time, you
can determine the root namespace from an object or table class with the
C<base> method.

=head2 table

  # Returns 'syntax_highlight'
  print Padre::DB::SyntaxHighlight->table;

While you should not need the name of table for any simple operations,
from time to time you may need it programatically. If you do need it,
you can use the C<table> method to get the table name.

=head2 load

  my $object = Padre::DB::SyntaxHighlight->load( $mime_type );

If your table has single column primary key, a C<load> method will be
generated in the class. If there is no primary key, the method is not
created.

The C<load> method provides a shortcut mechanism for fetching a single
object based on the value of the primary key. However it should only
be used for cases where your code trusts the record to already exists.

It returns a C<Padre::DB::SyntaxHighlight> object, or throws an exception if the
object does not exist.

=head2 select

  # Get all objects in list context
  my @list = Padre::DB::SyntaxHighlight->select;
  
  # Get a subset of objects in scalar context
  my $array_ref = Padre::DB::SyntaxHighlight->select(
      'where mime_type > ? order by mime_type',
      1000,
  );

The C<select> method executes a typical SQL C<SELECT> query on the
syntax_highlight table.

It takes an optional argument of a SQL phrase to be added after the
C<FROM syntax_highlight> section of the query, followed by variables
to be bound to the placeholders in the SQL phrase. Any SQL that is
compatible with SQLite can be used in the parameter.

Returns a list of B<Padre::DB::SyntaxHighlight> objects when called in list context, or a
reference to an C<ARRAY> of B<Padre::DB::SyntaxHighlight> objects when called in scalar
context.

Throws an exception on error, typically directly from the L<DBI> layer.

=head2 iterate

  Padre::DB::SyntaxHighlight->iterate( sub {
      print $_->mime_type . "\n";
  } );

The C<iterate> method enables the processing of large tables one record at
a time without loading having to them all into memory in advance.

This plays well to the strength of SQLite, allowing it to do the work of
loading arbitrarily large stream of records from disk while retaining the
full power of Perl when processing the records.

The last argument to C<iterate> must be a subroutine reference that will be
called for each element in the list, with the object provided in the topic
variable C<$_>.

This makes the C<iterate> code fragment above functionally equivalent to the
following, except with an O(1) memory cost instead of O(n).

  foreach ( Padre::DB::SyntaxHighlight->select ) {
      print $_->mime_type . "\n";
  }

You can filter the list via SQL in the same way you can with C<select>.

  Padre::DB::SyntaxHighlight->iterate(
      'order by ?', 'mime_type',
      sub {
          print $_->mime_type . "\n";
      }
  );

You can also use it in raw form from the root namespace for better control.
Using this form also allows for the use of arbitrarily complex queries,
including joins. Instead of being objects, rows are provided as C<ARRAY>
references when used in this form.

  Padre::DB->iterate(
      'select name from syntax_highlight order by mime_type',
      sub {
          print $_->[0] . "\n";
      }
  );

=head2 count

  # How many objects are in the table
  my $rows = Padre::DB::SyntaxHighlight->count;
  
  # How many objects 
  my $small = Padre::DB::SyntaxHighlight->count(
      'where mime_type > ?',
      1000,
  );

The C<count> method executes a C<SELECT COUNT(*)> query on the
syntax_highlight table.

It takes an optional argument of a SQL phrase to be added after the
C<FROM syntax_highlight> section of the query, followed by variables
to be bound to the placeholders in the SQL phrase. Any SQL that is
compatible with SQLite can be used in the parameter.

Returns the number of objects that match the condition.

Throws an exception on error, typically directly from the L<DBI> layer.

=head2 new

  TO BE COMPLETED

The C<new> constructor is used to create a new abstract object that
is not (yet) written to the database.

Returns a new L<Padre::DB::SyntaxHighlight> object.

=head2 create

  my $object = Padre::DB::SyntaxHighlight->create(

      mime_type => 'value',

      value => 'value',

  );

The C<create> constructor is a one-step combination of C<new> and
C<insert> that takes the column parameters, creates a new
L<Padre::DB::SyntaxHighlight> object, inserts the appropriate row into the
L<syntax_highlight> table, and then returns the object.

If the primary key column C<mime_type> is not provided to the
constructor (or it is false) the object returned will have
C<mime_type> set to the new unique identifier.
 
Returns a new L<syntax_highlight> object, or throws an exception on
error, typically from the L<DBI> layer.

=head2 insert

  $object->insert;

The C<insert> method commits a new object (created with the C<new> method)
into the database.

If a the primary key column C<mime_type> is not provided to the
constructor (or it is false) the object returned will have
C<mime_type> set to the new unique identifier.

Returns the object itself as a convenience, or throws an exception
on error, typically from the L<DBI> layer.

=head2 delete

  # Delete a single instantiated object
  $object->delete;
  
  # Delete multiple rows from the syntax_highlight table
  Padre::DB::SyntaxHighlight->delete('where mime_type > ?', 1000);

The C<delete> method can be used in a class form and an instance form.

When used on an existing B<Padre::DB::SyntaxHighlight> instance, the C<delete> method
removes that specific instance from the C<syntax_highlight>, leaving
the object intact for you to deal with post-delete actions as you wish.

When used as a class method, it takes a compulsory argument of a SQL
phrase to be added after the C<DELETE FROM syntax_highlight> section
of the query, followed by variables to be bound to the placeholders
in the SQL phrase. Any SQL that is compatible with SQLite can be used
in the parameter.

Returns true on success or throws an exception on error, or if you
attempt to call delete without a SQL condition phrase.

=head2 truncate

  # Delete all records in the syntax_highlight table
  Padre::DB::SyntaxHighlight->truncate;

To prevent the common and extremely dangerous error case where
deletion is called accidentally without providing a condition,
the use of the C<delete> method without a specific condition
is forbidden.

Instead, the distinct method C<truncate> is provided to delete
all records in a table with specific intent.

Returns true, or throws an exception on error.

=head1 ACCESSORS

=head2 mime_type

  if ( $object->mime_type ) {
      print "Object has been inserted\n";
  } else {
      print "Object has not been inserted\n";
  }

Returns true, or throws an exception on error.

REMAINING ACCESSORS TO BE COMPLETED

=head1 SQL

The syntax_highlight table was originally created with the
following SQL command.

  CREATE TABLE syntax_highlight (
      mime_type VARCHAR(255) PRIMARY KEY,
      value VARCHAR(255)
  )

=head1 SUPPORT

Padre::DB::SyntaxHighlight is part of the L<Padre::DB> API.

See the documentation for L<Padre::DB> for more information.

=head1 AUTHOR

Adam Kennedy E<lt>adamk@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2008-2011 The Padre development team as listed in Padre.pm.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
