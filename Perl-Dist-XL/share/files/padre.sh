#!/bin/sh
#echo $HOME
#echo `dirname $0`

path_to_perl=`perl -MCwd -MFile::Basename -e 'print dirname(dirname(Cwd::abs_path(shift)))' $0`
#echo $path_to_perl
#echo `dirname $path_to_sh`

export PERL5LIB=
export LD_LIBRARY_PATH=$path_to_perl/lib/site_perl/5.10.1/i686-linux-thread-multi/Alien/wxWidgets/gtk_2_8_10_uni/lib/:$LD_LIBRARY_PATH

$path_to_perl/bin/perl $path_to_perl/bin/padre $@
