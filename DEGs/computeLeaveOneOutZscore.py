#!/usr/bin/python

from scipy import stats
import numpy as np
import sys, os
import re

def usage():
	print '\n\tCalculate leave-one-out zscore for tow sample groups. Sample size for each phenotype should greater than 3.'
	print '\tAuthor: zhoujj2013@gmail.com'
	print '\tUsage: '+sys.argv[0]+' <group1 expr file> <group2 expr file>'
	print '\n\tFile format:'
	print '\tGeneID\tsample1\tsample2'
	print '\tgene1\texpr1\texpr2\t...'
	print '\tgene2\texpr1\texpr2\t...'
	print '\t...'
	sys.exit(2)

if __name__ == "__main__":
	if len(sys.argv) < 2:
		usage()
	
	''' start coding here'''

	NIn = open(sys.argv[1], 'rb')
	TIn = open(sys.argv[2], 'rb')
	
	Nor = {}
	
	while True:
		l = NIn.readline()
		if len(l) == 0:
			break
		if re.search('GeneID', l):
			continue
		l = l.strip('\n')
		lc = l.split('\t')
		expr = lc[3:]
		gid = lc[1]
		Nor[gid] = expr
	NIn.close()
	
	#print Nor	
	
	while True:
		l = TIn.readline()
		if len(l) == 0:
			break
		if re.search('GeneID', l):
			continue
		l = l.strip('\n')
		lc = l.split('\t')
		expr = lc[3:]
		gid = lc[1]
		Tmean = stats.tmean(np.array(expr).astype(np.float))
		Tstd = stats.tstd(np.array(expr).astype(np.float))
		if gid in Nor:
			# calculate leave one out Z-scoure
			Nmean = stats.tmean(np.array(Nor[gid]).astype(np.float))
			Nstd = stats.tstd(np.array(Nor[gid]).astype(np.float))
			zscore = (Tmean - Nmean)/(Tstd + Nstd)
			print lc[0] + '\t' + lc[1] + '\t' + lc[2] + '\t' + str(Nmean) + '\t' + str(Nstd) + '\t' + str(Tmean) + '\t' + str(Tstd) + '\t' + str(zscore)
