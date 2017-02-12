import os, sys
import re
import requests
import time

def usage():
	print '\nGet kegg db by RESTful api.\n'
	print '1. get kegg pathway id by species short name;\n'
	print '2. get related genes for each pathway;\n'
	print '3. prepare result files, pathway.info, pathway2genes.txt and gene2pathways.txt;\n'
	print 'Author: zhoujj2013@gmail.com\n'
	print 'Usage: python '+sys.argv[0]+' '
	print ''
	sys.exit(2)

# check args
if len(sys.argv) < 1:
	usage()

kegg = sys.argv[1]
kegg_geneid_f = sys.argv[2]

gene2sym = {}
kegg_geneid_fh = open(kegg_geneid_f, 'rb')
while True:
	l = kegg_geneid_fh.readline();
	if len(l) <= 0:
		break
	lc = l.strip("\n").split("\t")
	gene2sym[lc[1]] = lc[2]

kegg2gene_fh = open("kegg2gene." + kegg + ".tmp","wb")
response= requests.get("http://rest.kegg.jp/link/genes/" + kegg)
pathway_genes = {}
if response.status_code == 200:
	lines = response.content.split("\n")
	for l in lines:
		if len(l) <= 0:
			break
		lc = l.strip("\n").split("\t")
		if lc[1] in gene2sym:
			pathway_genes[gene2sym[lc[1]]] = 1
		else:
			print >>sys.stderr, '%s can not find gene symbol' % (lc[1])	
else:
	print "Error!"

pathway_genes_str = "\t".join(pathway_genes.keys())
print >>kegg2gene_fh, '%s\t%s' % (kegg,pathway_genes_str)
