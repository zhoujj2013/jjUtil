#!/usr/bin/perl -w

use strict;

my %prefix;
open IN,"$ARGV[1]" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	$prefix{$t[0]} = $t[2];
}
close IN;

open IN,"$ARGV[0]" || die $!;
<IN>;
while(<IN>){
	chomp;
	my @t = split /\s+/;
	my $id = shift @t;
	my @iid = split /\./,$id;
	push @t,$prefix{$iid[0]};
	print "$id\t";
	print join "\t",@t;
	print "\n";
}
close IN;

