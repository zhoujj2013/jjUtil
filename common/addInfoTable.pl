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

        Add table2 information to the table1.
        Table2 must have uniq id.
        Table1 not required. 
        Author: zhoujj2013\@gmail.com
        Usage: $0 <table1 index col> <table2 index col> <table1.file> <table2.file>

USAGE
print "$usage";
exit(1);
};

my $index_c1 = shift;
my $index_c2 = shift;

my $f1 = shift;
my $f2 = shift;

my %h;
open IN,"$f2" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	$h{$t[$index_c2-1]} = \@t;
}
close IN;

open IN,"$f1" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	if(exists $h{$t[$index_c1-1]}){
		my $str = join "\t",@{$h{$t[$index_c1-1]}};
		print "$_\t";
		print "$str\n";
	}else{
		print "$_\t\t\n";
	}
}
close IN;
