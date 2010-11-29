#!/usr/bin/perl

# Checks that errors and warnings emitted by the Perl syntax highlighting
# task have the correct line numbers.

use strict;
use warnings;
use Test::More;

BEGIN {
	unless ( $ENV{DISPLAY} or $^O eq 'MSWin32' ) {
		plan skip_all => 'Needs DISPLAY';
		exit 0;
	}
	plan( tests => 73 );
}

use t::lib::Padre;
use Storable                      ();
use File::HomeDir                 ();
use Padre::Document::Perl::Syntax ();


# This should only be used to skip dependencies on Padre classes
# while testing Padre::Document::Perl::Syntax
$ENV{PADRE_IS_TEST} = 1;



######################################################################
# Trivial Tests

# Check the null case
my $null = execute('');
isa_ok( $null, 'Padre::Task::Syntax' );
is_deeply( $null->{model}, [], 'Null syntax returns null model' );

# A simple, correct, one line script
my $hello = execute( <<'END_PERL' );
#!/usr/bin/perl

print "Hello World!\n";
END_PERL
is_deeply( $null->{model}, [], 'Trivial script returns null model' );

# A simple, correct, one line package
my $package = execute( <<'END_PERL' );
package Foo;
END_PERL
is_deeply( $null->{model}, [], 'Trivial module returns null model' );





######################################################################
# Trivially broken three line script

SCOPE: {
	my $script = execute( <<'END_PERL' );
#!/usr/bin/perl

print(
END_PERL
	is_model_ok(
		model     => $script->{model},
		line      => 3,
		message   => 'syntax error, at EOF',
		type      => 'F',
		test_name => 'Trivially broken three line script',
	);
}





######################################################################
# Trivially broken package statement, and variants

SKIP: {
	skip 'Perl 5.8.9- do not generate a syntax error', 4 if $] <= 5.008009;

	my $module = execute('package');
	is_model_ok(
		model     => $module->{model},
		line      => 1,
		message   => 'syntax error, at EOF',
		type      => 'F',
		test_name => 'Trivially broken package statement',
	);
}

SKIP: {
	skip 'Perl 5.8.9- do not generate a syntax error', 4 if $] <= 5.008009;

	my $module = execute("package;\n");
	is_model_ok(
		model     => $module->{model},
		line      => 1,
		message   => 'syntax error, near "package;"',
		type      => 'F',
		test_name => 'Trivially broken package statement',
	);
}





######################################################################
# Nth line error in package, and variants

SCOPE: {
	my $module = execute( <<'END_PERL' );
package Foo;

print(

END_PERL
	is_model_ok(
		model     => $module->{model},
		line      => 3,
		message   => 'syntax error, at EOF',
		type      => 'F',
		test_name => 'Error at the nth line of a module',
	);
}

# With explicit windows newlines
my $win32 = "package Foo;\cM\cJ\cM\cJprint(\cM\cJ\cM\cJ";
SCOPE: {
	my $module = execute($win32);
	is_model_ok(
		model     => $module->{model},
		line      => 3,
		message   => 'syntax error, at EOF',
		type      => 'F',
		test_name => 'Error at the nth line of a module',
	);
}

# UTF8 upgraded with windows newlines
SCOPE: {
	use utf8;
	utf8::upgrade($win32);
	my $module = execute($win32);
	is_model_ok(
		model     => $module->{model},
		line      => 3,
		message   => 'syntax error, at EOF',
		type      => 'F',
		test_name => 'Error at the nth line of a module',
	);
	no utf8;
}





######################################################################
# Support Functions

sub execute {

	# Create a Padre document for the code
	my $document = Padre::Document::Perl::Fake->new(
		text => $_[0],
	);
	isa_ok( $document, 'Padre::Document::Perl' );

	# Create the task
	my $task = Padre::Document::Perl::Syntax->new(
		document => $document,
	);
	isa_ok( $task, 'Padre::Document::Perl::Syntax' );
	ok( $task->prepare, '->prepare ok' );

	# Push through storable to emulate being sent to a worker thread
	$task = Storable::dclone($task);

	ok( $task->run, '->run ok' );

	# Clone again to emulate going back
	$task = Storable::dclone($task);

	ok( $task->finish, '->finish ok' );

	return $task;
}

sub is_model_ok {
	my %arg   = @_;
	my $model = $arg{model};

	is( $model->[0]->{message}, $arg{message}, "message match in '$arg{test_name}'" );
	is( scalar @$model,         1,             "model has only one message in '$arg{test_name}'" );
	is( $model->[0]->{line},    $arg{line},    "line match in '$arg{test_name}'" );
	is( $model->[0]->{type},    $arg{type},    "type match in '$arg{test_name}'" );
}

CLASS: {

	package Padre::Document::Perl::Fake;

	use strict;
	use base 'Padre::Document::Perl';

	sub new {
		my $class = shift;
		my $self = bless {@_}, $class;
		return $self;
	}

	sub text_get {
		$_[0]->{text};
	}

	sub project_dir {
		File::HomeDir->my_documents;
	}

	sub filename {
		return undef;
	}

	1;
}
