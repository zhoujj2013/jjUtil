#!/usr/bin/perl -w

my $col = $ARGV[1];

my @arr;
my $max = 0;
my $min = 10000000;
open IN,"$ARGV[0]" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	push @arr,$t[$col-1];
	$max = $t[$col-1] if($t[$col-1] > $max);
	$min = $t[$col-1] if($t[$col-1] < $min);
}
close IN;

my @z;
foreach my $a (@arr){
	my $z = ($a-$min)/($max - $min);
	push @z,$z;
}

open IN,"$ARGV[0]" || die $!;
my $i = 0;
while(<IN>){
	chomp;
	my @t = split /\t/;
	$t[$col-1] = $z[$i];
	print join "\t",@t;
	print "\n";
	$i++;
}
close IN;
