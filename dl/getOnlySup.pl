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

        Get sup files by gsm id from GEO in cluster 65.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <gsm1>:prefix1 <gsm2>:prefix2 ...

USAGE
print "$usage";
exit(1);
};

foreach my $gsmlit (@ARGV){
	my ($gsm, $prefix) = split /:/,$gsmlit;
	`wget http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=$gsm -O tmp.$prefix.html 2>tmp.$prefix.err`;
	my $sra = "";
	my @sup;
	open IN,"tmp.$prefix.html" || die $!;
	while(<IN>){
		if(/ftp-trace\.ncbi\.nlm\.nih\.gov\/sra/){
			$sra = $1 if(/href="([^"]+)"/);
			$sra= $sra."/*";
		}
		if(/ftp\.ncbi\.nlm\.nih\.gov\/geo/){
			my $suppl = $1 if(/href="([^"]+)"/);
			push @sup,$suppl;
		}
	}
	close IN;
	
	foreach my $l (@sup){
		`wget $l 2>tmp.$prefix.err`;
	}
	
	unless($sra eq ""){
		`wget -m $sra 2>tmp.$prefix.err`;
	}
	#my @srafiles;
	#open IN,"tmp.$prefix.err" || die $!;
	#while(<IN>){
	#	if(/saved/){
	#		if($_ !~ /listing/){
	#			my $sraf = $1 if(/(ftp-trace\.ncbi.*\.sra)/);
	#			push @srafiles,$sraf;
	#		}
	#	}
	#}
	#close IN;

	#
	#if(scalar(@srafiles) <= 0){	
	#	print STDERR "No SRA file for $gsm\n";
	#}else{
	#	foreach my $srapath (@srafiles){
	#		`cp $srapath ./`;
	#		my $ftppath = "ftp://$srapath";
	#		my $bname = basename($srapath);
	#		print "$gsm\t$prefix\t$bname\t$ftppath\n";
	#	}
	#}
	#`rm -rf ftp-trace.ncbi.nlm.nih.gov`;
	`rm -rf tmp.$prefix.err`;
	`rm -rf tmp.$prefix.html`;
}


