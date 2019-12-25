#!/bin/sh

if [ $# -lt 3 ];then
	echo ""
	echo "	Design for David gene set annotation."
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 <up.lst> <down.lst> <spe>";
	echo ""
	exit;
fi

up=$1
down=$2
spe=$3

Bin=$(dirname $0)

mkdir up down

cd up
cut -f 1 ../$up.tmp > up.lst
perl $Bin/../../common/fishInWinter.pl up.lst ../$spe.genename2ensemblId.lst > $up.genename2ensemblId.lst
cut -f 2 $up.genename2ensemblId.lst > up.input

echo "perl $Bin/../../DavidAnno/david_anno_pipeline.pl ENSEMBL_GENE_ID GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT,KEGG_PATHWAY,INTERPRO $up.david up.input $up.genename2ensemblId.lst"

perl $Bin/../../DavidAnno/david_anno_pipeline.pl ENSEMBL_GENE_ID GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT,KEGG_PATHWAY,INTERPRO $up.david up.input $up.genename2ensemblId.lst
cd ..


cd down
cut -f 1 ../$down.tmp > down.lst
perl $Bin/../../common/fishInWinter.pl down.lst ../$spe.genename2ensemblId.lst > $down.genename2ensemblId.lst
cut -f 2 $down.genename2ensemblId.lst > down.input

perl $Bin/../../DavidAnno/david_anno_pipeline.pl ENSEMBL_GENE_ID GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT,KEGG_PATHWAY,INTERPRO $down.david down.input $down.genename2ensemblId.lst
cd ..

#rm $up.tmp $down.tmp header.txt
