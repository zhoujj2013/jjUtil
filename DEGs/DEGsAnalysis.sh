#!/bin/sh

if [ $# -lt 4 ];then
	echo ""
	echo "	Get differential express gene from cufflinks result."
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 gene_exp.diff prefix spe option[deg,anno,heatmap,scatterplot,volcanoplot]";
	echo ""
	exit;
fi

diff=$1
prefix=$2
spe=$3
opt=$4

Bin=$(dirname $0)

if [ $opt = "deg" ]; then
grep "yes" $diff > $prefix.gene_exp.diff.deg

awk '$8 < $9' $prefix.gene_exp.diff.deg > $prefix.gene_exp.diff.deg.up.tmp
awk '$8 > $9' $prefix.gene_exp.diff.deg > $prefix.gene_exp.diff.deg.down.tmp

head -1 $diff > header.txt

cat header.txt $prefix.gene_exp.diff.deg.up.tmp > $prefix.gene_exp.diff.deg.up
cat header.txt $prefix.gene_exp.diff.deg.down.tmp > $prefix.gene_exp.diff.deg.down

perl $Bin/get_ensembl_id_map.pl $spe > $spe.ensemblId2genename.lst
awk '{print $2"\t"$1}' $spe.ensemblId2genename.lst >  $spe.genename2ensemblId.lst 

fi

if [ $opt = "anno" ]; then
mkdir up down

cd up
cut -f 1 ../$prefix.gene_exp.diff.deg.up.tmp > up.lst
perl $Bin/../common/fishInWinter.pl up.lst ../$spe.genename2ensemblId.lst > $prefix.up.genename2ensemblId.lst
cut -f 2 $prefix.up.genename2ensemblId.lst > up.input

perl $Bin/../DavidAnno/david_anno_pipeline.pl ENSEMBL_GENE_ID GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT,KEGG_PATHWAY,INTERPRO $prefix.david up.input $prefix.up.genename2ensemblId.lst
cd ..


cd down
cut -f 1 ../$prefix.gene_exp.diff.deg.down.tmp > down.lst
perl $Bin/../common/fishInWinter.pl down.lst ../$spe.genename2ensemblId.lst > $prefix.down.genename2ensemblId.lst
cut -f 2 $prefix.down.genename2ensemblId.lst > down.input

perl $Bin/../DavidAnno/david_anno_pipeline.pl ENSEMBL_GENE_ID GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT,KEGG_PATHWAY,INTERPRO $prefix.david down.input $prefix.down.genename2ensemblId.lst
cd ..

rm $prefix.gene_exp.diff.deg.up.tmp $prefix.gene_exp.diff.deg.down.tmp header.txt
fi

if [ $opt = "heatmap" ]; then
echo "perl $Bin/ToLog10.pl $diff 4 h | grep -v "^ensem" > $diff.log10"
echo "perl $Bin/../common/fishInWinter.pl $prefix.gene_exp.diff.deg $diff.log10 > $prefix.deg.expr.log10.diff"
echo "cp /x400ifs-accel/zhoujj/github/jjUtil/heatmap/drawHeatmap4AllSamples.r ."
echo "Rscript ./drawHeatmap4AllSamples.r $prefix.hm 4,5,6,7,8,9 a1,a2,a3,b1,b2,b3 $prefix.deg.expr.log10.diff"
fi

if [ $opt = "scatterplot" ]; then
echo "awk '\$14 == \"no\"' $diff > $prefix.gene_exp.diff.nondeg"
echo "cat header.txt $prefix.gene_exp.diff.nondeg > $prefix.gene_exp.diff.nondeg.sp"
echo "cat header.txt $prefix.gene_exp.diff.deg > $prefix.gene_exp.diff.deg.sp"
echo "cut -f 1,8,9 $prefix.gene_exp.diff.nondeg.sp > $prefix.gene_exp.diff.nondeg.expr"
echo "cut -f 1,8,9 $prefix.gene_exp.diff.deg.sp > $prefix.gene_exp.diff.deg.expr"
echo "cp /x400ifs-accel/zhoujj/github/jjUtil/DEGs/diffplot2.r ."
echo "Rscript ./diffplot2.r $prefix.gene_exp.diff.nondeg.expr $prefix.gene_exp.diff.deg.expr $prefix.sp"
fi

if [ $opt = "volcanoplot" ]; then
echo "grep -v \"^test_id\" $diff | cut -f 1,8,9,10,12,13 | awk '\$6 < 1' > $prefix.diff.short"
echo "perl $Bin/log2foldchangeExpr.pl $prefix.diff.short 2,3 nh > $prefix.diff.short.fc"
echo "awk '{print \$1\"\t\"\$7\"\t\"\$5\"\t\"\$6}' $prefix.diff.short.fc > $prefix.diff.short.fc.vp"
echo "cp /x400ifs-accel/zhoujj/github/jjUtil/DEGs/volcanoplot.r ."
echo "Rscript ./volcanoplot.r $prefix.diff.short.fc.vp $prefix.vp"
fi
