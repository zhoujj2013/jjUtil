#!/usr/bin/python
from __future__ import division
import os, sys
import re

import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.cross_validation import train_test_split

def usage():
	print '\n\tThis script design for linear regression analysis with trainset.'
	print '\tAuthor: zhoujj2013@gmail.com'
	print '\tUsage: '+sys.argv[0]+' <file1> '
	print '\tformat: id	x	y'
	print '\tformat: a     1       3'
	print '\n'
	sys.exit(2)

if __name__ == "__main__":
	if len(sys.argv) < 2:
		usage()

	df = pd.read_table(sys.argv[1], sep= '\t', header=None)
	
	explanatory_variable_columns = set(df.columns.values)
	response_variable_column = df[len(df.columns.values)-1]
	
	# The first and last column describes the targets
	explanatory_variable_columns.remove(0)
	explanatory_variable_columns.remove(len(df.columns.values)-1)
	
	
	X = []
	for i in df[1]:
		X.append([i])
	
	y = []
	for i in response_variable_column:
		y.append([i])
	
	# split data set to train set and test set
	X_train, X_test, y_train, y_test = train_test_split(X, y)
	
	# build the model
	model = LinearRegression()
	model.fit(X_train, y_train)
	
	# prediction
	#print 'Test the model:'
	#print 'A 12" pizza should cost: $%.2f' % model.predict([12])[0]
	
	print 'This measure of the model\'s fitness is called the residual sum of squares cost function.'
	print 'Residual sum of squares: %.2f' % np.mean((model.predict(X_train) - y_train) ** 2)
	print ''
	print 'Solve the cost function'
	print 'Solving ordinary least squares for simple linear regression'
	print 'Variance is a measure of how far a set of values is spread out.'
	print 'Variance of X_train: %.2f' % np.var(X_train, ddof=1)
	print ''
	
	# Covariance is a measure of how much two variables change together.
	X_train_old = X_train
	y_train_old = y_train
	X_train = [ i[0] for i in X_train]
	y_train = [ i[0] for i in y_train]
	print 'Covariance of X_train and y_train: %.2f' % np.cov(X_train, y_train)[0][1]
	print ''
	
	print 'Solve y = a + bx, cost function'
	print 'b = cov(x,y)/var(x)'
	b = float(format(np.cov(X_train, y_train)[0][1]/np.var(X_train, ddof=1), '.4f'))
	print 'b equal to: %.4f' % b
	a = np.mean(y_train) - b*np.mean(X_train)
	print 'a equal to: %.4f' % a
	print 'y = %.2f + %.2fx' % (a, b)
	print ''
	
	# evaluate the model
	print 'R-squared measures how well the observed values of the response variables are predicted by the model'
	print 'R-square=1-(SS-res)/(SS-tot)'
	print 'R-squared: %.4f' % model.score(X_train_old, y_train_old) #model.score(X_test, y_test)
