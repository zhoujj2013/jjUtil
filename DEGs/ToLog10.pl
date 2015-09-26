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

        Turn origin value to log10(value).
        Author: zhoujj2013\@gmail.com
        Usage: $0 <expr.table> <start col to log10> <h|nh|null>

USAGE
print "$usage";
exit(1);
};

my $f = shift;
my $col = shift;
my $h = shift;

$h ||= "nh";

open IN,"$f" || die $!;

if($h eq "h"){
        my $header = <IN>;
        print $header;
}

while(<IN>){
	chomp;
	my @t = split /\t/;
	for(my $c=$col-1; $c < scalar(@t); $c++){
		if($t[$c] eq "0" || $t[$c] < 0.01){
			$t[$c] = "0.01";
		}
	}
	
	for(my $c=$col-1; $c < scalar(@t); $c++){
		$t[$c] = log($t[$c])/log(10);
	}
	
	print join "\t",@t;
	print "\n";
}
close IN;

