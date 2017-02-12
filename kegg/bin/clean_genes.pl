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

        Clean genes in KEGG or GO db base on a valiable gene list.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 gene.lst XX.gene2kegg XX.kegg2gene

USAGE
print "$usage";
exit(1);
};

my $gene_lst_f = shift;
my $gene2kegg_f = shift;
my $kegg2gene_f = shift;

my %gene;
open IN,"$gene_lst_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	$gene{$t[0]} = 1;
}
close IN;

open IN,"$kegg2gene_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $id = shift @t;
	my $desc = shift @t;
	my @arr;
	foreach my $g (@t){
		if(exists $gene{$g}){
			push @arr,$g;
		}
	}
	if(scalar(@arr) == 0){
		push @arr,"NA";
	}
	print STDERR "$id\t$desc\t";
	print STDERR join "\t",@arr;
	print STDERR "\n";
}
close IN;

open IN,"$gene2kegg_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $id = shift @t;
	if(exists $gene{$id}){	
		print "$id\t";
		print join "\t",@t;
		print "\n";
	}
}
close IN;

