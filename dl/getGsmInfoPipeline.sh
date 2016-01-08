#!/bin/sh

if [ $# -lt 2 ];then
	echo ""
	echo "	Input a .gds file(comtain geo samples, gsm, from GEO search), get desc information for each dataset."
	echo "  eg. (RNA-seq) AND \"Mus musculus\"[porgn:__txid10090]"
	echo "      (H3K27ac) AND \"Mus musculus\"[porgn:__txid10090]"
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 <*.gsd> <prefix>";
	echo ""
	exit;
fi

gds=$1
prefix=$2
Bin=$(dirname $0)

# convert gds to gsm list.
perl $Bin/get_gsmid.pl $gds > gds_result.gsmid.lst

# get gsm infomation
mkdir gsmid
cd gsmid
split -l 10 ../gds_result.gsmid.lst gsmid.

ls ./gsmid.* | while read line; do echo "perl $Bin/getGsmInfoByGsm.pl $line > $line.out 2>$line.err" ;done > ./get.gsmid.sh;

perl $Bin/../common/multi-process.pl --cpu 60 ./get.gsmid.sh

cat ./gsmid.*.out > $prefix.gsmid.lst
cd ..

# combine the result
cp ./gsmid/$prefix.gsmid.lst .
echo "Done."
