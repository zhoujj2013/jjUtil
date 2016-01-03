#!/usr/bin/python

import os, sys
import re

import numpy as np
import pandas as pd
#from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model.logistic import LogisticRegression
from sklearn.cross_validation import train_test_split, cross_val_score
from sklearn.preprocessing import LabelBinarizer
from sklearn.metrics import roc_curve, auc

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

	X_train, X_test, y_train, y_test = train_test_split(x, y)
	
	classifier = LogisticRegression()
	classifier.fit(X_train, y_train)
	
	print 'Perform some prediction:'
	predictions = classifier.predict(X_test)
	for i, prediction in enumerate(predictions[:5]):
		print 'Prediction: %s. Value: %s.' % (prediction, X_test[i])

	print 'How well does our classifier perform?'
	from sklearn.metrics import confusion_matrix
	import matplotlib.pyplot as plt
	
	y_pred = predictions
	confusion_matrix = confusion_matrix(y_test, y_pred)
	print(confusion_matrix)

	plt.matshow(confusion_matrix)
	plt.title('Confusion matrix')
	plt.colorbar()
	plt.ylabel('True label')
	plt.xlabel('Predicted label')
	plt.show()
	
	from sklearn.metrics import accuracy_score
	print 'Accuracy:', accuracy_score(y_test, y_pred)

	scores = cross_val_score(classifier, X_train, y_train, cv=5)
	print '5 fold accuracy:', np.mean(scores), scores

	lb = LabelBinarizer()
	y_train = np.array([number[0] for number in lb.fit_transform(y_train)])
	precisions = cross_val_score(classifier, X_train, y_train, cv=5, scoring='precision')
	print 'Precision', np.mean(precisions), precisions

	recalls = cross_val_score(classifier, X_train, y_train, cv=5, scoring='recall')
	print 'Recalls', np.mean(recalls), recalls

	f1s = cross_val_score(classifier, X_train, y_train, cv=5, scoring='f1')
	print 'F1', np.mean(f1s), f1s
	
	predictions = classifier.predict_proba(X_test)
	y_test = np.array([int(i) for i in y_test])
	
	#for i in predictions:
	#	print i
	#print predictions[:, 1]
	
	false_positive_rate, recall, thresholds = roc_curve(y_test, predictions[:, 1])
	roc_auc = auc(false_positive_rate, recall)
	
	print 'false_positive_rate:', false_positive_rate
	print 'recall',recall
		
	plt.title('Receiver Operating Characteristic')
	plt.plot(false_positive_rate, recall, 'b', label='AUC = %0.2f' % roc_auc)
	plt.legend(loc='lower right')
	plt.plot([0, 1], [0, 1], 'r--')
	plt.xlim([0.0, 1.0])
	plt.ylim([0.0, 1.0])
	plt.ylabel('Recall')
	plt.xlabel('Fall-out')
	plt.show()
	
