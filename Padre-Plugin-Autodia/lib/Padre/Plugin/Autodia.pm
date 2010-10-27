package Padre::Plugin::Autodia;

# ABSTRACT Autodia UML creator plugin for Padre

use strict;
use warnings;

=head1 DESCRIPTION

Padre plugin to integrate Autodia.

Provides an Autodia menu under 'plugins' with options to create UML diagrams for the current or selected files.

=cut

use base 'Padre::Plugin';

use Cwd;
use Autodia;

use Padre::Wx         ();
use Padre::Wx::Dialog ();
use Padre::Util       ();
use Padre::Current    ();

my $language_handlers = Autodia->getHandlers();

=head1 METHODS

=head2 plugin_name

=cut

sub plugin_name {
	Wx::gettext('Autodia UML Support');
}

=head2 padre_interfaces

Declare the Padre interfaces this plugin uses

=cut

sub padre_interfaces {
	'Padre::Plugin' => '0.47',
}

=head2 menu_plugins_simple

The command structure to show in the Plugins menu

=cut

sub menu_plugins_simple {
	my $self = shift;
	return $self->plugin_name => [
		Wx::gettext('About') => sub { $self->show_about },
		Wx::gettext('UML')   => [
			Wx::gettext('Class Diagram (This File)') => sub { $self->draw_this_file },
			Wx::gettext('Class Diagram')             => sub { $self->draw_all_files },
		],
	];
}

=head2 show_about

show 'about' dialog

=cut

sub show_about {
	my ($main) = @_;

	my $about = Wx::AboutDialogInfo->new;
	$about->SetName("Padre::Plugin::Autodia");
	$about->SetDescription( "Integrating automated documentation into Padre IDE" );
	$about->SetVersion($Padre::Plugin::Autodia::VERSION);
	$about->SetCopyright( Wx::gettext("Copyright 2010 Aaron Trevena") );

	# Only Unix/GTK native about box supports websites
	if ( Padre::Util::WXGTK() ) {
		$about->SetWebSite("http://padre.perlide.org/");
	}

	$about->AddDeveloper("Aaron Trevena : teejay at cpan dot org");

	Wx::AboutBox($about);
	return;
}

=head2 draw_this_file

parse and diagram this file, displaying the UML Chart in a new window

=cut

sub draw_this_file {
	my $self = shift;

	my $document = $self->current->document;
	warn "document : $document\n";

	my $filename = $document->filename || $document->tempfile;
	warn "filename : $filename\n";

	my $outfile = "${filename}.draw_this_file.jpg";

	( my $language = lc( $document->get_mimetype ) ) =~ s|application/[x\-]*||;
	warn "language : $language, mimetype : ", $document->get_mimetype, "\n";

	my $autodia_handler =
		$self->_get_handler( { filenames => [$filename], outfile => $outfile, graphviz => 1, language => $language } );

	my $processed_files = $autodia_handler->process();
	warn "processed $processed_files files\n";

	$autodia_handler->output();

	Padre::Wx::launch_browser("file://$outfile");

	return;
}

=head2 draw_all_files

parse and diagram selected files from dialog, displaying the UML Chart in a new window

=cut

# http://docs.wxwidgets.org/stable/wx_wxfiledialog.html
my $orig_wildcards = join(
	'|',
	Wx::gettext("JavaScript Files"),
	"*.js;*.JS",
	Wx::gettext("Perl Files"),
	"*.pm;*.PM;*.pl;*.PL",
	Wx::gettext("PHP Files"),
	"*.php;*.php5;*.PHP",
	Wx::gettext("Python Files"),
	"*.py;*.PY",
	Wx::gettext("Ruby Files"),
	"*.rb;*.RB",
	Wx::gettext("SQL Files"),
	"*.slq;*.SQL",
	Wx::gettext("Text Files"),
	"*.txt;*.TXT;*.yml;*.conf;*.ini;*.INI",
	Wx::gettext("Web Files"),
	"*.html;*.HTML;*.htm;*.HTM;*.css;*.CSS",
);

# get language and wildcard
my $languages = {
	Javascript => [qw/.js .JS/],
	Perl       => [qw/.pm .PM .pl .PL .t/],
	PHP        => [qw/.php .php3 .php4 .php5 .PHP/],
};

my $wildcards =
	join( '|',
	map { sprintf(Wx::gettext("%s Files"), $_) => join( ';', map ( "*$_", @{ $languages->{$_} } ) ) } sort keys %$languages );

$wildcards .= (Padre::Constant::WIN32) ? Wx::gettext("All Files") . "|*.*|" : Wx::gettext("All Files") . "|*|";


sub draw_all_files {
	my $self = shift;

	my $directory = Cwd::getcwd();

	# show dialog, get files
	my $dialog = Wx::FileDialog->new(
		Padre->ide->wx->main, Wx::gettext("Open File"),
		$directory, "", $wildcards, Wx::wxFD_MULTIPLE,
	);
	if ( $dialog->ShowModal == Wx::wxID_CANCEL ) {
		return;
	}

	$directory = $dialog->GetDirectory;
	my @filenames = map {"$directory/$_"} $dialog->GetFilenames;


	# get language for first file
	my $language = 'perl';
	foreach my $this_language ( keys %$languages ) {
		if ( grep { $filenames[0] =~ m/$_$/ } @{ $languages->{$this_language} } ) {
			$language = lc($this_language);
			last;
		}
	}

	# run autodia on files
	my $outfile = Cwd::getcwd() . "/padre.draw_these_files.jpg";
	my $autodia_handler =
		$self->_get_handler( { filenames => \@filenames, outfile => $outfile, graphviz => 1, language => $language } );
	my $processed_files = $autodia_handler->process();
	warn "processed $processed_files files\n";
	$autodia_handler->output();

	# display generated output in browser
	Padre::Wx::launch_browser("file://$outfile");

	return;
}

sub _get_handler {
	my $self = shift;
	my $args = shift;

	my $config = {
		language => $args->{language}, graphviz => $args->{graphviz} || 0,
		use_stdout => 0, filenames => $args->{filenames}
	};
	$config->{templatefile} = $args->{template} || undef;
	$config->{outputfile}   = $args->{outfile}  || "autodia-plugin.out";

	my $handler_module = $language_handlers->{ lc( $args->{language} ) };
	eval "require $handler_module" or die "can't run '$handler_module' : $@\n";
	my $handler = "$handler_module"->new($config);

	return $handler;
}

=head1 SEE ALSO

L<Autodia>, L<Padre>

=head1 CREDITS

Development sponsered by Connected-uk

=cut

1;
