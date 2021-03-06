#!/usr/bin/env perl
use strict;
use warnings;

use Cwd qw{ cwd };
use File::Spec::Functions qw{ catfile catdir };
use File::Find::Rule;
use File::Basename qw{ basename };
use File::Temp qw{ tempdir };
use Data::Dumper qw{ Dumper };
use Env qw{ LANG };
use Getopt::Long qw{ GetOptions };
use List::MoreUtils qw{ uniq };

#use Locale::PO;

# TODO: on the HTML show percentages instead of errors (or have both reports).
# maybe show some progress bar

my %reports;

my $text;
my $html;
my $dir;
my $project_dir;
my $details;
my $all;
my $trunk;
GetOptions(
	'text'      => \$text,
	'html'      => \$html,
	'dir=s'     => \$dir,
	'project=s' => \$project_dir,
	'details'   => \$details,
	'all'       => \$all,
	'trunk=s'   => \$trunk,
) or usage();
usage() if not $text and not $html;

$LANG = 'C';

my $tempdir = tempdir( CLEANUP => 1 );
my $cwd     = cwd;
my $errors  = '';

usage("--all and --project are mutually exclusive")
	if $all and $project_dir;
if ( not $all and not $project_dir ) {
	$project_dir = $cwd;
}


if ($project_dir) {
	$reports{ basename $project_dir} = collect_report($project_dir);
} elsif ($all) {
	$trunk ||= $cwd;
	foreach my $project_dir ( "$trunk/Padre", glob("$trunk/Padre-Plugin-*") ) {

		#print "P: $project_dir\n";
		$reports{ basename $project_dir} = collect_report($project_dir);
	}
}

my $text_report_file = catfile( $cwd, 'po_report.txt' );

if ($text) {
	save_text_report($text_report_file);
}
if ($html) {
	usage('--dir was missing') if not $dir;
	usage("--dir $dir does not exist") if not -d $dir;

	save_html_report($dir);
}
exit 0;



sub collect_report {
	my ($project_dir) = @_;

	my %data;
	my $plugin_name = basename $project_dir;
	$plugin_name =~ s/-/__/g;

	my $share = catdir( $project_dir, 'share' );
	if ( not -e $share ) {
		($share) = File::Find::Rule->directory()->name('share')->in( catdir( $project_dir, 'lib' ) );
	}
	if ( not $share or not -e $share ) {
		if ( $project_dir =~ m/Padre-Plugin-(.*)$/ ) {
			my $plugin_name = $1;
			_warn("Plugin '$plugin_name' is not internationalized.\n");
		} else {
			_warn("Could not find a 'share' directory in '$project_dir'");
		}
		return;
	}

	my $localedir = catdir( $share, 'locale' );

	if ( not -d $localedir ) {
		if ( $project_dir =~ m/Padre-Plugin-(.*)$/ ) {
			my $plugin_name = $1;
			_warn("Plugin '$plugin_name' is not internationalized.\n");
		} else {
			_warn("Can't find locale directory '$localedir'.\n");
		}
		return;
	}


	my @po_files = glob catfile( $localedir, '*.po');
	my $pot_file = catfile( $localedir, 'messages.pot' );
	if ( open my $fh, '<', $pot_file ) {
		while ( my $line = <$fh> ) {
			if ( $line =~ /^msgid/ ) {
				$data{total}++;
			}
		}
	}

	foreach my $po_file ( sort @po_files ) {

		#print "$po_file\n";
		my $err = "$tempdir/err";
		system "msgcmp $po_file $pot_file 2> $err";
		my $language = substr( basename($po_file), 0, -3 );
		if ( $plugin_name ne 'Padre' ) {
			$language =~ s/^$plugin_name-//;
		}
		if ( open my $fh, '<', $err ) {
			local $/ = undef;
			$data{$language}{details} = <$fh>;
			if ( $data{$language}{details} =~ /msgcmp: found (\d+) fatal errors?/ ) {
				$data{$language}{errors} = $1;
			} else {
				$data{$language}{errors} = 0;
			}
		} else {

			# TODO: report that could not open file
		}
	}
	return \%data;
}

