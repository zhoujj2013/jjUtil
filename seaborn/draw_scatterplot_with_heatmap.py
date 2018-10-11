import numpy as np
import pandas as pd
from scipy import stats, integrate
import matplotlib.pyplot as plt
import seaborn as sns
sns.set(color_codes=True)
import sys,os

# format
#name    wt      ko
#aa      23      56
#bb      45      89
 
dat = pd.read_table(sys.argv[1], sep="\t")

dat.wt = np.log10(dat.wt + 1)
dat.ko = np.log10(dat.ko + 1)

plt.subplots(figsize=(6, 6))
#plt.ylim(0,dat.ko.max())
#plt.xlim(0,dat.wt.max())

# the color system
# https://www.rapidtables.com/convert/color/index.html
# 
cmap = sns.diverging_palette(240, 0, sep=20, as_cmap=True)
#cmap = sns.dark_palette("purple",as_cmap=True )
#cmap = sns.cubehelix_palette(as_cmap=True, dark=0, light=1, reverse=False)
sns.kdeplot(dat.wt, dat.ko, cmap=cmap, n_levels=60, shade=True);
plt.savefig(sys.argv[2] + ".pdf")

