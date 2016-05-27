#!/usr/bin/python

import math
import os, sys
from scipy.stats import pearsonr

fin = open(sys.argv[1], 'rb') 

col = fin.readline().strip("\n").split('\t')

print '\t'.join(col)

arr = []
#print len(col)
for i in range(1,len(col)):
	arr.append([])

#print len(arr)
#print arr

while True:
	l = fin.readline()
	if len(l) == 0:
		break
	lc = l.strip('\n').split('\t')
	#print len(lc)
	
	for i in range(1,len(lc)):
		j = i - 1
		arr[j].append(float(lc[i]))

fin.close()

###
for i in range(0,len(arr)):
	result = []
	result.append(col[i+1])
	for j in range(0,len(arr)):
		pcc = pearsonr(arr[i],arr[j])
		result.append(pcc[0])
	print "\t".join([str(s) for s in result])

