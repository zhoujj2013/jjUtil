#!/usr/bin/env python
#-*- coding:utf-8 -*-

import json
import os, sys

data = json.load(open(sys.argv[1]))

for d in data['datasets']:
	#print d
	#s,dt = d.split(".")
	out = []
	#out.append(s)
	out.append(d)

	for j in data['datasets'][d]['browser']:
		path = data['datasets'][d]['browser'][j][0]['big_data_url']
		
		str = "\t".join(out)
		str = str + "\t" + j
		str = str + "\t" + path
		print str
