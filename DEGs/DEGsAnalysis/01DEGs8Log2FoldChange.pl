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

        This script design for differential express gene analysis by Log2FoldChange comparision.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <control> <treatment> <control> <treatment> <geneexpr file> <log2foldchange cutoff>
        Note: control vs. treatment
USAGE
print "$usage";
exit(1);
};

my ($group_name1, $group_name2, $group_col1, $group_col2, $expr_f, $cutoff) = @ARGV;

my @group_col1 = split /,/,$group_col1;
my @group_col2 = split /,/,$group_col2;


open OUT,">","$group_name1.vs.$group_name2.expr" || die $!;
open IN,"$expr_f" || die $!;
#### the header
my $header = <IN>;
my @header = split /\t/,$header;
print OUT "$header[0]\t";
#my @tmp1;
#foreach my $g (@group_col1){
#	push @tmp1,$header[$g-1];
#}
#
#my @tmp2;
#foreach my $g (@group_col2){
#	push @tmp2,$header[$g-1];
#}

print OUT "$group_name1\t$group_name2\n";

# the content
while(<IN>){
	chomp;
	my @t = split /\t/;
	my ($t1,$t2) = (0,0);
	foreach my $g (@group_col1){
    	$t1 = $t1 + $t[$g-1];
	}

	foreach my $g (@group_col2){
    	$t2 = $t2 + $t[$g-1];
	}
	print OUT "$t[0]\t";
	print OUT $t1/scalar(@group_col1);
	print OUT "\t";
	print OUT $t2/scalar(@group_col2);
	print OUT "\n";
}
close IN;
close OUT;

### DEGs
print STDOUT "perl $Bin/log2foldchangeExpr.pl $group_name1.vs.$group_name2.expr 2,3 h > $group_name1.vs.$group_name2.expr.FC\n";
`perl $Bin/log2foldchangeExpr.pl $group_name1.vs.$group_name2.expr 2,3 h > $group_name1.vs.$group_name2.expr.FC`;

print STDOUT "head -1 $group_name1.vs.$group_name2.expr.FC > ./header.txt\n";
`head -1 $group_name1.vs.$group_name2.expr.FC > ./header.txt`;
`grep -v "Log2(" $group_name1.vs.$group_name2.expr.FC > $group_name1.vs.$group_name2.expr.FC.tmp`;

print STDOUT "awk '\$4 >= $cutoff' $group_name1.vs.$group_name2.expr.FC.tmp > $group_name1.vs.$group_name2.expr.FC.up\n";
`awk '\$4 >= $cutoff' $group_name1.vs.$group_name2.expr.FC.tmp> $group_name1.vs.$group_name2.expr.FC.up.tmp`;
`cat ./header.txt $group_name1.vs.$group_name2.expr.FC.up.tmp > $group_name1.vs.$group_name2.expr.FC.up`;

print STDOUT "awk '\$4 <= -$cutoff' $group_name1.vs.$group_name2.expr.FC.tmp > $group_name1.vs.$group_name2.expr.FC.down\n";
`awk '\$4 <= -$cutoff' $group_name1.vs.$group_name2.expr.FC.tmp > $group_name1.vs.$group_name2.expr.FC.down.tmp`;
`cat ./header.txt $group_name1.vs.$group_name2.expr.FC.down.tmp > $group_name1.vs.$group_name2.expr.FC.down`;

