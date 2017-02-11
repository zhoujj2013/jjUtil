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
        Usage: $0 prefix spe extend|3000 signal r1.bed r2.bed r3.bed ...

USAGE
print "$usage";
exit(1);
};

my $prefix = shift;
my $spe = shift;
my $extend = shift;
my $bam=shift;

my @region = @ARGV;

open OUT,">","./$prefix.cfg" || die $!;
foreach my $r (@region){
	my $id = $1 if($r =~ /([^.]+)\.bed/);
	print OUT "$bam\t$r\t\"$id\"\n";
}
close OUT;

`ngs.plot.r -G $spe -R bed -C ./$prefix.cfg -O $prefix -L $extend -WD 4 -HG 4 -BOX 1 -GO none -KNC 5 >./$prefix.log 2>./$prefix.err`;


