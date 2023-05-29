#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 26 00:01:11 2023

@author: muuzh
"""
#%% 1 import
import spyder_kernels
from AMI import automutual_info_single, automutual_info, automutual_info_k1
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
import scipy.stats as stats
import jpype
import measures as nolds
import datasets as datasets
from helper_functions import *
  
#%% 1
x_start = 0.1
series_length = 2200
logistic_num = tent_a_num = 10

param_range_tent = np.linspace(1.001, 1.999, tent_a_num)
param_range_logistic = np.linspace(3.57, 4, logistic_num)

tent_full_data = np.array([
    np.fromiter(datasets.tent_map(x_start, series_length, mu), dtype="float32")
    for mu in param_range_tent
])
logistic_full_data = np.array([
    np.fromiter(datasets.logistic_map(x_start, series_length, r), dtype="float32")
    for r in param_range_logistic
])


# delete the first 200 points for each series
tent_full_data = tent_full_data[:, 200:]
logistic_full_data = logistic_full_data[:, 200:]

tentLambdas = np.log(param_range_tent, where=param_range_tent > 0)
logisticLambdas =np.array([
      np.mean(np.log(abs(r - 2 * r * x[np.where(x != 0.5)])))
      for x, r in zip(logistic_full_data, param_range_logistic)
    ])

#%% 2 compute AMI
logisticAMI1 = automutual_info(logistic_full_data, 1, 3)
#%% 6 compute AC
logisticAC1 = np.array([
    acf(series, nlags=1)[1]
    for series in logistic_full_data
])
logisticAC1 = np.abs(logisticAC1)
#%% compute AMI per AC
logisticAMI1_AR1 = AMI_for_AR1_all_at_once(logisticAC1, sample_size=100)
#%% compute AMI distance
logistic_AMI_distance = (np.array(logisticAMI1) - np.array((logisticAMI1_AR1.mean(axis=1))))/np.array((logisticAMI1_AR1.std(axis=1)))
#%% plot AMI
plt.figure(figsize=(10, 6))
plt.scatter(logisticLambdas, logistic_AMI_distance, marker='.',alpha=0.5)
plt.xlabel("ground true LE")
plt.ylabel("logistic AMI distance")
plt.show()



