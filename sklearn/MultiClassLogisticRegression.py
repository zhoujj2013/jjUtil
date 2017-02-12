#!/usr/bin/python

import os, sys
import re

import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model.logistic import LogisticRegression
from sklearn.cross_validation import train_test_split
from sklearn.metrics.metrics import classification_report, accuracy_score, confusion_matrix
from sklearn.pipeline import Pipeline
from sklearn.grid_search import GridSearchCV

def usage():
	print '\n\tThis script design for logistic regression'
	print '\tAuthor: zhoujj2013@gmail.com'
	print '\tUsage: '+sys.argv[0]+' <file1> '
	print '\tFormat: id feature1 feature2 classes'
	print '\n'
	sys.exit(2)


if __name__ == "__main__":
	if len(sys.argv) < 2:
		usage()
	
	''' start coding here'''
	f = open(sys.argv[1], 'rb')

	x = []
	y = []
	while True:
		l = f.readline()
		if len(l) == 0:
			break
		lc = l.strip().split('\t')
		y.append(lc.pop())
		lc.pop(0)
		lc = [float(i) for i in lc]
		x.append(lc)
	f.close()

	pipeline = Pipeline([
		('clf', LogisticRegression())
	])

	parameters = {
		'clf__C': (0.1, 1, 10),
	}	

	X_train, X_test, y_train, y_test = train_test_split(x, y, train_size=0.5)
	
	grid_search = GridSearchCV(pipeline, parameters, n_jobs=3, verbose=1, scoring='accuracy')

	grid_search.fit(X_train, y_train)
	print 'Best score: %0.3f' % grid_search.best_score_
	print 'Best parameters set:'
	best_parameters = grid_search.best_estimator_.get_params()
	for param_name in sorted(parameters.keys()):
		print '\t%s: %r' % (param_name, best_parameters[param_name])
	
	predictions = grid_search.predict(X_test)
	print 'Accuracy:', accuracy_score(y_test, predictions)
	print 'Confusion Matrix:'
	print confusion_matrix(y_test, predictions)
	print 'Classification Report:'
	print classification_report(y_test, predictions)
