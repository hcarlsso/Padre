package Padre::Plugin::wxGlade;

=pod

=head1 NAME

Padre::Plugin::wxGlade - Utilities for importing Perl from wxGlade

=head1 DESCRIPTION

The wxGlade user interface design tool helps to produce user interface code
relatively quickly. However, the Perl code that is generates is incompatible
with Padre's L<Wx> usage style.

B<Padre::Plugin::wxGlade> provides a series of simple document transform tools
to assist with the process of cleaning up the raw Perl code generated by
wxGlade to something that will work properly with Padre.

=head1 METHODS

=cut

use 5.006;
use strict;
use warnings;
use Params::Util  '_INSTANCE';
use Padre::Wx     ();
use Padre::Plugin ();

our $VERSION = '0.01';
our @ISA     = 'Padre::Plugin';





#####################################################################
# Padre::Plugin Methods

sub padre_interfaces {
	'Padre::Plugin' => 0.42
}

sub plugin_name {
	'wxGlade Tools';
}

# Clean up our classes
sub plugin_disable {
	require Class::Unload;
	Class::Unload->unload('Padre::Plugin::wxGlade::WXG');
}

sub menu_plugins_simple {
	my $self = shift;
	return $self->plugin_name => [
		'Create Dialog from wxGlade Perl' => sub {
			$self->menu_new_dialog_perl;
		},
		'---' => undef,
		'Lexify Unimportant Variables' => sub {
			$self->menu_lexify_unimportant;
		},
		'Normalise Wx Constants' => sub {
			$self->menu_normalise_constants;
		},
	];
}





######################################################################
# Menu Commands

sub menu_new_dialog_perl {
	my $self = shift;
	my $main = $self->main;

	# Load the wxGlade-generated Perl file
	my $perl = $self->dialog_perl or return;

	# Which package do they want?
	my $packages = $self->package_list($perl);
	my $package  = $self->dialog_function($packages) or return;

	# Extract, clean and convert the package
	my $clean = $self->isolate_package( $perl, $package );
	unless ( $clean ) {
		$main->error("Failed to extract package '$package'");
		return;
	}

	# Create a new document
	$main->new_document_from_string( $clean, 'application/x-perl' );

	return;
}

sub menu_lexify_unimportant {
	my $self     = shift;
	my $document = $self->current->document or return;

	# Parse, transform, restore
	my $input  = $document->text_get;
	my $output = $self->lexify_unimportant($input);
	$document->text_set($output);

	return;
}

sub menu_normalise_constants {
	my $self     = shift;
	my $main     = $self->main;
	my $document = $self->current->document or return;
	unless ( _INSTANCE($document, 'Padre::Document::Perl') ) {
		$main->error("Not a Perl document");
	}

	# Parse, transform, restore
	my $ppi     = $document->ppi_get;
	my $changes = $self->constant_normalise($ppi);
	$document->ppi_set($ppi);

	return;
}






######################################################################
# Dialog Functions

sub dialog_perl {
	my $self = shift;
	my $main = $self->main;

	# Where is the wxGlade-generated Perl file
	my $dialog = Wx::FileDialog->new(
		$main,
		Wx::gettext("Select Perl File"),
		$main->cwd,
		"",
		"",
		Wx::wxFD_OPEN
		| Wx::wxFD_FILE_MUST_EXIST,
	);

	# File select loop
	while ( $dialog->ShowModal != Wx::wxID_CANCEL ) {
		# Check the file
		my $path = $dialog->GetPath;
		unless ( -f $path ) {
			$main->error("File '$path' does not exist");
			next;
		}
		my $text = _lslurp($path);
		unless ( $$text =~ /^#!.+?\n# generated by wxGlade/ ) {
			$main->error("File '$path' is not generated by wxGlade");
			next;
		}

		return $text;
	}

	return;
}

sub dialog_function {
	my $self = shift;
	my $main = $self->main;

	# Single choice dialog
	my $dialog = Wx::SingleChoiceDialog->new(
		$main,
		Wx::gettext('Select Dialog Package'),
		'Dialog Caption',
		$_[0], # Package ARRAY reference
		undef,
		Wx::wxDEFAULT_DIALOG_STYLE
		| Wx::wxOK
		| Wx::wxCANCEL,
	);
	my $rv = $dialog->ShowModal;
	if ( $rv == Wx::wxID_OK ) {
		return $dialog->GetStringSelection;
	}

	return;
}





