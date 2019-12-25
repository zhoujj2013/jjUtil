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

        This script was designed to perform enrichment analysis for a gene list.
	(clusterProfiler etc.)
        Author: zhoujj2013\@gmail.com 
        Usage: $0 xxx.vs.xxx.down prefix

USAGE
print "$usage";
exit(1);
};

my $deg_f = shift;
#my $fc_f = shift;
my $prefix = shift;

print STDERR "# Running go and kegg annotation by clusterProfiler.\n";
`Rscript $Bin/run_go_kegg.r $deg_f $prefix`;


# for gene enrichment analysis
my %degs_id;
open IN,"$prefix.degs.sym2entrezid.lst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	$degs_id{$t[1]} = $t[0];
}
close IN;

open OUT,">","$prefix.go.kegg.anno" || die $!;
print OUT "DbType\tTermId\tDescription\tGeneRatio\tBgRatio\tpvalue\tp.adjust\tqvalue\tgeneID\tCount\n";
open IN,"$prefix.go.enrichment.result.raw.txt" || die $!;
my $header_go = <IN>;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $entrezid = $t[-2];
	my @entrezid = split /\//,$entrezid;
	my @symbol;
	foreach my $id (@entrezid){
		push @symbol,$degs_id{$id};
	}
	my $symbol_string = join ",",@symbol;
	$t[-2] = $symbol_string;
	shift @t;
	print OUT join "\t",@t;
	print OUT "\n";
}
close IN;

open IN,"$prefix.kegg.enrichment.result.raw.txt" || die $!;
my $header_kegg = <IN>;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $entrezid = $t[-2];
	my @entrezid = split /\//,$entrezid;
	my @symbol;
	foreach my $id (@entrezid){
		push @symbol,$degs_id{$id};
	}
	my $symbol_string = join ",",@symbol;
	$t[-2] = $symbol_string;
	my $kegg_id = shift @t;
	unshift @t,"KEGG";
	#unshift @t,$kegg_id;
	print OUT join "\t",@t;
	print OUT "\n";
}
close IN;

print STDERR "# Done\n";


## for GSEA
#my %degs_id;
#open IN,"$prefix.degs.sym2entrezid.lst" || die $!;
#while(<IN>){
#	chomp;
#	my @t = split /\t/;
#	$degs_id{$t[1]} = $t[0];
#}
#close IN;