sub save_html_report {
	my ($dir) = @_;
	my $html = <<'END_HEAD';
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html
     PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><head>
<title>Padre translation status report</title>
<style type="text/css">
body, th, tr {
    font: 13px Verdana,Arial,'Bitstream Vera Sans',Helvetica,sans-serif;
}
th {
    font-weight: bold;
    text-align: left;
}
th.lang {
    font-weight: normal;
    text-align: center;
}
.num, .num-red, .num-orange, .num-yellow, .num-green, .num-lgreen {
    text-align: right;
}
.red, .num-red {
    background-color: red;
}
.orange, .num-orange {
    background-color: orange;
}
.yellow, .num-yellow {
    background-color: yellow;
}
.green, .num-green {
    background-color: green;
}
.lgreen, .num-lgreen {
    background-color: lightgreen;
}
</style>
</head><body>
END_HEAD

	my $time = localtime();
	$html .= <<"END_HTML";
<h1>Padre translation status report</h1>
<p><a href="http://padre.perlide.org/translators.html">Get to know our translators on the Padre website.</a></p>
<p>If you want to help translating Padre, you can check out our
   <a href="http://padre.perlide.org/trac/wiki/TranslationIntro">wiki page on translations</a>.</p>
<p>The numbers showing the number of errors. An empty cell means that translation does not exist at all</p>
<p>Generated on: $time (it is generated using a cron-job)</p>

<table id="legend">
<caption>Legend</caption>
<tbody>
<tr><td class="red">more than 40% missing</td></tr>
<tr><td class="yellow">10%-40% missing</td></tr>
<tr><td class="green">less than 10% missing</td></tr>
<tr><td class="lgreen">perfect</td></tr>
</tbody>
</table>

<table border="1">
END_HTML

	#die Dumper $reports{"Padre-Plugin-SpellCheck"};

	my @languages = uniq sort grep { !/total/ } map { keys %{ $reports{$_} } } keys %reports;
	$html .= '<thead>';
	$html .= _header(@languages);
	$html .= '</thead><tbody>';

	my %totals;

	foreach my $project ( sort keys %reports ) {
		$html .= "<tr><th>$project</th><td class='num'>";
		my $total = $reports{$project}{total};
		$html .= defined $total ? $total : '&nbsp;';
		$total ||= 0;

		$html .= "</td>";
		if ( $reports{$project}{total} ) {
			$totals{total} += $reports{$project}{total};
		}
		foreach my $language (@languages) {
			if ( $reports{$project}{total} ) {
				if ( defined $reports{$project}{$language}{errors} ) {
					$html .= _td_open( $reports{$project}{$language}{errors}, $total );
					$html .= $reports{$project}{$language}{errors};
					$totals{$language} += $reports{$project}{$language}{errors};
				} else {

					#$html .= '<td class=red>-';
					$html .= "<td class='num-red'>$reports{$project}{total}";
					$totals{$language} += $reports{$project}{total};
				}
			} else {
				$html .= '<td>&nbsp;';
			}
			$html .= '</td>';
		}
		$html .= "</tr>\n";
	}
	$html .= "<tr><td>TOTAL</td><td>$totals{total}</td>";
	foreach my $language (@languages) {
		$html .= _td_open( $totals{$language}, $totals{total} );
		$html .= $totals{$language};
		$html .= "</td>";
	}
	$html .= "</tr>";

	$html .= _header(@languages);

	$html .= "</tbody></table>\n";

	$html .= "<h2>Padre GUI level of completeness</h2>\n";
	$html .= "<table>";
	foreach my $language (@languages) {
		my $p = 100 - int( 100 * $totals{$language} / $totals{total} );
		$html .= "<tr><th>$language</th><td><img src='../img/$p.png' alt='$p %'/></td><td class='num'>$p %</td></tr>\n";
	}
	$html .= "</table>";

	$html .= "<h2>Errors</h2>\n";
	if ($errors) {
		$html .= "<pre>\n$errors\n</pre>\n";
	} else {
		$html .= "<p>No errors were reported</p>\n";
	}




	$html .= "</body></html>";
	open my $fh, '>:utf8', "$dir/index.html" or die;
	print $fh $html;
}

sub _header {
	return "<tr><td></td><th>Total</th>" . ( join "", map {"<th class='lang'>$_</th>"} @_ ) . "</tr>\n";
}

sub _td_open {
	my ( $errors, $total ) = @_;
	if ( $errors > $total * 0.40 ) {
		return q(<td class="num-red">);

		#	} elsif ( $errors > $total * 0.20 ) {
		#		return q(<td class=orange>);
	} elsif ( $errors > $total * 0.10 ) {
		return q(<td class="num-yellow">);
	} elsif ( $errors > 0 ) {
		return q(<td class="num-green">);
	} else {
		return q(<td class="num-lgreen">);
	}
}

sub save_text_report {
	my ($text_report_file) = @_;
	open my $fh, '>', $text_report_file or die;

	print $fh "Generated by $0 on " . localtime() . "\n\n";


	foreach my $project ( sort keys %reports ) {
		print $fh "--------------------\n";
		print $fh "Project $project\n\n";
		print $fh generate_text_report( $reports{$project} );
	}
	print "file $text_report_file generated.\n";
}

sub generate_text_report {
	my ($data) = @_;

	my $report .= "Language  Errors\n";
	foreach my $language ( sort keys %$data ) {
		next if $language eq 'total';
		$report .= sprintf( "%-10s %s\n", $language, $data->{$language}{errors} );
	}

	if ($details) {
		foreach my $language ( sort keys %$data ) {
			next if $language eq 'total';
			$report .= "\n------------------\n";
			$report .= "Language: $language \n\n";
			if ( $data->{$language}{errors} ) {
				$report .= "Fatal errors: $data->{$language}{errors}\n\n";
			}
			$report .= $data->{$language}{details};
		}

	}
	return $report;
}

sub _warn {
	my $w = shift;
	$errors .= $w;
	warn($w);
}




sub usage {
	my $msg = shift;
	print "$msg\n\n" if defined $msg;
	print <<"END_USAGE";
Usage: $0
        --text            generate text report
        --html            generate html report

        --details         provides details (in text report only)
        --dir DIR         where to save the html report

        --project PATH    path to the project directory (e.g. ~/padre/Padre-Plugin-Vi)
        --all             all the projects
        --trunk  PATH     to root of all the projects


        --all and --project are mutually exclusive
        At least one of --html and --text need to be given

END_USAGE

	exit 1;
}

