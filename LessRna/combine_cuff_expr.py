#!/usr/bin/python

import os, sys
import re

program = sys.argv.pop(0)

geneid = {}
for p in sys.argv:
	pc = p.split(':')
	f = open(pc[0], 'rb')
	f.readline()
	while True:
		l = f.readline()
		if len(l) == 0:
			break
		c = l.split('\t')
		#if re.search(r'^ENS',c[0]):
		if c[0] not in geneid:
			geneid[c[0]] = []
			#geneid[c[0]].append(c[1])
			#geneid[c[0]].append(c[6])
	f.close()

#print geneid

header = []
#header.append("ensemblid")
header.append("geneid")
#header.append("locate")

for p in sys.argv:
	pc = p.split(':')
	header.append(pc[1])
	f = open(pc[0], 'rb')
	f.readline()
	expr = {}
	while True:
		l = f.readline()
		if len(l) == 0:
			break
		l = l.strip('\n')
		c = l.split('\t')
		#if re.search(r'^ENS',c[0]):
		if c[0] not in expr:
			expr[c[0]] = c[2]
	f.close()
	for k,v in geneid.items():
		if k in expr:
			geneid[k].append(expr[k])
		else:
			geneid[k].append("0")

print "\t".join(header)
for k,v in geneid.items():
	print k + '\t',
	print "\t".join(geneid[k])

