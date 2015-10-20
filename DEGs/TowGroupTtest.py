#!/usr/bin/python

import os, sys
import re
from scipy import stats

def usage():
	print '\n\tt-test for tow gene groups. Sample size for each phenotype should greater than 3.'
	print '\tAuthor: zhoujj2013@gmail.com'
	print '\tUsage: '+sys.argv[0]+' <group1 file> <group2 file>'
	print '\n\tFile format:'
	print '\tgene1\texpr1\texpr2\t...'
	print '\tgene2\texpr1\texpr2\t...'
	print '\t...'
	sys.exit(2)


if __name__ == "__main__":
	if len(sys.argv) < 2:
		usage()
	
	''' start coding here'''
	
	fh1 = open(sys.argv[1],'rb')
	fh2 = open(sys.argv[2],'rb')
	
	fh1.readline()
	fh2.readline()
	
	normal = {}
	tumor = {}
	
	while True:
		l = fh1.readline()
		if len(l) == 0:
			break
		l = l.strip('\n')
		c = l.split('\t')
		id = c.pop(0)
		#id = c.pop(0)
		normal[id] = []
		normal[id].extend([float(x) for x in c])
	
	
	while True:
		l = fh2.readline()
		if len(l) == 0:
			break
		l = l.strip('\n')
		c = l.split('\t')
		id = c.pop(0)
		#id = c.pop(0)
		tumor[id] = []
		tumor[id].extend([float(x) for x in c])
	
	#print normal
	
	for k in normal:
		r = stats.ttest_ind(normal[k],tumor[k])
		print '%s\t%f\t%f' % (k,r[0],r[1]);
	
