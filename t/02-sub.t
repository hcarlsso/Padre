use strict;
use warnings;

use t::lib::Debugger;

my $pid = start_script('t/eg/02-sub.pl');

require Test::More;
import Test::More;

plan(tests => 11);

my $debugger = start_debugger();

{
    my $out = $debugger->get;
 
# Loading DB routines from perl5db.pl version 1.28
# Editor support available.
# 
# Enter h or `h h' for help, or `man perldebug' for more help.
# 
# main::(t/eg/01-add.pl:4):	$| = 1;
#   DB<1> 

    like($out, qr/Loading DB routines from perl5db.pl version/, 'loading line');
    like($out, qr{main::\(t/eg/02-sub.pl:4\):\s*\$\| = 1;}, 'line 4'); # TODO why does
}

{
    my @out = $debugger->step_in;
    is_deeply(\@out, ['main::', 't/eg/02-sub.pl', 6, 'my $x = 1;', 1], 'line 6');
}
{
    my @out = $debugger->step_in;
    is_deeply(\@out, ['main::', 't/eg/02-sub.pl', 7, 'my $y = 2;', 1], 'line 7');
}

{
    my @out = $debugger->step_in;
    is_deeply(\@out, ['main::', 't/eg/02-sub.pl', 8, 'my $q = f($x, $y);', 1], 'line 8');
}

{
    my @out = $debugger->step_in;
    is_deeply(\@out, ['main::f', 't/eg/02-sub.pl', 13, '   my ($q, $w) = @_;', 1], 'line 13');
}

{
    my @out = $debugger->step_in;
    is_deeply(\@out, ['main::f', 't/eg/02-sub.pl', 14, '   my $multi = $q * $w;', 1], 'line 14');
}

{
    my @out = $debugger->step_in;
    is_deeply(\@out, ['main::f', 't/eg/02-sub.pl', 15, '   my $add   = $q + $w;', 1], 'line 15');
}

{
    my @out = $debugger->step_in;
    is_deeply(\@out, ['main::f', 't/eg/02-sub.pl', 16, '   return $multi;', 1], 'line 16');
}

{
    my @out = $debugger->step_in;
    is_deeply(\@out, ['main::', 't/eg/02-sub.pl', 9, 'my $z = $x + $y;', 1], 'line 9');
}

{
# Debugged program terminated.  Use q to quit or R to restart,
#   use o inhibit_exit to avoid stopping after program termination,
#   h q, h R or h o to get additional info.  
#   DB<1> 
    my $out = $debugger->step_in;
    like($out, qr/Debugged program terminated/);
}
