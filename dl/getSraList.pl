#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;
use Cwd 'abs_path';
#use lib "/home/zhoujj/my_lib/pm";
#use bioinfo;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        Download sra file by GSM id (GEO).
        Author: zhoujj2013\@gmail.com
        Usage: $0 <gsmid_list> <outdir> <prefix>

USAGE
print "$usage";
exit(1);
};

my ($gsmlst, $outdir, $prefix) = @ARGV;

$outdir = abs_path($outdir);

my @gsm;
open IN,"$gsmlst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $gsm = `Rscript $Bin/getGEO.r $t[0] 2>./$prefix.log`;
	$gsm =~ s/ //g;
	
	my @gsm_tmp= split /\n/,$gsm;
	
	my $i = 1;
	foreach my $g (@gsm_tmp){
		$g = "$t[0]-$i\t$g";
		push @gsm,$g;
		$i++;
	}
}
close IN;

open OUT,">","./$prefix.gsm.lst" || die $!;
print OUT join "\n",@gsm;
close OUT;

my @srx;
foreach my $g (@gsm){
	my @t = split /\t/,$g;
	my $gsmid = $t[1];
	my $srxid = $1 if(basename($t[2]) =~ /term=(\w+)$/);

	#print "$srxid\n";

	my $srx = `Rscript $Bin/getSRA.r $srxid 2>./$prefix.log`;
	$srx =~ s/ //g;
	my @srx_tmp= split /\n/,$srx;
	
	my $i = 1;
	foreach my $s (@srx_tmp){
		$s = "$gsmid-$i\t$gsmid\t$srxid\t$s";
		push @srx,$s;
		$i++;
	}
}

#print join "\n",@srx;

open OUT,">","./$prefix.sra.lst" || die $!;
print OUT join "\n",@srx;
close OUT;

open OUT,">","./$prefix.dl.sh" || die $!;
open OUT2,">","./$prefix.final.lst" || die $!;
foreach my $s (@srx){
	my @t = split /\t/,$s;
	my $bname = basename($t[-1]);
	if(-e "$outdir/$bname"){
		$s = "$s\t$outdir/$bname";
	}else{
		print OUT "wget $t[-1] -O $outdir/$bname >>$outdir/$bname.log\n";
		$s = "$s\t$outdir/$bname";
	}
	print OUT2 "$s\n";
}
close OUT;
close OUT2;
