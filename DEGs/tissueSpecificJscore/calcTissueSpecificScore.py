#!/usr/bin/python

import os, sys
import re
from scipy.stats import entropy
import math

def usage():
	print '\n\tThis script designed for tissueSpecificJscore.'
	print '\tref: http://www.ncbi.nlm.nih.gov/pubmed/21890647'
	print '\tAuthor: zhoujj2013@gmail.com'
	print '\tUsage: '+sys.argv[0]+' <expr.matrix.file> <group.sg>'
	print '\texpr.matrix.file Format: genename expr.sample1 expr.sample2 ...'
	print '\tgroup.sg Format: sample_index sampleName groupID'
	print '\n'
	sys.exit(2)


if __name__ == "__main__":
	if len(sys.argv) < 2:
		usage()
	
	''' start coding here'''
	normalized_expr_f = sys.argv[1]
	sample_group_f = sys.argv[2]
	
	# read in group
	gSeq = []
	gSample = {}
	f = open(sample_group_f, 'rb')
	while True:
		l = f.readline()
		if len(l) == 0:
			break
		lc = l.strip("\n").split("\t")
		gSeq.append(lc[0])
		if lc[2] not in gSample:
			gSample[lc[2]] = []
		gSample[lc[2]].append(lc[0])
	f.close()
	
	# read in expr
	# print gSample
	f = open(normalized_expr_f, 'rb')
	header = f.readline()
	while True:
		l = f.readline()
		if len(l) == 0:
			break
		lc = l.strip("\n").split("\t")
		name = lc.pop(0)
		
		gexpr = [float(s) for s in lc]
		gtsp = [0 for s in lc]
		gtspMax = 0
		gtspMaxIndex =  0
		for i in range(1,len(gSample.keys())+1):
			predefine = []
			for j in gSeq:
				predefine.append(0.01)
			for k in gSample[str(i)]:
				predefine[int(k)-1] = 1
			
			print "\t".join([str(s) for s in predefine])
			# normalize predefined vector
			preLogSum = 0
			preLogArr = []
			for j in range(0, len(predefine)):
				pre = float(predefine[j]) + 1
				prelog = math.log(pre)/math.log(2)
				preLogArr.append(prelog)
				preLogSum = preLogSum + prelog
			
			print "\t".join([str(s) for s in preLogArr])
			
			predefineNor = []
			for plog in preLogArr:
				predefineNored = plog/preLogSum
				predefineNor.append(predefineNored)
			
			print "\t".join([str(s) for s in predefineNor])
			print "#################"
			# average
			avg_gexpr_predefine = []
			for a in range(0,len(gexpr)):
				avg = (gexpr[a] + predefineNor[a])/2
				avg_gexpr_predefine.append(avg)
			
			# tissue specific score, from http://www.ncbi.nlm.nih.gov/pubmed/21890647
			#print sum(avg_gexpr_predefine)
			#both = entropy(avg_gexpr_predefine)
			#seperate = (entropy(gexpr) + entropy(predefineNor))/2
			#print str(entropy(gexpr)) + "\t" + str(entropy(predefineNor)) + "\t" + str(both) + "\t" + str(seperate)
			
			JSspec = 1-math.sqrt(entropy(avg_gexpr_predefine) - (entropy(gexpr) + entropy(predefine))/2)
			
			for k in gSample[str(i)]:
				gtsp[int(k)-1] = JSspec
			
			if JSspec > gtspMax:
				gtspMax = JSspec
				gtspMaxIndex = i
		
		gtspStr = "\t".join([str(s) for s in gtsp])
		outputline = name + "\t" + gtspStr + "\t" + str(gtspMax) + "\t" + str(gtspMaxIndex)
		print outputline
