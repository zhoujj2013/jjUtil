import os, sys
import re

def usage():
	print '\nCombine cufflink quantification result to matrix\n'
	print 'Author: zhoujj2013@gmail.com 8/29/2016\n'
	print 'Usage: python '+sys.argv[0]+' 1.gene_tracking:aa 2.gene_tracking:bb ...'
	print ''
	sys.exit(2)

# check args
if len(sys.argv) < 2:
	usage()
