#!/usr/bin/perl -w

use strict;
use FindBin qw($Bin $Script);

my ($genelist_f, $edgelist_f, $genelist_col, $edgelist_col, $direct, $prefix) = @ARGV;

my @edgelist_col = split /,/,$edgelist_col;

$genelist_col = $genelist_col-1;
$edgelist_col[0] = $edgelist_col[0]-1;
$edgelist_col[1] = $edgelist_col[1]-1;

###
if($direct eq "forward"){
	`perl $Bin/../common/fishInWinter.pl -bc $genelist_col -fc $edgelist_col[0] $genelist_f $edgelist_f > $prefix.edge.fwd.int`;
}elsif($direct eq "reverse"){
	`perl $Bin/../common/fishInWinter.pl -bc $genelist_col -fc $edgelist_col[1] $genelist_f $edgelist_f > $prefix.edge.rev.int`;
}elsif($direct eq "both"){
	`perl $Bin/../common/fishInWinter.pl -bc $genelist_col -fc $edgelist_col[0] $genelist_f $edgelist_f > $prefix.edge.fwd.int`;
	`perl $Bin/../common/fishInWinter.pl -bc $genelist_col -fc $edgelist_col[1] $genelist_f $edgelist_f > $prefix.edge.rev.int`;
	`cat $prefix.edge.fwd.int $prefix.edge.rev.int > $prefix.edge.both.int`;
}
