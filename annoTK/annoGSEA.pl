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

        This script was designed to perform GSEA for a gene rank.
	(clusterProfiler etc.)
        Author: zhoujj2013\@gmail.com 
        Usage: $0 xxx.vs.xxx.FC prefix

USAGE
print "$usage";
exit(1);
};

my $fc_f = shift;
#my $fc_f = shift;
my $prefix = shift;

print STDERR "# Running GSEA annotation by clusterProfiler.\n";
`Rscript $Bin/run_MSigDb_gsea.r $fc_f $prefix`;


# for gene enrichment analysis
my %degs_id;
open IN,"$prefix.all.sym2entrezid.lst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	$degs_id{$t[2]} = $t[1];
}
close IN;

open OUT,">","$prefix.MSigDb.anno" || die $!;
open IN,"$prefix.h.gsea.result.raw.txt" || die $!;
my $header_h = <IN>;
print OUT "DbType\t";
print OUT $header_h;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $entrezid = $t[-1];
	my @entrezid = split /\//,$entrezid;
	my @symbol;
	foreach my $id (@entrezid){
		push @symbol,$degs_id{$id};
	}
	my $symbol_string = join ",",@symbol;
	$t[-1] = $symbol_string;
	shift @t;
	unshift @t,"Hallmark";
	print OUT join "\t",@t;
	print OUT "\n";
}
close IN;

open IN,"$prefix.c1.gsea.result.raw.txt" || die $!;
my $header_c1 = <IN>;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $entrezid = $t[-1];
	my @entrezid = split /\//,$entrezid;
	my @symbol;
	foreach my $id (@entrezid){
		push @symbol,$degs_id{$id};
	}
	my $symbol_string = join ",",@symbol;
	$t[-1] = $symbol_string;
	#my $kegg_id = shift @t;
	shift @t;
	unshift @t,"ChrPos";
	#unshift @t,$kegg_id;
	print OUT join "\t",@t;
	print OUT "\n";
}
close IN;

open IN,"$prefix.c2.gsea.result.raw.txt" || die $!;
my $header_c2 = <IN>;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $entrezid = $t[-1];
	my @entrezid = split /\//,$entrezid;
	my @symbol;
	foreach my $id (@entrezid){
		push @symbol,$degs_id{$id};
	}
	my $symbol_string = join ",",@symbol;
	$t[-1] = $symbol_string;
	#my $kegg_id = shift @t;
	shift @t;
	unshift @t,"C2";
	#unshift @t,$kegg_id;
	print OUT join "\t",@t;
	print OUT "\n";
}
close IN;


open IN,"$prefix.c3.gsea.result.raw.txt" || die $!;
my $header_c3 = <IN>;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $entrezid = $t[-1];
	my @entrezid = split /\//,$entrezid;
	my @symbol;
	foreach my $id (@entrezid){
		push @symbol,$degs_id{$id};
	}
	my $symbol_string = join ",",@symbol;
	$t[-1] = $symbol_string;
	#my $kegg_id = shift @t;
	shift @t;
	unshift @t,"motif";
	#unshift @t,$kegg_id;
	print OUT join "\t",@t;
	print OUT "\n";
}
close IN;

open IN,"$prefix.c4.gsea.result.raw.txt" || die $!;
my $header_c4 = <IN>;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $entrezid = $t[-1];
	my @entrezid = split /\//,$entrezid;
	my @symbol;
	foreach my $id (@entrezid){
		push @symbol,$degs_id{$id};
	}
	my $symbol_string = join ",",@symbol;
	$t[-1] = $symbol_string;
	#my $kegg_id = shift @t;
	shift @t;
	unshift @t,"computational";
	#unshift @t,$kegg_id;
	print OUT join "\t",@t;
	print OUT "\n";
}
close IN;

open IN,"$prefix.c5.gsea.result.raw.txt" || die $!;
my $header_c5 = <IN>;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $entrezid = $t[-1];
	my @entrezid = split /\//,$entrezid;
	my @symbol;
	foreach my $id (@entrezid){
		push @symbol,$degs_id{$id};
	}
	my $symbol_string = join ",",@symbol;
	$t[-1] = $symbol_string;
	#my $kegg_id = shift @t;
	shift @t;
	unshift @t,"GO";
	#unshift @t,$kegg_id;
	print OUT join "\t",@t;
	print OUT "\n";
}
close IN;

open IN,"$prefix.c6.gsea.result.raw.txt" || die $!;
my $header_c6 = <IN>;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $entrezid = $t[-1];
	my @entrezid = split /\//,$entrezid;
	my @symbol;
	foreach my $id (@entrezid){
		push @symbol,$degs_id{$id};
	}
	my $symbol_string = join ",",@symbol;
	$t[-1] = $symbol_string;
	shift @t;
	#my $kegg_id = shift @t;
	unshift @t,"oncogenes";
	#unshift @t,$kegg_id;
	print OUT join "\t",@t;
	print OUT "\n";
}
close IN;

open IN,"$prefix.c7.gsea.result.raw.txt" || die $!;
my $header_c7 = <IN>;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $entrezid = $t[-1];
	my @entrezid = split /\//,$entrezid;
	my @symbol;
	foreach my $id (@entrezid){
		push @symbol,$degs_id{$id};
	}
	my $symbol_string = join ",",@symbol;
	$t[-1] = $symbol_string;
	#my $kegg_id = shift @t;
	shift @t;
	unshift @t,"immunologic";
	#unshift @t,$kegg_id;
	print OUT join "\t",@t;
	print OUT "\n";
}
close IN;
close OUT;

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

