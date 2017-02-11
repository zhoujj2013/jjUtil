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

        This script designed to get expression profile for a single gene.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 expr_f id_col start_col geneid > result

USAGE
print "$usage";
exit(1);
};

my $expr_f = shift;
my $id_col = shift;
my $start_col = shift;
my $geneid = shift;

open IN,"$expr_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	if($t[$id_col -1] eq "$geneid"){
		my $start = $start_col - 1;
		my $end = scalar(@t) - 1;
		print join "\n",@t[$start .. $end];
	}
}
close IN;
