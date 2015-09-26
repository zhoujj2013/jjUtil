#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;
use lib "/home/zhoujj/my_lib/pm";
use bioinfo;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        Design for tissue specific score calculation.
        Suitable for RPKM/FPKM and LOGx(RPKM/FPKM).
        Note: the most suitable scenario is one tissue, one sample.
		Reference: http://www.nature.com/nature/journal/v505/n7485/full/nature12943.html
                   Nature 505, 635-640 (30 January 2014) doi:10.1038/nature12943
                   Methods. 
        Author: zhoujj2013\@gmail.com
        Usage: $0 <expression table> <start colum> <logdata, y|n>

USAGE
print "$usage";
exit(1);
};

my $expr_f = shift;
my $col_s = shift;
my $blog = shift;

open IN,"$expr_f" || die $!;
while(<IN>){
	chomp;
	if(/^#/){
		print "$_\tspScore\n";
		next;
	}
	my @c = split /\t/;
	my @t = @c;
	my $max = 0;
	# make element > 0
	for(my $i = $col_s - 1; $i < scalar(@t); $i++){
		if($blog eq "n"){
			if($t[$i] < 0.01){
				$t[$i] = 0.01;
			}
		}
		$max = $t[$i] if($t[$i] > $max);
	}
	
	# calculation
	# from doi:10.1038/nature12943, method part
	#
	my $diff_sum = 0;
	my $sample_num = 0;
	for(my $i = $col_s - 1; $i < scalar(@t); $i++){
		#print "$t[$i]\t$max\n";
		$diff_sum = $diff_sum + (1 - ($t[$i]/$max));
		$sample_num++;
	}
	my $score = $diff_sum/($sample_num-1);
	push @c,$score;
	print join "\t",@c;
	print "\n";
}
close IN;
