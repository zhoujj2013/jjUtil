#!/usr/bin/python

import os, sys
import re

import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_table(sys.argv[1], sep= '\t', header=None)

explanatory_variable_columns = set(df.columns.values)
response_variable_column = df[len(df.columns.values)-1]

X = df[1]
y = response_variable_column

plt.figure()
plt.title('Column 1 vs. Column 2')
plt.xlabel('Column 1')
plt.ylabel('Column 2')
plt.plot(X, y, 'k.')
plt.axis([0, max(X), 0, max(y)])
plt.grid(True)
plt.show()

