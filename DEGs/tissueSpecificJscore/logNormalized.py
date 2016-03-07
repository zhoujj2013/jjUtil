#!/usr/bin/python

import os, sys
import re
import math

def usage():
	print '\n\tThis is the usage function'
	print '\tAuthor: zhoujj2013@gmail.com'
	print '\tUsage: '+sys.argv[0]+' XXX.expr '
	print '\tExample: python ' + sys.argv[0] + ' XXX.expr '
	print '\n'
	sys.exit(2)


if __name__ == "__main__":
	if len(sys.argv) < 2:
		usage()
	
	''' start coding here'''
	expr_matrix_f = sys.argv[1]
	
	f = open(expr_matrix_f, 'rb')
	header = f.readline().strip("\n")
	print header
	while True:
		l = f.readline()
		if len(l) == 0:
			break
		lc = l.strip("\n").split("\t")
		# log => normalization
		# http://genesdev.cshlp.org/content/early/2011/09/02/gad.17446611
		# Supp Material.pdf, page 12
		logSum = 0
		exprlogArr = []
		for i in range(1,len(lc)):
			expr = float(lc[i]) + 1
			exprlog = math.log(expr)/math.log(2)
			exprlogArr.append(exprlog)
			logSum = logSum + exprlog;
	
		if logSum == 0:
			continue
			
		exprNormalizedArr = []
		for elog in exprlogArr:
			exprNormalized = elog/logSum
			exprNormalizedArr.append(str(exprNormalized))
		
		exprNormalizedStr = "\t".join(exprNormalizedArr)
		print lc[0] + "\t" + exprNormalizedStr
