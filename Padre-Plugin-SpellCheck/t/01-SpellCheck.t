use Test::More tests => 18;

use_ok( 'Padre',                 '0.94' );
use_ok( 'Padre::Plugin',         '0.94' );
use_ok( 'Padre::Unload',         '0.94' );
use_ok( 'Padre::Locale',         '0.94' );
use_ok( 'Padre::Logger',         '0.94' );
use_ok( 'Padre::Wx',             '0.94' );
use_ok( 'Padre::Wx::Role::Main', '0.94' );


######
# let's check our subs/methods.
######

my @subs = qw( clean_dialog config padre_interfaces plugin_name menu_plugins
	plugin_disable plugin_enable plugin_preferences set_config spell_check );

use_ok( 'Padre::Plugin::SpellCheck', @subs );

foreach my $subs (@subs) {
	can_ok( 'Padre::Plugin::SpellCheck', $subs );
}


######
# let's check our lib's are here.
######
# my $test_object;
# SKIP: {
	# skip 'due to back call', 1 if 1;
	# require Padre::Plugin::SpellCheck::Preferences;
	# $test_object = new_ok('Padre::Plugin::SpellCheck::Preferences');
# }
# require Padre::Plugin::SpellCheck::FBP::Preferences;
# $test_object = new_ok('Padre::Plugin::SpellCheck::FBP::Preferences');

# require Padre::Plugin::SpellCheck::Engine;
# $test_object = new_ok('Padre::Plugin::SpellCheck::Engine');
# SKIP: {
	# skip 'due to missing prameter', 2 if 1;
	# require Padre::Plugin::SpellCheck::Dialog;
	# $test_object = new_ok('Padre::Plugin::SpellCheck::Checker');

	# require Padre::Plugin::SpellCheck::FBP::Dialog;
	# $test_object = new_ok('Padre::Plugin::SpellCheck::FBP::Checker');
# }

done_testing();

1;

__END__