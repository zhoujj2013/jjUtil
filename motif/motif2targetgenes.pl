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

        This script designed for target gene mapping.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <motif.bed> <refgene.txt> <prefix>

USAGE
print "$usage";
exit(1);
};

my $motif_bed = shift;
my $refgene_f = shift;
my $prefix = shift;
my %index;
open IN,"$refgene_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	$index{$t[1]} = $t[12];
}
close IN;

#print Dumper(\%index);
my %target;
open IN,"$motif_bed" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $id;
	if($t[3] =~ /#/){
		my @tt = split /#/,$t[3];
		$id = $tt[0];
	}else{
		$id = $t[3];
	}
	$target{$id}{'score'} = $t[4];
	$target{$id}{'hit'}++;
	#print "$prefix\t$index{$t[3]}\tmotif\t$t[4]\tco-express\n";
}
close IN;

my %genetarget;
foreach my $t (keys %target){
	print STDERR "$prefix\t$t\tmotif\t$target{$t}{'hit'}\tpssm\n";
	
	if(exists $genetarget{$index{$t}}){
		$genetarget{$index{$t}} = $target{$t}{'hit'} if($target{$t}{'hit'} > $genetarget{$index{$t}});
	}else{
		$genetarget{$index{$t}} = $target{$t}{'hit'};
	}
}

foreach my $g (keys %genetarget){
	print "$prefix\t$g\tmotif\t$genetarget{$g}\tpssm\n";
}
