#!/bin/sh

if [ $# -lt 3 ];then
	echo ""
	echo "	Search motif by MEME suit----fimo"
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 XX.meme seq.fa seq.bed prefix";
	echo ""
	exit;
fi

motif=$1
fasta=$2
bed=$3
prefix=$4



refgene="/x400ifs-accel/zhoujj/data/mm9/RefSeq/refGene.txt"

motifname=$(basename $motif ".meme")

if [ ! -e "./fimo" ]; then
mkdir "fimo"
fi

## 1. search motif
# /x400ifs-accel/zhoujj/software/meme_4.10.0/bin/fimo
#/ifs-accel/ahfyth/software/meme/bin/fimo 
/x400ifs-accel/zhoujj/software/meme_4.10.0/bin/fimo --thresh 1e-4 -text $motif $fasta >./fimo/$prefix.fimo.txt 2> ./fimo/$prefix.fimo.err

## 2. recover coordinate for motif position
perl /x400ifs-accel/zhoujj/github/jjUtil/motif/recover_offset_fimo.pl $bed ./fimo/$prefix.fimo.txt > ./fimo/$prefix.insilico.bed

## 4. interaction pairs
perl /x400ifs-accel/zhoujj/github/jjUtil/motif/motif2targetgenes.pl ./fimo/$prefix.insilico.bed $refgene $prefix > ./fimo/$prefix.genes.pssm.int  2>./fimo/$prefix.trans.pssm.int

