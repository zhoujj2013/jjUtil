#!/usr/bin/env python
#-*- coding:utf-8 -*-

import json
import os, sys

data = json.load(open(sys.argv[1]))

for s in data['samples']:
	out = []
	out.append(s)

	if 'tissue_type' in data['samples'][s]:
		out.append(data['samples'][s]['tissue_type'])
	else:
		out.append('NA')
	
	
	if 'cell_type' in data['samples'][s]:
		out.append(data['samples'][s]['cell_type'])
	else:
		out.append('NA')
	
	if 'donor_age' in data['samples'][s]:
		out.append(str(data['samples'][s]['donor_age']))
	else:
		out.append('NA')

	if 'donor_age_unit' in data['samples'][s]:
		out.append(str(data['samples'][s]['donor_age_unit']))
	else:
		out.append('NA')
		
	if 'disease' in data['samples'][s]:
		out.append(data['samples'][s]['disease'])
	else:
		out.append('NA')

	if 'donor_sex' in data['samples'][s]:
		out.append(data['samples'][s]['donor_sex'])
	else:
		out.append('NA')

	if 'donor_health_status' in data['samples'][s]:
		out.append(data['samples'][s]['donor_health_status'])
	else:
		out.append('NA')
	
	print "\t".join(out)
