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

        Calculate log2(foldchange) for genes.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <expr.table> <col to compare, eg. 2,3> <h|nh|null>

USAGE
print "$usage";
exit(1);
};

my $f = shift;
my $cstr = shift;
my $h = shift;

my @c = split /,/,$cstr;
$c[1] = $c[1] - 1;
$c[0] = $c[0] - 1;

$h ||= "nh";

open IN,"$f" || die $!;

if($h eq "h"){
	my $header = <IN>;
	chomp($header);
	print "$header\tLog2(FoldChange)\n";
}

while(<IN>){
	chomp;
	my @t = split /\t/;
	#my $id = shift @t;
	#my $desc = shift @t;
	$t[$c[1]] = 0.01 if($t[$c[1]] < 0.01);
	$t[$c[0]] = 0.01 if($t[$c[0]] < 0.01);

	$t[-1] =~ s/\r//g;
	
	my $treatment = $t[$c[1]]+0.01;
	my $control = $t[$c[0]]+0.01;
	
	#print join "\t",@t,"\n";
	
	my $fc1 = sprintf "%.3f",log2($treatment/$control);
	$fc1 = 0.001 if(abs($fc1) < 0.001);
	# id WT KO FC
	#print "$id\t$desc\t$t[0]\t$t[1]\t$fc1\n";
	push @t,$fc1;
	print join "\t",@t;
	print "\n";
}
close IN;

sub log2{
	my $n = shift;
	return log($n)/log(2);
}
