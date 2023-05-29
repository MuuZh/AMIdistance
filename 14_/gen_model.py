from matplotlib import mlab
import matplotlib.pyplot as plt
import numpy as np
from tqdm.auto import tqdm, trange
from tqdm.contrib import tenumerate
from statsmodels.tsa.arima_process import ArmaProcess
from statsmodels.tsa.stattools import acf
from statsmodels.tsa.stattools import pacf
import time
import itertools
import scipy.io
import jpype
from AMI import automutual_info_single, automutual_info


a_num = 400
lag1para = np.linspace(0, 1, a_num)
series_length = 2000
ARpara = [np.r_[1, -arparams] for arparams in lag1para]
sample_size = 100
# For each parameter, generate 20 AR time series
# Use a 3d numpy array to store the results, with placeholder nan
AR1matrix = np.full((a_num, sample_size, series_length), np.nan)
for i, ar in enumerate(tqdm(ARpara)):
    AR1matrix[i] = [ArmaProcess(ar, [1]).generate_sample(series_length) for _ in range(sample_size)]


# print(automutual_info(AR1matrix[0], 1, 3))
# print(automutual_info(AR1matrix, 1, 3))
t0 = time.time()
AMImatrix = automutual_info(AR1matrix, 1, 3)
t1 = time.time()
print("time: ", t1-t0)

# save the results in a npy file with descriptive name of the parameters used
# use savez to save the parameters used
np.savez('data/AR1matrix_{}_{}_{}'.format(a_num, sample_size, series_length), lag1para=lag1para, series_length=series_length, sample_size=sample_size, AMImatrix=AMImatrix)
# np.save('data/AR1matrix_{}_{}_{}'.format(a_num, sample_size, series_length), AMImatrix)
