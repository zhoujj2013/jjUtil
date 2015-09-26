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

        Description of this script.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <para1> <para2>
        Example:perl $0 para1 para2

USAGE
print "$usage";
exit(1);
};

my $h = <>;
print $h;
while(<>){
	chomp;
	my @t = split /\t/;
	for(my $c=3; $c < scalar(@t); $c++){
		if($t[$c] eq "0" || $t[$c] < 0.01){
			$t[$c] = "0.01";
		}
	}
	print join "\t",@t;
	print "\n";
}
