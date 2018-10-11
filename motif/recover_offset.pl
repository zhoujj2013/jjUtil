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

        This script designed for coordinate recovering(for homer).
        Author: zhoujj2013\@gmail.com
	Updated: Wed Nov  1 15:47:42 HKT 2017
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
	$se{$t[3]} = [$t[0], $t[1], $t[2], $t[5]];
}
close IN;

open IN,"$motif_result" || die $!;
<IN>;
while(<IN>){
	chomp;
	next if(/^FASTA/);
	my @t = split /\t/;
	my $se_id = $t[0];
	my $offset = $t[1];
	my $motif_len = length($t[2]);
	my $strand = $t[4];

	unless(exists $se{$se_id}){
		print STDERR "$se_id\n";
		next;
	}
		
	my $tss;
	if(($se{$se_id}[2] + $se{$se_id}[1]) % 2 == 0){
		$tss = int(($se{$se_id}[2] + $se{$se_id}[1])/2);
		$tss = $tss - 1;
	}else{
		$tss = int(($se{$se_id}[2] + $se{$se_id}[1])/2);
	}
	
	my $os = $se{$se_id}[1];
	my $oe = $se{$se_id}[2];
	my $chr = $se{$se_id}[0];
	my $ostrand = $se{$se_id}[3];

	my ($motif_s, $motif_e) = (0,0);
	if($offset >= 0){
		if($strand eq "+"){
			$motif_s = $tss + $offset;
			$motif_e = $motif_s + $motif_len;
		}elsif($strand eq "-"){
			$motif_e = $tss + $offset + 1;
			$motif_s = $motif_e - $motif_len;
		}
	}elsif($offset < 0){
		if($strand eq "+"){
			$motif_s = $tss + $offset;
			$motif_e = $motif_s + $motif_len;
		}elsif($strand eq "-"){
			$motif_e = $tss + $offset + 1;
			$motif_s = $motif_e - $motif_len;
		}
	}
	($motif_s,$motif_e) = ($motif_e,$motif_s) if($motif_s > $motif_e);
	
	#$motif_s = $motif_s + $se{$se_id}[1];
	#$motif_e = $motif_e + $se{$se_id}[1];
	
	print "$se{$se_id}[0]\t$motif_s\t$motif_e\t$t[0]\t$t[5]\t$strand\n";
}
close IN;

