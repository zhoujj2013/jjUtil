#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;
#use lib "/home/zhoujj/my_lib/pm";
#use bioinfo;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        This script designed for coordinate recovering (for fimo program).
        Author: zhoujj2013\@gmail.com
        Usage: $0 bed motif_result 

USAGE
print "$usage";
exit(1);
};

my ($bed, $motif_result) = @ARGV;

my %se;
open IN,"$bed" ||die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	next if($t[0] =~ /_/);
	$se{$t[3]} = [$t[0], $t[1], $t[2]];
}
close IN;

open IN,"$motif_result" || die $!;
<IN>;
while(<IN>){
	chomp;
	next if(/^#/);
	my @t = split /\t/;
	
	my $se_id = $t[1];
	my $s = $t[2];
	my $e = $t[3];

	unless(exists $se{$se_id}){
		print STDERR "$se_id\n";
		next;
	}
		
	my ($motif_s, $motif_e);
	my ($chr, $os, $oe) = ($se{$se_id}[0], $se{$se_id}[1], $se{$se_id}[2]);
	$motif_s = $os + $s - 1;
	$motif_e = $motif_s + ($e - $s + 1);
	
	($motif_s,$motif_e) = ($motif_e,$motif_s) if($motif_s > $motif_e);
	
	print "$chr\t$motif_s\t$motif_e\t$t[1]\t$t[5]\t$t[4]\n";
}
close IN;

