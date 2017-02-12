#!/usr/bin/python

import os, sys
import re

import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import train_test_split
from sklearn.metrics import classification_report
#from sklearn.pipeline import Pipeline
#from sklearn.grid_search import GridSearchCV
#import matplotlib.pyplot as plt 

def usage():
	print '\n\tClassify cancer type base on model builded by random forest algorithm.'
	print '\tAuthor: zhoujj2013@gmail.com 6/3/2016'
	print '\tUsage: '+sys.argv[0]+' <ssm.his.cor> <pkl model> <prefix>'
	print '\n'
	sys.exit(2)

if __name__ == "__main__":
	if len(sys.argv) < 2:
		usage()
	
	''' start coding here'''
	pkl=sys.argv[2]
	prefix=sys.argv[3]
	df = pd.read_table(sys.argv[1], sep='\t', header=None)
	# data
	explanatory_variable_columns = set(df.columns.values)
	
	# response value
	response_variable_column = df[len(df.columns.values)-1]

	# remove id column
	explanatory_variable_columns.remove(0)
	
	#print response_variable_column
	
	# prepare y, X
	X = df[list(explanatory_variable_columns)]

	X.replace(to_replace='NA', value=-1, regex=True, inplace=True)
		
	from sklearn.externals import joblib
	rf = joblib.load(pkl)
	
	print "Prediction result:"
	print rf.predict(X)
	
	#print "Test real:"
	#print y_test
	#print "Test predict:"
	#print rf.predict(X_test)
	#
	#print "Mean accuracy train data: " + str(rf.score(X_train, y_train))
	#print "Mean accuracy test data: " + str(rf.score(X_test, y_test))
	
'''
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
'''

