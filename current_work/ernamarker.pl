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

        This script create makefile for eRNA marker analysis.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 config.cfg

USAGE
print "$usage";
exit(1);
};

my $conf=shift;
my %conf;
&load_conf($conf, \%conf);
my $all = "all: ";
my $mk = "";
my $out = abs_path($conf{out});
my $spe = $conf{spe};

# rose
mkdir "$out/01.rose" unless(-e "$out/01.rose");
$mk .= "01.rose.finished: $conf{H3K27ac} $conf{Input}\n";
$mk .= "\tcd $out/01.rose && sh $conf{ROSE}/run_rose.sh && cd - && touch 01.rose.finished\n";
$all .= "01.rose.finished ";

# eRNA assembly
mkdir "$out/02.eRNAassembly" unless(-e "$out/02.eRNAassembly");
$mk .= "02.eRNAassembly.finished: $conf{RNAseq}\n";
$mk .= "\tcd $out/02.eRNAassembly && $conf{cufflinks} && cd - && touch 02.eRNAassembly.finished\n";
$all .= "02.eRNAassembly.finished ";

# extract eRNA
mkdir "$out/03.eRNAextraction" unless(-e "$out/03.eRNAextraction");
$mk .= "03.eRNAextraction.finished: 02.eRNAassembly.finished\n";
$mk .= "\tcd $out/03.eRNAextraction && && cd - && touch 03.eRNAextraction.finished\n";
$all .= "03.eRNAextraction.finished ";

# evaluate eRNA coding potential
mkdir "$out/04.iseeRNA" unless(-e "04.iseeRNA");
$mk .= "04.iseeRNA.finished: 03.eRNAextraction.finished\n";
$mk .= "\tcd $out/04.iseeRNA && && cd - && touch 04.iseeRNA.finished\n";
$all .= "04.iseeRNA.finished ";

# eRNA quantification
mkdir "$out/05.eRNAquan" unless(-e "$out/05.eRNAquan");
$mk .= "05.eRNAquan.finished: 04.iseeRNA.finished\n";
$mk .= "\tcd $out/05.eRNAquan && && cd - && touch 05.eRNAquan.finished\n";
$all .= "05.eRNAquan.finished ";

# GROseq for eRNA activity quantification
if($conf{GROseq} ne "none"){
mkdir "$out/06.GroeRNAquan" unless(-e "$out/06.eRNAquan");
$mk .= "06.GroeRNAquan.finished: 05.eRNAquan.finished\n";
$mk .= "\tcd $out/06.GroeRNAquan && && cd - && touch 06.GroeRNAquan.finished\n";
$all .= "06.GroeRNAquan.finished ";
}

#### write you things ###
make_path abs_path($conf{OUTDIR});
open OUT, ">$out/makefile";
print OUT $all, "\n";
print OUT $mk, "\n";
close OUT;
$all = "all: ";
$mk = "";

#########################

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
