#!/bin/sh

if [ $# -lt 1 ];then
	echo ""
	echo "	Get ensembl id by species official short name(hsapiens, mmusculus etc.)."
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 mmusculus";
	echo ""
	exit;
fi

spe=$1
Bin=$(dirname $0)

perl $Bin/get_ensembl_id_map.pl $spe > $spe.ensemblId2genename.lst
awk '{print $2"\t"$1}' $spe.ensemblId2genename.lst >  $spe.genename2ensemblId.lst

