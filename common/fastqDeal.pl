#!/usr/bin/perl -w

use strict;

my ($r1, $r2, $count, $prefix) = @ARGV;

mkdir "./$prefix.cuts" unless(-e "./$prefix.cuts");

open IN,"$r1" || die $!;
while(){
	
}
close IN;
