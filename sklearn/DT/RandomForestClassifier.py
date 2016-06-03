#!/usr/bin/python

import os, sys
import re

import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import train_test_split
from sklearn.metrics import classification_report
from sklearn.pipeline import Pipeline
from sklearn.grid_search import GridSearchCV
import matplotlib.pyplot as plt 

def usage():
	print '\n\tThis is the usage function'
	print '\tAuthor: zhoujj2013@gmail.com'
	print '\tUsage: '+sys.argv[0]+' <file1> '
	print '\tExample: python ' + sys.argv[0] + ''
	print '\n'
	sys.exit(2)

if __name__ == "__main__":
	if len(sys.argv) < 2:
		usage()
	
	''' start coding here'''
	prefix=sys.argv[2]
	df = pd.read_table(sys.argv[1], sep='\t', header=None)
	# data
	explanatory_variable_columns = set(df.columns.values)
	
	# response value
	response_variable_column = df[len(df.columns.values)-1]

	# remove id column and result column
	explanatory_variable_columns.remove(0)
	explanatory_variable_columns.remove(len(df.columns.values)-1)
	
	#print response_variable_column
	
	# prepare y, X
	y = [1 if e == '1' or e == 1 else 0 for e in response_variable_column]
	X = df[list(explanatory_variable_columns)]

	X.replace(to_replace='NA', value=-1, regex=True, inplace=True)
	
	# split dataset
	X_train, X_test, y_train, y_test = train_test_split(X, y, train_size=0.50)
	
	# design the pipeline
	pipeline = Pipeline([
		('clf', RandomForestClassifier(criterion='entropy'))
	])

	parameters = {
		#'clf__n_estimators': (5, 10, 20, 50),
		#'clf__max_depth': (150, 155, 160),
		#'clf__min_samples_split': (1, 2, 3),
		#'clf__min_samples_leaf': (1, 2, 3)
	}
	
	# GridSearch
	grid_search = GridSearchCV(pipeline, parameters, n_jobs=-1, verbose=1, scoring='f1')
	grid_search.fit(X_train, y_train)
	
	from sklearn.externals import joblib
	if not os.path.exists("./TFmodel"):
		os.makedirs("./TFmodel")
	joblib.dump(grid_search, './TFmodel/histMD.pkl')
	
	print 'Best score: %0.3f' % grid_search.best_score_
	print 'Best parameters set:'
	
	best_parameters = grid_search.best_estimator_.get_params()
	for param_name in sorted(parameters.keys()):
		print '\t%s: %r' % (param_name, best_parameters[param_name])
	
	predictions = grid_search.predict(X_test)
	print classification_report(y_test, predictions)
	
	# predict probability
	predictions = grid_search.predict_proba(X_test)
	from sklearn.metrics import roc_curve, auc
	y_test = np.array([int(i) for i in y_test])
	false_positive_rate, recall, thresholds = roc_curve(y_test, predictions[:, 1])
	roc_auc = auc(false_positive_rate, recall)
		
	out = open("./" + prefix + ".fpr_tpr.lst", 'wb')
	for i in range(len(false_positive_rate)):
		print >>out, str(false_positive_rate[i]) + "\t" + str(recall[i])
	out.close()
		
	# create ROC curve
	plt.figure(figsize=(10,10))	
	plt.title('Receiver Operating Characteristic')
	plt.plot(false_positive_rate, recall, 'b', label='AUC = %0.2f' % roc_auc)
	plt.legend(loc='lower right')
	plt.plot([0, 1], [0, 1], 'r--')
	plt.xlim([-0.01, 1.01])
	plt.ylim([-0.01, 1.01])
	plt.ylabel('Recall')
	plt.xlabel('False positive rate')
	plt.savefig(prefix + ".ROC.pdf", format='pdf')
