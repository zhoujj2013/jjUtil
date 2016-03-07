#!/bin/sh

if [ $# -lt 0 ];then
	echo ""
	echo "	desc"
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 <para1> <para2>";
	echo ""
	exit;
fi

refgene=/x400ifs-accel/zhoujj/data/mm9/RefSeq/refGene.txt
genome=/x400ifs-accel/zhoujj/data/mm9/mm9.genome
fa=/x400ifs-accel/zhoujj/data/mm9/fasta/mm9.fa

# get promoter
#perl -ne 'chomp; my @t = split /\t/; my $end = $t[4]+1; print "$t[2]\t$t[4]\t$end\t$t[1]\t$t[12]\t$t[3]\n";' $refgene > tss.bed
perl /x400ifs-accel/zhoujj/github/jjUtil/motif/getTss.pl /x400ifs-accel/zhoujj/data/mm9/RefSeq/refGene.txt > tss.bed
# ref: http://bejerano.stanford.edu/great/public/html/
bedtools slop -s -l 5000 -r 1000 -i tss.bed -g $genome > promoter.bed

bedtools getfasta -name -fi $fa -bed promoter.bed -fo promoter.fa


