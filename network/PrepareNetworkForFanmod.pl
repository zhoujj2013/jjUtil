#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        This script to replace name by number, suitable for motif finder software.
        Fanmod is a popular software for network motif detection.
        It support color vetcle and edges.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <interaction parameters> <node parameters> <edge parameters>
        perl $0 int.txt miRNA,1:lncRNA,2:TF,3:node.lst tfchip,1:mirclip,2:edge.lst
        Format:
        int.txt
        node1  node2  ...
        node1  node22 ...
        ...
        node.lst
        node1  miRNA
        node2  lncRNA
        node22 TF
        ...
        edge.lst
        node1  node2 tfchip
        node1  node22 mirclip
        ...
USAGE
print "$usage";
exit(1);
};


my ($int_f,$node_f,$edge_f) = @ARGV;

########################
my ($colorNode, $colorEdge) = (0,0);
my ($node_file, %node_type);
if($node_f ne 'none'){
	$colorNode = 1;
	my @node_f = split /:/,$node_f;
	$node_file = pop(@node_f);
	foreach my $t (@node_f){
		my ($type, $num) = split /,/,$t;
		$node_type{$type} = $num;
	}
}

my %nodeIndex;
my %nodeNum;
if($node_f ne 'none'){
	my $i = 0;
	open IN,"$node_file" || die $!;
	while(<IN>){
		chomp;
		my @t = split /\t/;
		$nodeIndex{$t[0]} = $t[1];
		$nodeNum{$t[0]} = $i;
		$i++;
	}
	close IN;
}

###############
my ($edge_file, %edge_type);
if($edge_f ne 'none'){
	$colorEdge = 1;
	my @edge_f = split /:/,$edge_f;
	$edge_file = pop(@edge_f);
	foreach my $t (@edge_f){
		my ($type, $num) = split /,/,$t;
		$edge_type{$type} = $num;
	}
}

my %edgeIndex;
if($edge_f ne 'none'){
	open IN,"$edge_file" || die $!;
	while(<IN>){
		chomp;
		my @t = split /\t/;
		$edgeIndex{$t[0]}{$t[1]} = $t[2];
	}
	close IN;
}
#################################

open IN,"$int_f" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my @Newt;
	push @Newt,$nodeNum{$t[0]};
	push @Newt,$nodeNum{$t[1]};
	
	if($colorNode == 1){
		push @Newt,$node_type{$nodeIndex{$t[0]}};
		push @Newt,$node_type{$nodeIndex{$t[1]}};
	}
	
	if($colorEdge == 1){
		push @Newt,$edge_type{$edgeIndex{$t[0]}{$t[1]}};
	}
	print join "\t",@Newt;
	print "\n";
}
close IN;
