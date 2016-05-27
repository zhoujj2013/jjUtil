#!/bin/sh

if [ $# -lt 3 ];then
	echo ""
	echo "	Search motif by homer2--find_motif.pl"
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 xxxx.fa xx.motif xxxx.bed prefix";
	echo ""
	exit;
fi

fa=$1
motif=$2
bed=$3
prefix=$4

refgene="/x400ifs-accel/zhoujj/data/mm9/RefSeq/refGene.txt"

if [ ! -e "./homer" ]; then
mkdir "homer"
fi

## 1. search motif
# perl /x400ifs-accel/zhoujj/software/homer/bin/findMotifs.pl $gene $spe ./tmp.motif -start -5000 -end 1000 -p 10  -find $motif > $prefix.insilico.txt 2> $prefix.findmotif.err
perl /x400ifs-accel/zhoujj/software/homer/bin/findMotifs.pl $fa fasta ./homer/$prefix.motif -find $motif > ./homer/$prefix.insilico.txt 2> ./homer/$prefix.findmotif.err

## 2. recover coordinate for motif position
perl /x400ifs-accel/zhoujj/github/jjUtil/motif/recover_offset.pl $bed ./homer/$prefix.insilico.txt > ./homer/$prefix.insilico.bed  2> ./homer/err

## design for remove duplication
#bedtools sort -i Myod1.insilico.bed | bedtools cluster -i stdin | cut -f 7 | sort | uniq | wc -l

## 3. interaction pairs
perl /x400ifs-accel/zhoujj/github/jjUtil/motif/motif2targetgenes.pl ./homer/$prefix.insilico.bed $refgene $prefix > ./homer/$prefix.genes.pssm.int 2> ./homer/$prefix.trans.pssm.int
