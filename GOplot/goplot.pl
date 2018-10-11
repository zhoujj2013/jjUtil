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

        Use GOplot to illustrat GO enrichment analysis result.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 config.cfg

USAGE
print "$usage";
exit(1);
};

my $david_table=shift;
my $genelst = shift;
my $cutoff = shift;

open OUT,">","goplot.david.result.tab" || die $!;
open IN,"$david_table" || die $!;
<IN>;
print OUT "Category\tID\tTerm\tGenes\tadj_pval\n";
while(<IN>){
	chomp;
	my @t = split /\t/;
	if($t[0] eq "GOTERM_BP_FAT"){
		$t[0] = "BP";
	}elsif($t[0] eq "GOTERM_CC_FAT"){
		$t[0] = "CC";
	}elsif($t[0] eq "GOTERM_MF_FAT"){
		$t[0] = "MF";
	}else{
		next;
	}
	if($t[9] > $cutoff){
		next;
	}
	my @tt = split /~/,$t[11];
	my $ID = $tt[0];
	my $Term = $tt[1];
	print OUT "$t[0]\t$ID\t$Term\t$t[12]\t$t[9]\n";
	# Category        Count   %       Pvalue  List Total      Pop Hits        Pop Total       Fold Enrichment Bonferroni      Benjamini       FDR     Term    Genes
}
close IN;
close OUT;

open OUT,">","goplot.gene.lst" || die $!;
open IN,"$genelst" || die $!;
print OUT "ID\tlogFC\tAveExpr\tt\tP.Value\tadj.P.Val\tB\n";
while(<IN>){
	chomp;
	my @t = split /\t/;
	print OUT "$t[0]\t$t[1]\t0\t0\t0\t0\t0\n";
}
close IN;
close OUT;


`Rscript $Bin/goplot.r`;

