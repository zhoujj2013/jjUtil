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

        Get meme motif from transfac meme file(convert *.matrix to *.transfac).
        Author: zhoujj2013\@gmail.com
        Usage: $0 transfac.meme <Motif2id.index> <ID>

USAGE
print "$usage";
exit(1);
};

my $meme = shift;
my $motif_index = shift;
my $tf = shift;

my @header;
open IN,"$meme" || die $!;
my $i = 1;
while(<IN>){
	push @header,$_ if($i <= 9);
	last if($i>9);
	$i++;
}
close IN;

my %index;
open IN,"$motif_index" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $motifId = $t[0];
	my $musid = $t[2];
	$index{$musid}{$motifId} = 1;
}
close IN;

my @motif;
open IN,"$meme" || die $!;
$/ = "MOTIF"; <IN>; $/ = "\n";
$/ = "MOTIF";
while(<IN>){
	chomp;
	my @l = split /\n/,$_;
	my $id = $1 if($l[0] =~ /^\s(\S+)/);
	
	if(exists $index{$tf}{$id}){
		print STDERR "$tf\t$id\t$tf.meme\n";
		push @motif,$_;
	}
}
close IN;

print join "",@header;
print "MOTIF";
print join "MOTIF",@motif;
