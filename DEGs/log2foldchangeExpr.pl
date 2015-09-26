#!/usr/bin/perl -w

use strict;

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
	print $header;
}

while(<IN>){
	chomp;
	my @t = split /\t/;
	#my $id = shift @t;
	#my $desc = shift @t;
	$t[$c[1]] = 0.01 if($t[$c[1]] < 0.01);
	$t[$c[0]] = 0.01 if($t[$c[0]] < 0.01);

	$t[-1] =~ s/\r//g;
	
	my $treatment = $t[$c[1]] + 1;
	my $control = $t[$c[0]] + 1;
	
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