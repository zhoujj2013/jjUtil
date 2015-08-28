#!/usr/bin/perl -w

use strict;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        Get raw chipseq signal for a bed file by homer package.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <region> <extend> <bin> <prefix> <homer_dir1> <homer_dir2> ...

USAGE
print "$usage";
exit(1);
};

my $region = shift @ARGV;
my $extend = shift @ARGV;
my $bin = shift @ARGV;
my $prefix = shift @ARGV;

my $str = join " ", @ARGV;
$str = " $str ";

`annotatePeaks.pl $region mm9 -size $extend -hist $bin -d $str > $prefix.txt`;
`grep -v "^Distance" $prefix.txt > $prefix.rm.header.txt`;


