package Padre::Document::Perl::Help;

use 5.008;
use strict;
use warnings;
use Pod::Functions;
use Cwd         ();
use Padre::Util ();
use Padre::Help ();
use Padre::Logger;

our $VERSION = '0.56';
our @ISA     = 'Padre::Help';

# for caching help list (for faster access)
my ( $cached_help_list, $cached_perlopref );

# Initialize help
sub help_init {
	my $self = shift;

	# serve the cached copy if it is already built
	if ($cached_help_list) {
		$self->{help_list} = $cached_help_list;
		$self->{perlopref} = $cached_perlopref;
		return;
	}

	my @index = ();

	# The categorization has been "borrowed" from
	# http://github.com/jonallen/perldoc.perl.org/tree
	# In lib/PerlDoc/Section.pm

	# Overview
	push @index, qw/perl perlintro perlrun perlbook perlcommunity/;

	# Tutorials
	push @index, qw/perlreftut perldsc perllol perlrequick
		perlretut perlboot perltoot perltooc perlbot
		perlstyle perlcheat perltrap perldebtut
		perlopentut perlpacktut perlthrtut perlothrtut
		perlxstut perlunitut perlpragma/;

	# FAQ
	push @index, qw/perlunifaq perlfaq1 perlfaq2 perlfaq3
		perlfaq4 perlfaq5 perlfaq6 perlfaq7 perlfaq8 perlfaq9/;

	# Language reference
	push @index, qw/perlsyn perldata perlsub perlop
		perlfunc perlpod perlpodspec perldiag
		perllexwarn perldebug perlvar perlre
		perlreref perlref perlform perlobj perltie
		perldbmfilter perlipc perlfork perlnumber
		perlport perllocale perluniintro perlunicode
		perlebcdic perlsec perlmod perlmodlib
		perlmodstyle perlmodinstall perlnewmod
		perlcompile perlfilter perlglossary CORE/;

	# Internals
	push @index, qw/perlembed perldebguts perlxs perlxstut
		perlclib perlguts perlcall perlapi perlintern
		perliol perlapio perlhack perlreguts perlreapi/;

	# History
	push @index, qw/perlhist perltodo perldelta/;

	# license
	push @index, qw/perlartistic perlgpl/;

	# Platform Specific
	push @index, qw/perlaix perlamiga perlapollo perlbeos perlbs2000
		perlce perlcygwin perldgux perldos perlepoc
		perlfreebsd perlhpux perlhurd perlirix perllinux
		perlmachten perlmacos perlmacosx perlmint perlmpeix
		perlnetware perlos2 perlos390 perlos400
		perlplan9 perlqnx perlsolaris perlsymbian perltru64 perluts
		perlvmesa perlvms perlvos perlwin32/;

	# Pragmas
	push @index, qw/attributes attrs autouse base bigint bignum
		bigrat blib bytes charnames constant diagnostics
		encoding feature fields filetest if integer less lib
		locale mro open ops overload re sigtrap sort strict
		subs threads threads::shared utf8 vars vmsish
		warnings warnings::register/;

	# Utilities
	push @index, qw/perlutil a2p c2ph config_data corelist cpan cpanp
		cpan2dist dprofpp enc2xs find2perl h2ph h2xs instmodsh
		libnetcfg perlbug perlcc piconv prove psed podchecker
		perldoc perlivp pod2html pod2latex pod2man pod2text
		pod2usage podselect pstruct ptar ptardiff s2p shasum
		splain xsubpp perlthanks/;

	# Perl Special Variables (compiled these from perlvar)
	push @index,
		(
		'$ARG', '$_', '$a', '$b', '$1', '$2', '$3', '$4', '$5', '$6', '$7', '$8', '$9', '$MATCH',
		'$&',  '${^MATCH}',     '$PREMATCH',         '$`', '${^PREMATCH}',          '$POSTMATCH',
		'$\'', '${^POSTMATCH}', '$LAST_PAREN_MATCH', '$+', '$LAST_SUBMATCH_RESULT', '$^N',
		'@LAST_MATCH_END',         '@+',  '%+', '$INPUT_LINE_NUMBER', '$NR', '$.',
		'$INPUT_RECORD_SEPARATOR', '$RS', '$/', '$OUTPUT_AUTOFLUSH',  '$|',  '$OUTPUT_FIELD_SEPARATOR',
		'$OFS', '$,',                   '$OUTPUT_RECORD_SEPARATOR', '$ORS', '$\\',                 '$LIST_SEPARATOR',
		'$"',   '$SUBSCRIPT_SEPARATOR', '$SUBSEP',                  '$;',   '$FORMAT_PAGE_NUMBER', '$%',
		'$FORMAT_LINES_PER_PAGE', '$=', '$FORMAT_LINES_LEFT', '$-', '@LAST_MATCH_START', '@-',
		'%-', '$FORMAT_NAME',           '$~',           '$FORMAT_TOP_NAME', '$^',     '$FORMAT_LINE_BREAK_CHARACTERS',
		'$:', '$FORMAT_FORMFEED',       '$^L',          '$ACCUMULATOR',     '$^A',    '$CHILD_ERROR',
		'$?', '${^CHILD_ERROR_NATIVE}', '${^ENCODING}', '$OS_ERROR',        '$ERRNO', '$!',
		'%OS_ERROR', '%ERRNO',              '%!',         '$EXTENDED_OS_ERROR', '$^E',            '$EVAL_ERROR',
		'$@',        '$PROCESS_ID',         '$PID',       '$$',                 '$REAL_USER_ID',  '$UID',
		'$<',        '$EFFECTIVE_USER_ID',  '$EUID',      '$>',                 '$REAL_GROUP_ID', '$GID',
		'$(',        '$EFFECTIVE_GROUP_ID', '$EGID',      '$)',                 '$PROGRAM_NAME',  '$0',
		'$[',        '$]',                  '$COMPILING', '$^C',                '$DEBUGGING',     '$^D',
		'${^RE_DEBUG_FLAGS}', '${^RE_TRIE_MAXBUF}', '$SYSTEM_FD_MAX', '$^F',     '$^H', '%^H',
		'$INPLACE_EDIT',      '$^I',                '$^M',            '$OSNAME', '$^O', '${^OPEN}',
		'$PERLDB',   '$^P', '$LAST_REGEXP_CODE_RESULT', '$^R',         '$EXCEPTIONS_BEING_CAUGHT', '$^S',
		'$BASETIME', '$^T', '${^TAINT}',                '${^UNICODE}', '${^UTF8CACHE}',            '${^UTF8LOCALE}',
		'$PERL_VERSION',    '$^V',  '$WARNING', '$^W',   '${^WARNING_BITS}', '${^WIN32_SLOPPY_STAT}',
		'$EXECUTABLE_NAME', '$^X',  'ARGV',     '$ARGV', '@ARGV',            'ARGVOUT',
		'@F',               '@INC', '@ARG',     '@_',    '%INC',             '%ENV',
		'$ENV{expr}',       '%SIG', '$SIG{expr}'
		);

	# Add Perl functions (perlfunc)
	$Type{say}   = 1;
	$Type{state} = 1;
	$Type{break} = 1;
	push @index, keys %Type;

	# Add Installed modules
	push @index, $self->_find_installed_modules;

	# Add Perl Operators Reference
	$self->{perlopref} = $self->_parse_perlopref;
	push @index, keys %{ $self->{perlopref} };

	# Return a unique sorted index
	my %seen = ();
	my @unique_sorted_index = sort grep { !$seen{$_}++ } @index;
	$self->{help_list} = \@unique_sorted_index;

	# Store the cached help list for faster access
	$cached_help_list = $self->{help_list};
	$cached_perlopref = $self->{perlopref};
}

