#!/bin/sh
if [ $# -ne 2 ]
then
	echo "usage: sh qsub.sh <node_num> <makefile>"
	exit 1
fi
node_num=$1
mk=$2

bin=$(dirname $0)
#echo $bin
qsub -cwd -v PATH -v LD_LIBRARY_PATH -v PYTHONPATH -pe make $node_num $bin/qmake.sh $mk
sleep 20s

# qsub -cwd -v PATH -v LD_LIBRARY_PATH -v PYTHONPATH -q all.q -pe make $node_num $bin/qmake.sh $mk
