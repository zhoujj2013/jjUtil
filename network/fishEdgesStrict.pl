#!/usr/bin/perl -w

use strict;
use FindBin qw($Bin $Script);

&usage if @ARGV<4;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        Fish edges by gene list. Both source and target must appear in gene list.
        Author: zhoujj2013\@gmail.com
        Usage: $0 genelist_f edgelist_f genelist_col edgelist_col prefix
        perl $0 genelist_f edgelist_f 1 2,3 both test

USAGE
print "$usage";
exit(1);
};

my ($genelist_f, $edgelist_f, $genelist_col, $edgelist_col) = @ARGV;

my @edgelist_col = split /,/,$edgelist_col;

#$genelist_col = $genelist_col-1;
#$edgelist_col[0] = $edgelist_col[0]-1;
#$edgelist_col[1] = $edgelist_col[1]-1;

my %gene;
open IN,"$genelist_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	$gene{$t[$genelist_col-1]} = 1;
}
close IN;

open IN,"$edgelist_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	if(exists $gene{$t[$edgelist_col[0]-1]} && exists $gene{$t[$edgelist_col[1]-1]}){
		print join "\t",@t;
		print "\n";
	}
}
close IN;
