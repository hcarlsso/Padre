# Note: this file was auto-generated by Module::Build::Compat version 0.33
use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'         => 'Padre::Plugin::XML',
	'VERSION_FROM' => 'lib/Padre/Plugin/XML.pm',
	'PREREQ_PM'    => {
		'Padre'       => '0.65',
		'Test::More'  => 0,
		'XML::LibXML' => '1.67',
		'XML::Tidy'   => 0
	},
	'INSTALLDIRS' => 'site',
	'EXE_FILES'   => [],
	'PL_FILES'    => {}
);