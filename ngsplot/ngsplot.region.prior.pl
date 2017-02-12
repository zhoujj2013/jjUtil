#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use File::Path qw(make_path);
use Data::Dumper;
use Cwd qw(abs_path);

&usage if @ARGV<1;

sub usage {
        my $usage = << "USAGE";

        Density plots.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 prefix spe extend|3000 region 1.bam 2.bam 3.bam ...

USAGE
print "$usage";
exit(1);
};

my $prefix = shift;
my $spe = shift;
my $extend = shift;
my $region=shift;

my @signal = @ARGV;

open OUT,">","./$prefix.cfg" || die $!;
foreach my $s (@signal){
	my $id = $1 if($s =~ /([^\.]+)\.bam/);
	print OUT "$s\t$region\t\"$id\"\n";
}
close OUT;

`ngs.plot.r -G $spe -R bed -C ./$prefix.cfg -O $prefix -L $extend -WD 4 -HG 4 -BOX 1 -GO none -KNC 5 >./$prefix.log 2>./$prefix.err`;


