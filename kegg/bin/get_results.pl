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

        Get kegg information from KEGG database.
        Author: zhoujj2013\@gmail.com 1/23/2017
        Usage: $0 spe[mmu, hsa]

USAGE
print "$usage";
exit(1);
};

my $kegg_info_f = shift;

my %gene2kegg;

open IN,"$kegg_info_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $kegg_id = $t[0];
	my $kegg_desc = $t[1];
	open IN2,"kegg2gene.$kegg_id.tmp" || die $!;
	my $l = <IN2>;
	chomp($l);
	close IN2;
	my @lc = split /\t/,$l;
	shift @lc;
	my @genes = @lc;
	unshift @lc,$kegg_desc;
	unshift @lc,$kegg_id;
	print join "\t",@lc;
	print "\n";
	foreach my $g(@genes){
		$gene2kegg{$g}{$kegg_id} = 1;
	}
}
close IN;

foreach my $geneid (keys %gene2kegg){
	my @kegg_lst;
	foreach my $k (keys %{$gene2kegg{$geneid}}){
		push @kegg_lst,$k;
	}
	print STDERR "$geneid\t";
	print STDERR join "\t",@kegg_lst;
	print STDERR "\n";
}

