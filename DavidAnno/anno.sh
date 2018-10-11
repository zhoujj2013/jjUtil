#!/bin/sh

if [ $# -lt 3 ];then
	echo ""
	echo "	Design for David gene set annotation."
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 <genename.lst> <spe, hsapiens|mmusculus> <prefix>";
	echo ""
	exit;
fi

lst=$(readlink -f $1)
spe=$2
prefix=$3
Bin=$(dirname $0)

cwd=`pwd`

mkdir $prefix.david
cd $prefix.david
perl $Bin/../common/fishInWinter.pl $lst $Bin/$spe.genename2ensemblId.lst > $prefix.genename2ensemblId.lst
cut -f 2 $prefix.genename2ensemblId.lst > $prefix.input
echo "perl $Bin/david_anno_pipeline.pl ENSEMBL_GENE_ID GOTERM_BP_DIRECT,GOTERM_BP_FAT,GOTERM_CC_DIRECT,GOTERM_CC_FAT,GOTERM_MF_DIRECT,GOTERM_MF_FAT,KEGG_PATHWAY,INTERPRO $prefix.david up.input $prefix.genename2ensemblId.lst"
perl $Bin/david_anno_pipeline.pl ENSEMBL_GENE_ID GOTERM_BP_DIRECT,GOTERM_BP_FAT,GOTERM_CC_DIRECT,GOTERM_CC_FAT,GOTERM_MF_DIRECT,GOTERM_MF_FAT,KEGG_PATHWAY,INTERPRO $prefix.david $prefix.input $prefix.genename2ensemblId.lst
#perl $Bin/david_anno_pipeline.pl ENSEMBL_GENE_ID GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT,KEGG_PATHWAY,INTERPRO $prefix.david $prefix.input $prefix.genename2ensemblId.lst
cd ..