# Finds installed CPAN modules via @INC
# This solution resides at:
# http://stackoverflow.com/questions/115425/how-do-i-get-a-list-of-installed-cpan-modules
sub _find_installed_modules {
	my $self = shift;
	my %seen;
	require File::Find::Rule;
	for my $path (@INC) {
		for my $file ( File::Find::Rule->name('*.pm')->in($path) ) {
			my $module = substr( $file, length($path) + 1 );
			$module =~ s/.pm$//;
			$module =~ s{[\\/]}{::}g;
			$seen{$module}++;
		}
	}
	return keys %seen;
}

# Parses perlopref.pod (Perl Operator Reference)
# http://github.com/cowens/perlopref/tree/master
sub _parse_perlopref {
	my $self  = shift;
	my %index = ();

	# Open perlopref.pod for reading
	my $perlopref = File::Spec->join( Padre::Util::sharedir('doc'), 'perlopref', 'perlopref.pod' );
	if ( open my $fh, '<', $perlopref ) { ## no critic (RequireBriefOpen)
		                                  # Add PRECEDENCE to index
		until ( <$fh> =~ /=head1 PRECEDENCE/ ) { }

		my $line;
		while ( $line = <$fh> ) {
			last if ( $line =~ /=head1 OPERATORS/ );
			$index{PRECEDENCE} .= $line;
		}

		# Add OPERATORS to index
		my $op;
		while ( $line = <$fh> ) {
			if ( $line =~ /=head2\s+(.+)$/ ) {
				$op = $1;
				$index{$op} = $line;
			} elsif ($op) {
				$index{$op} .= $line;
			}
		}

		# and we're done
		close $fh;
	} else {
		TRACE("Cannot open perlopref.pod\n") if DEBUG;
	}

	return \%index;
}

