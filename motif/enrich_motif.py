#!/usr/bin/python

import os, sys
import re
from scipy.stats import hypergeom
import numpy as np

def usage():
	print '\n\tThis scrtip used for p value calculation.'
	print '\tAuthor: zhoujj2013@gmail.com'
	print '\tUsage: '+sys.argv[0]+' express_gene.lst degs.lst tf.bind.lst prefix'
	print '\tExample: python ' + sys.argv[0] + ''
	print '\n'
	sys.exit(2)


if __name__ == "__main__":
	if len(sys.argv) < 2:
		usage()
	
	''' start coding here'''
	expr_f = open(sys.argv[1], 'rb')
	expr = {}
	expr_num = 0
	while True:
		l = expr_f.readline()
		if len(l) == 0:
			break
		lc = l.strip("\n").split("\t")
		expr[lc[0]] = 1
		expr_num = expr_num + 1
	
	degs_f = open(sys.argv[2], 'rb')
	degs = {}
	degs_num = 0
	while True:
		l = degs_f.readline()
		if len(l) == 0:
			break
		lc = l.strip("\n").split("\t")
		degs[lc[0]] = 1
		degs_num = degs_num + 1

	tf_b = open(sys.argv[3], 'rb')
	tf = {}
	tf_num = 0
	tf_degs = 0
	while True:
		l = tf_b.readline()
		if len(l) == 0:
			break
		lc = l.strip("\n").split("\t")
		tf[lc[1]] = 1
		if lc[1] in expr:
			tf_num = tf_num + 1
		if lc[1] in degs:
			tf_degs = tf_degs + 1
	
	#print expr_num
	#print degs_num
	#print tf_num
	#print tf_degs
	
	## [M, n, N]
	[express_genes, degs, tf_binding_genes] = [expr_num, degs_num, tf_num]
	#rv = hypergeom(express_genes, degs, tf_binding_genes)
	#x = np.arange(0, 10)
	#pmf_tfBindDegs = rv.pmf(1)
	#print np.sum(pmf_tfBindDegs)
	#print 1-np.sum(pmf_tfBindDegs)
	# the probability less than tf_degs
	prb = hypergeom.cdf(tf_degs, express_genes, degs, tf_binding_genes)
	#pvalue = 1 - hypergeom.cdf(tf_degs, express_genes, degs, tf_binding_genes)
	
	#if pvalue > 1:
	#	print >>sys.stderr, prefix
	
	prefix = sys.argv[4]

	print "%s\t%.12f\t%d\t%d\t%d\t%d" % (prefix, prb, express_genes, degs, tf_binding_genes, tf_degs)

