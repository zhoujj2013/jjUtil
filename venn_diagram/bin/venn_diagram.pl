#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use File::Path qw(make_path);
use Data::Dumper;
use Cwd qw(abs_path);

&usage if @ARGV<1;

sub usage {
        my $usage = << "USAGE";

        For venn diagram calculation.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 xxx.cfg

USAGE
print "$usage";
exit(1);
};

my $conf=shift;
my %conf;
&load_conf($conf, \%conf);

my $all='all: ';
my $mk;

$conf{A} = abs_path($conf{A});
$conf{B} = abs_path($conf{B});
$conf{C} = abs_path($conf{C});
$conf{D} = abs_path($conf{D}) if($conf{SET_NUM} > 3);
$conf{E} = abs_path($conf{E}) if($conf{SET_NUM} > 4);

print `wc -l $conf{A}`;
print `wc -l $conf{B}`;
print `wc -l $conf{C}`;
print `wc -l $conf{D}` if($conf{SET_NUM} > 3);
print `wc -l $conf{E}` if($conf{SET_NUM} > 4);

#### write you things ###
if($conf{SET_NUM} == 4){
	$mk .= "4set.finished : $conf{A} $conf{B} $conf{C} $conf{D}\n";
	$mk .= "\tperl $Bin/venn_diagram_table.pl $conf{A}  $conf{B} $conf{C} $conf{D} > 4set.stat && touch 4set.finished\n";
	$all .= "4set.finished ";
	$mk .= "4set.venn.stat.finished : 4set.finished\n";
	$mk .= "\tsh $Bin/stat.4set.sh ./4set.stat > 4set.venn.stat && touch 4set.venn.stat.finished\n";
	$all .= "4set.venn.stat.finished ";
}elsif($conf{SET_NUM} == 5){	
	$mk .= "5set.finished : $conf{A} $conf{B} $conf{C} $conf{D} $conf{E}\n";
	$mk .= "\tperl $Bin/venn_diagram_table.pl $conf{A}  $conf{B} $conf{C} $conf{D} $conf{E} > 5set.stat && touch 5set.finished\n";
	$all .= "5set.finished ";
	$mk .= "5set.venn.stat.finished : 5set.finished\n";
	$mk .= "\tsh $Bin/stat.5set.sh ./5set.stat > 5set.venn.stat && touch 5set.venn.stat.finished\n";
	$all .= "5set.venn.stat.finished ";
}elsif($conf{SET_NUM} == 3){	
	$mk .= "3set.finished : $conf{A} $conf{B} $conf{C}\n";
	$mk .= "\tperl $Bin/venn_diagram_table.pl $conf{A}  $conf{B} $conf{C} > 3set.stat && touch 3set.finished\n";
	$all .= "3set.finished ";
	$mk .= "3set.venn.stat.finished : 3set.finished\n";
	$mk .= "\tsh $Bin/stat.3set.sh ./3set.stat > 3set.venn.stat && touch 3set.venn.stat.finished\n";
	$all .= "3set.venn.stat.finished ";
}
#########################

make_path $conf{OUTDIR};
open OUT, ">$conf{OUTDIR}/makefile";
print OUT $all, "\n";
print OUT $mk, "\n";
close OUT;

sub load_conf
{
    my $conf_file=shift;
    my $conf_hash=shift; #hash ref
    open CONF, $conf_file || die "$!";
    while(<CONF>)
    {
        chomp;
        next unless $_ =~ /\S+/;
        next if $_ =~ /^#/;
        warn "$_\n";
        my @F = split"\t", $_;  #key->value
        $conf_hash->{$F[0]} = $F[1];
    }
    close CONF;
}
