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

spe = sys.argv[1]
#kegg_geneid_f = sys.argv[2]
#
#gene2sym = {}
#kegg_geneid_fh = open(kegg_geneid_f, 'rb')
#while True:
#	l = kegg_geneid_fh.readline();
#	if len(l) <= 0:
#		break
#	lc = l.strip("\n").split("\t")
#	gene2sym[lc[1]] = lc[2]
#
p_info_fh = open(spe + ".pathway.info","wb")
response = requests.get("http://rest.kegg.jp/list/pathway/" + spe)

#kegg2gene_fh = open(spe + ".kegg2gene","wb")
#gene2kegg_fh = open(spe + ".gene2kegg","wb")

if response.status_code == 200:
	lines = response.content.split("\n")
	gene2kegg = {}
	for l in lines:
		if len(l) <= 0:
			break
		lc = l.split("\t")
		tmp, pid =lc[0].split(":")
		print >>p_info_fh, pid + "\t" + lc[1];
#		tmp, pid =lc[0].split(":")
#		pathway_genes = {}
#		# find genes
#		p_response= requests.get("http://rest.kegg.jp/link/genes/" + pid)
#		if p_response.status_code == 200:
#			p_lines = p_response.content.split("\n")
#			for pl in p_lines:
#				if len(pl) <= 0:
#					break
#				plc = pl.strip("\n").split("\t")
#				if plc[1] in gene2sym:
#					pathway_genes[gene2sym[plc[1]]] = 1
#					if gene2sym[plc[1]] in gene2kegg:
#						gene2kegg[gene2sym[plc[1]]].append(pid)
#					else:
#						gene2kegg[gene2sym[plc[1]]] = []
#						gene2kegg[gene2sym[plc[1]]].append(pid)
#				else:
#					print >>sys.stderr, '%s can not find gene symbol' % (plc[1])	
#		else:
#			print "Error!"
#		
#		pathway_genes_str = "\t".join(pathway_genes.keys())
#		print >>kegg2gene_fh, '%s\t%s\t%s' % (pid,lc[1],pathway_genes_str)
#	time.sleep(10)
#	
#	########## gene2kegg ###########
	
else:
	print "Error!"

p_info_fh.close()

