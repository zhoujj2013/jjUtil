import os, sys
import re
import requests
import time

def usage():
	print '\nGet gene list by RESTful api and NCBI.\n'
	print '1. get ncbi gene id by species short name;\n'
	print '2. get gene symbol for each genes through NCBI;\n'
	print '3. prepare result files, gene.info, geneName.lst;\n'
	print 'Author: zhoujj2013@gmail.com\n'
	print 'Usage: python '+sys.argv[0]+' spe [mmu,hsa] gene2symbol.lst > target 2>err'
	print ''
	sys.exit(2)

# check args
if len(sys.argv) < 2:
	usage()

spe = sys.argv[1]
gene2symbol_f = sys.argv[2]

gene2symbol_fh = open(gene2symbol_f, 'rb')

gene2sym = {}
while True:
	l = gene2symbol_fh.readline()
	if len(l) == 0:
		break
	lc = l.strip("\n").split("\t")
	gene2sym[lc[0]] = lc[1]
gene2symbol_fh.close()

#print gene2sym
p_info_fh = open(spe + ".gene.info","wb")

response = requests.get("http://rest.kegg.jp/conv/" + spe + "/ncbi-geneid")

if response.status_code == 200:
	lines = response.content.split("\n")
	for l in lines:
		if len(l) <= 0:
			break
		lc = l.split("\t")
		#print lc[0]
		#print >>p_info_fh, lc[0] + "\t" + lc[1];
		tmp, geneid =lc[0].split(":")
		kegg_geneid = lc[1]
		if geneid in gene2sym:
			print geneid + "\t" + kegg_geneid + "\t" + gene2sym[geneid]
		else:
			print >>sys.stderr, 'Gene id %s %s is not exists!' % (geneid, kegg_geneid)
else:
	print "Error!"

p_info_fh.close()

