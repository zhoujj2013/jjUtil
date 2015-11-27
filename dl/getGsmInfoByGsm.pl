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

        Get GSM information by GSM id (GEO).
        Author: zhoujj2013\@gmail.com
        Usage: $0 <gsmid_list>

USAGE
print "$usage";
exit(1);
};

my ($gsmlst) = @ARGV;

my @gsmOut;
open IN,"$gsmlst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $gsm;
	my $flag = 0;
	while(1){
		sleep(10);
		last if($flag > 0);
		$gsm = `Rscript $Bin/getGsmInfoByGsm.r $t[0] 2>>./tmp.log`;
		$flag = 1 if(length($gsm) > 0);
	}
	#$gsm =~ s/ //g;
	
	my @gsm_tmp= split /\n/,$gsm;

	push @gsmOut,join "\t",@gsm_tmp;
}
close IN;

foreach my $l (@gsmOut){
	print "$l\n";
}
#`rm ./tmp.log`;

