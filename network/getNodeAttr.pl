#!/usr/bin/perl -w

use strict;

my ($int_f, $col) = @ARGV;

my @col = split /,/,$col;
for(my $i = 0; $i < scalar(@col); $i++){
	$col[$i] = $col[$i]-1;
}


my %node;
open IN,"$int_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $a = $t[$col[0]];
	my $b = $t[$col[1]];
	($node{$a}{'out'},$node{$a}{'in'}) = (0,0) if(!(exists $node{$a}{'out'} && exists $node{$a}{'in'}));
	($node{$b}{'out'},$node{$b}{'in'}) = (0,0) if(!(exists $node{$b}{'out'} && exists $node{$b}{'in'}));
	$node{$a}{'out'}++;
	$node{$b}{'in'}++;
}
close IN;

#use Data::Dumper;
#print Dumper(\%node);

print "#id\tout\tin\ttotal\n";
foreach my $k (keys %node){
	my $total = $node{$k}{'in'} + $node{$k}{'out'};
	print "$k\t$node{$k}{'out'}\t$node{$k}{'in'}\t$total\n";
}

