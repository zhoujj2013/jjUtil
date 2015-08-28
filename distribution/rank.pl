#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        Description of this script.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <score_f>

USAGE
print "$usage";
exit(1);
};

my $score_f = shift;

my @score;
open IN,"$score_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	push @score,\@t;
}
close IN;

my @score_sorted = sort {$a->[1] <=> $b->[1]} @score;
my $i = 1;
foreach my $l (@score_sorted){
	print "$l->[0]\t$l->[1]\t$i\n";
	$i++;
}
