#!/bin/sh

if [ $# -lt 2 ];then
	echo ""
	echo "	build homer tagdir for rna-seq, chip-seq."
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 <bed/bam/sam> <prefix>";
	echo ""
	exit;
fi

input=$1
prefix=$2

if [[ $input =~ .*bed$ ]]
then
makeTagDirectory  $prefix.Tag $input -format bed > $prefix.Tag.log 2>> $prefix.Tag.log
elif [[ $input =~ .*bam$ ]]
then
bedtools bamtobed -i $input > ./$prefix.bed
makeTagDirectory  $prefix.Tag ./$prefix.bed -format bed > $prefix.Tag.log 2>> $prefix.Tag.log
elif [[ $input =~ .*sam$ ]]
then
makeTagDirectory  $prefix.Tag $input -format sam > $prefix.Tag.log 2>> $prefix.Tag.log
else
	echo ""
	echo "	build homer tagdir for rna-seq, chip-seq."
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 <bed/bam/sam> <prefix>";
	echo ""
fi