#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;
use lib "/home/zhoujj/my_lib/pm";
use bioinfo;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        Get RPKM value for sequence alignment file, such as bam.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <bed> <extend, 15|none> <prefix> <bam1> <bam2> ...

USAGE
print "$usage";
exit(1);
};

my $bed = shift;
my $extend = shift;
my $prefix = shift;

## deal bad file
if($extend ne "none"){
	open OUT,">","$prefix.extend.bed" || die $!;
	open IN,"$bed" || die $!;
	while(<IN>){
		chomp;
		my @t = split /\s+/,$_;
		my $center = $t[1] + int(($t[2] - $t[1])/2);
		$t[1] = $center - $extend;
		$t[2] = $center + $extend;
		print OUT join "\t",@t;
		print OUT "\n";
	}
	close IN;
	close OUT;
}else{
	`ln -s $bed $prefix.extend.bed`;
}

# for rpkm
foreach(@ARGV){
	chomp;
	my $bamf = $_;
	my $bname = basename($bamf, ".bam");
	my $totalReads = `samtools flagstat $bamf | grep "mapped (" | awk '{print \$1}'`;
	chomp($totalReads);
	
	`bedtools coverage -abam $bamf -b $prefix.extend.bed > $prefix.$bname.cov`;

	# output format
	# chrom start end id featureB_num A_cover_length A_length A_cover_fraction
	open IN,"$prefix.$bname.cov" || die $!;
	open OUT,">","$prefix.$bname.cov.rpkm" || die $!;
	while(<IN>){
		chomp;
		my @t = split /\t/;
		my $readcount = $t[-4];
		my $len = $t[-2];
		my $rpkm = $readcount/(($len/1000)*($totalReads/1000000));
		my $CorRpkm = $rpkm;
		$CorRpkm = 0.0001 if($rpkm < 0.01);
		my $logRpkm = log($CorRpkm);
		push @t, $rpkm;
		push @t, $logRpkm;
		print OUT join "\t",@t;
		print OUT "\n";
	}
	close IN;
	close OUT;
}