# Renders the help topic content into XHTML
sub help_render {
	my $self  = shift;
	my $topic = shift;

	if ( $self->{perlopref}->{$topic} ) {

		# Yes, it is a Perl 5 Operator
		require Padre::Pod2HTML;
		return (
			Padre::Pod2HTML->pod2html( $self->{perlopref}->{$topic} ),
			$topic,
		);
	}

	# Detect perlvar, perlfunc or simply nothing
	my $html     = undef;
	my $hints    = {};
	my $location = undef;
	if ( $topic =~ /^(\$|\@|\%|ARGV$|ARGVOUT$)/ ) {

		# it is definitely a Perl Special Variable
		$hints->{perlvar} = 1;
	} elsif ( $Type{$topic} ) {

		# it is Perl function, handle q/.../, m//, y///, tr///
		$hints->{perlfunc} = 1;
		$topic =~ s/\/.*?\/$//;
	} else {

		# Append the module's release date to the topic
		require Module::CoreList;
		my $first_release_by_date = Module::CoreList->first_release_by_date($topic);
		my $since_version =
			$first_release_by_date ? sprintf( Wx::gettext('(Since Perl v%s)'), $first_release_by_date ) : '';
		my $deprecated =
			( Module::CoreList->can('is_deprecated') && Module::CoreList::is_deprecated($topic) )
			? Wx::gettext('- DEPRECATED!')
			: '';
		$location = sprintf( '%s %s %s', $topic, $since_version, $deprecated );
	}

	# Determine if the padre locale and/or the
	#  system language is NOT english
	if ( Padre::Locale::iso639() !~ /^en/i ) {
		$hints->{lang} = Padre::Locale::iso639();
	}

	# Render using perldoc pseudo code package
	require Padre::DocBrowser::POD;
	my $pod      = Padre::DocBrowser::POD->new;
	my $doc      = $pod->resolve( $topic, $hints );
	my $pod_html = $pod->render($doc);
	if ($pod_html) {
		$html = $pod_html->body;

		# This is needed to make perlfunc and perlvar perldoc
		# output a bit more consistent
		$html =~ s/<dt>/<dt><b><font size="+2">/g;
		$html =~ s/<\/dt>/<\/b><\/font><\/dt>/g;
	}

	return ( $html, $location || $topic );
}

# Returns the help topic list
sub help_list {
	$_[0]->{help_list};
}

1;

__END__

=pod

=head1 NAME

Padre::Document::Perl::Help - Perl 5 Help Provider

=head1 DESCRIPTION

Perl 5 Help index is built here and rendered.

=head1 AUTHOR

Ahmad M. Zawawi C<ahmad.zawawi@gmail.com>

=cut

# Copyright 2008-2010 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