######################################################################
# Support Methods

# Do a simple scan for package statements
sub package_list {
	my $self = shift;
	my $text = shift;
	return [
		sort
		grep { $_ ne 'main' }
		$$text =~ /\npackage ([\w:]+);/g
	];
}

sub parse_lines {
	my $self = shift;
	my $text = shift;

	# Build a statement set
	my $id    = 0;
	my @lines = map { +{
		id      => $id++,
		content => $_,
		names   => {
			map { $_ => 1 } /(\$self->{\w+}|\$\w+)/gs
		},
	} } split /\n/, $text;

	return \@lines;
}

sub isolate_package {
	my $self = shift;
	my $text = shift;
	my $name = shift;

	# Regex-match the package in the text
	unless ( $$text =~ /(package $name;.+)\# end of class $name\n+1;\n/s ) {
		return undef;
	}

	# Remove the wxglade comments and create the package
	my $code = $1;
	$code =~ s/# (?:begin|end) wxGlade[^\n]*\n+//gs;

	# Strip the class back to the essentials
	$code =~ s/^.+SUPER::new\(.+?\);\n//s;
	$code =~ s/^\S[^\n]*?\n//gm;
	$code =~ s/^\tmy \$self = shift;\n//gm;
	$code =~ s/^\treturn \$self;\n//gm;
	$code =~ s/^\t\$self->__set_properties\(\);\n//gm;
	$code =~ s/^\t\$self->__do_layout\(\);\n//gm;
	$code =~ s/^\t\$self->Layout\(\);//gm;
	$code =~ s/,\s+\);\n/);\n/gs;
	$code =~ s/(-\>\w+)\(\)/$1/gs;
	$code =~ s/\s*\n\t\t/ /gs;
	$code =~ s/\n+/\n/gs;

	return $code;
}

# Any variable that has an underscore and numbers at the end is considered
# something we won't need to address later, so turn them from object HASH
# elements into ordinary lexical variables.
sub lexify_unimportant {
	my $self = shift;
	my $text = shift;
	my %seen = ();
	$text =~ s/\$self->{(\w+_\d+)}/ ($seen{$1}++ ? '' : 'my ') . "\$$1" /ges;
	return $text;
}

sub constant_normalise {
	my $self     = shift;
	my $document = shift;
	my $mapping  = $self->constant_mapping;

	# Find symbols that looks like Wx constants
	my $list = $document->find( sub {
		$_[1]->isa('PPI::Token::Word')
		and
		$_[1]->content =~ /^(?:wx|EVT_)/
	} ) or return 0;

	# Transform them
	my $changes = 0;
	foreach my $constant ( @$list ) {
		my $name = $constant->{content};
		next unless $mapping->{$name};
		$constant->{content} = $mapping->{$name};
		$changes++;
	}

	return $changes;
}

# Get the list of real installed constants that are provided by
# the "use Wx ':everything' call made by Padre::Wx
sub constant_mapping {
	return {
		( map { $_ => "Wx::$_"        } @Wx::EXPORT_OK       ),
		( map { $_ => "Wx::Event::$_" } @Wx::Event::EVENT_OK ),
	};
}

# Reorder statements so they are bunched in an appropriate order
sub reorder_statements {
	my $self  = shift;
	my @lines = @{$_[0]};
	
}

# Provide a simple _slurp implementation (copied from PPI::Util)
# Avoids a 1 meg File::Slurp load.
sub _lslurp {
	my $file = shift;
	local $/ = undef;
	local *FILE;
	open( FILE, '<', $file ) or die("open($file) failed: $!");
	my $source = <FILE>;
	close( FILE ) or die("close($file) failed: $!");
	$source =~ s/(?:\015{1,2}\012|\015|\012)/\n/sg;
	return \$source;
}

1;

=pod

=head1 SUPPORT

Bugs should be reported via the CPAN bug tracker at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Padre-Plugin-wxGlade>

For other issues, or commercial enhancement or support, contact the author.

=head1 AUTHOR

Adam Kennedy E<lt>adamk@cpan.orgE<gt>

=head1 SEE ALSO

L<Padre>

=head1 COPYRIGHT

Copyright 2009 Adam Kennedy.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
