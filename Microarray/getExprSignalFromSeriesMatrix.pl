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

        Description of this script.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <para1> <para2>
        Example:perl $0 para1 para2

USAGE
print "$usage";
exit(1);
};

my $f = shift;
my $prefix = shift;

my @sample;
my @gsm;

open OUT2,">","$prefix.expr.signal.txt" || die $!;
open IN,"$f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	next if(/^\^/);
	next if(/^$/);
	
	
	if(/^\!/){
		if(/Sample_title/){
			shift @t;
			foreach my $n (@t){
				$n =~ s/"//g;
				push @sample,$n;
			}
		}
		if(/Sample_geo_accession/){
			shift @t;
			foreach my $g (@t){
				$g =~ s/"//g;
				push @gsm,$g;
			}
		}
	}elsif(/"ID_REF"/){
		open OUT,">","./$prefix.sample.info" || die $!;
		for(my $i = 0; $i < scalar(@sample); $i++){
			print OUT "$gsm[$i]\t$sample[$i]\n";
		}
		close OUT;
		
		my @header;
		foreach my $h (@t){
			$h =~ s/"//g;
			push @header,$h;
		}
		print OUT2 join "\t",@header;
		print OUT2 "\n";
	}else{
		print OUT2 join "\t",@t;
		print OUT2 "\n";
	}
}
close IN;
close OUT2;
