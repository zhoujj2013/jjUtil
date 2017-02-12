#!/usr/bin/python

import os, sys
import re

from numpy.linalg import lstsq
from sklearn.linear_model import LinearRegression
from sklearn.cross_validation import train_test_split

def usage():
	print '\n\tThis script design for multiple linear regression'
	print '\tAuthor: zhoujj2013@gmail.com'
	print '\tUsage: '+sys.argv[0]+' <file1> '
	print '\tformat: id x1 x2 x3 ... y'
	print '\n'
	sys.exit(2)


if __name__ == "__main__":
	if len(sys.argv) < 2:
		usage()
	
	''' start coding here'''
	f = open(sys.argv[1], 'rb')

	X = []
	x = []
	y = []
	while True:
		l = f.readline()
		if len(l) == 0:
			break
		lc = l.strip().split('\t')
		y.append([float(lc.pop())])
		lc.pop(0)
		lc = [float(i) for i in lc]
		x.append(lc)
	
		lc.insert(0, 1)
		X.append(lc)
	f.close()
	
	print 'Solve beta using NumPy'
	print lstsq(x, y)[0]
	
	X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.5)

	model = LinearRegression()
	model.fit(X_train, y_train)
	
	predictions = model.predict(X_test)
	for i, prediction in enumerate(predictions):
		print 'Predicted: %s, Target: %s' % (prediction, y_test[i])
		if i > 10:
			break
	
	predictions = model.predict(X_test)
	print 'R-squared: %.2f' % model.score(X_test, y_test)
	
