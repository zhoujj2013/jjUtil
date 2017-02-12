#!/bin/sh

if [ $# -lt 4 ];then
	echo ""
	echo "	Get differential express gene from cufflinks result."
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 gene_exp.diff prefix spe[hsapiens|mmusculus] option[deg,anno,heatmap,scatterplot,volcanoplot]";
	echo ""
	exit;
fi
