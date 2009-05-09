#!/usr/bin/perl
use strict;
use warnings;

use Cwd                   qw{ cwd };
use File::Spec::Functions qw{ catfile catdir };
use File::Find::Rule;
use File::Basename        qw{ basename };
use File::Temp            qw{ tempdir };
use Env                   qw{ LANG };
use Getopt::Long          qw{ GetOptions };
#use Locale::PO;

my %data;


my $text;
my $html;
my $dir;
my $share;
my $details;
my $all;
GetOptions(
	'text'    => \$text, 
	'html'    => \$html, 
	'dir=s'   => \$dir, 
	'share=s' => \$share,
	'details' => \$details,
	'all'     => \$all,
	) or usage();
usage() if not $text and not $html;
usage("Invalid share directory '$share'") if $share and not -e $share;

$LANG = 'C';

my $tempdir = tempdir( CLEANUP => 1 );
my $cwd       = cwd;

if (not $share) {
	$share = catdir ( $cwd, 'share' );
	if (not -e $share) {
		($share) = File::Find::Rule->directory()->name('share')->in(catdir( $cwd, 'lib'));
	}
}
usage("Could not find a 'share' directory") if not $share or not -e $share;

my $localedir = catdir ( $share, 'locale' );

my $pot_file  = catfile( $localedir, 'messages.pot' );
my $text_report_file = catfile($cwd, 'po_report.txt');

usage("Can't find locale directory '$localedir'.\nPlease run this tool on the 'Padre' base directory")
	if not -d $localedir;
if ($text) {
	collect_report($localedir);
	save_text_report($text_report_file);
} elsif ($html) {
	usage("--dir was missing") if not $dir;
	usage("--dir $dir does not exist") if -d $dir;
}




sub collect_report {
	my ($localedir) = @_;

	my @po_files  = glob "$localedir/*.po";
	foreach my $po_file (sort @po_files) {
		#print "$po_file\n";
		my $err = "$tempdir/err";
		system "msgcmp $po_file $localedir/messages.pot 2> $err";
		my $language = basename($po_file);
		if (open my $fh, '<', $err) {
			local $/ = undef;
			$data{$language}{details} = <$fh>;
			if ($data{$language}{details} =~ /msgcmp: found (\d+) fatal errors?/) {
				$data{$language}{errors} = $1;
			} else {
				$data{$language}{errors} = 0;
			}
		} else {
			# TODO: report that could not open file
		}
	}
	return;
}


sub save_text_report {
	my ($text_report_file) = @_;
	open my $fh, '>', $text_report_file or die;
	
	my $header  = "Generated by $0 on " . localtime() . "\n\n";
	$header    .= "Language  Errors\n";
	foreach my $language (sort keys %data) {
		$header .= sprintf("%-10s %s\n", substr($language, 0, -3), $data{$language}{errors});
	}
	
	print {$fh} $header;
	if ($details) {
		my $report = '';
		foreach my $language (sort keys %data) {
			$report .= "\n------------------\n";
			$report .= $language . "\n\n";
			if ($data{$language}{errors}) {
				$report .= "Fatal errors: $data{$language}{errors}\n\n";
			}
			$report .= $data{$language}{details};
		}
		
		print {$fh} $report;
	}
	print "file 'po_report.txt' generated.\n";
}



sub usage {
	my $msg = shift;
	print "$msg\n\n" if defined $msg;
	print <<"END_USAGE";
Usage: $0
        --text 
        --html --dir DIR
	--share    path to the share directory (optional)
	--details
	--all    all the projects
END_USAGE

	exit 1;
}

