import matplotlib.pyplot as plt
import numpy as np
from tqdm.auto import tqdm, trange
from tqdm.contrib import tenumerate
from statsmodels.tsa.arima_process import ArmaProcess
from statsmodels.tsa.stattools import acf
from statsmodels.tsa.stattools import pacf
import seaborn as sns
import pandas as pd
import time
import itertools
import scipy.io
import jpype


AMI1data = np.load('data/AMImatrix_400_100_2000.npz')
AMI1matrix = AMI1data['AMImatrix']
lag1para = AMI1data['lag1para']
a_num = np.size(lag1para,0)
series_length = AMI1data['series_length']
sample_size = AMI1data['sample_size']


AMIdict = {}
for i in range(AMI1matrix.shape[0]):
    AMIdict[lag1para[i]] = AMI1matrix[i, :]

    

AMI_prepands_list = []
for x, y_values in AMIdict.items():
    for y in y_values:
        AMI_prepands_list.append({'lag1para': x, 'AMI': y})

df = pd.DataFrame(AMI_prepands_list)

t0 = time.time()
plt.figure(figsize=(10, 10))
# sns.kdeplot(data=df, x='lag1para', y='AMI', cmap="viridis", shade=True)
sns.kdeplot(data=df, x='lag1para', y='AMI', cmap="viridis", fill=True)
plt.xlabel("lag1para")
plt.ylabel("AMI")
plt.title("Density Distribution of Points")
t1 = time.time()
plt.show()
print(f"time: {t1-t0:.4f}")
