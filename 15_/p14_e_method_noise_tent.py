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

#%% 2 grnerate basic logistic data 

x_start = 0.1
series_length = 1200
logistic_num = tent_a_num = 100

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



#%% 3 adding noise

tentLambdas = np.log(param_range_tent, where=param_range_tent > 0)
logisticLambdas =np.array([
      np.mean(np.log(abs(r - 2 * r * x[np.where(x != 0.5)])))
      for x, r in zip(logistic_full_data, param_range_logistic)
    ])
# set length of series
snr = [70, 60, 50, 45, 40, 35 ,30, 25 ,20, 10]
lambda_e_noise_result = []
runningTime = []


def add_noise_with_snr(signal, snr):
    """
    Adds measurement noise to the input signal based on the given Signal-to-Noise Ratio (SNR).

    :param signal: Input time series signal (1D NumPy array)
    :param snr: Desired Signal-to-Noise Ratio in dB (positive float)
    :return: Noisy signal (1D NumPy array)
    """
    # Convert SNR from dB to linear scale
    snr_linear = 10**(snr / 10)
    
    # Calculate signal power
    signal_power = np.mean(signal**2)
    
    # Calculate noise power based on the desired SNR
    noise_power = signal_power / snr_linear
    
    # Generate noise with the calculated noise power
    noise = np.random.normal(0, np.sqrt(noise_power), signal.shape)
    
    # Add noise to the signal
    noisy_signal = signal + noise
    
    return noisy_signal


#%% compute for each SNR
for i, s in tenumerate(snr):
    print('{}/{}  now processing SNR: {}'.format(i+1, len(snr), s))
    noisy_time_series_array = np.zeros_like(tent_full_data)

# Iterate over each time series and add noise
    for ii in range(tent_full_data.shape[0]):
        noisy_time_series_array[ii] = add_noise_with_snr(tent_full_data[ii], s)


    t0 = time.time()
    kwargs_e = {"emb_dim": 6, "matrix_dim": 2}
    lambdas_e = [max(nolds.lyap_e(d, **kwargs_e)) for d in tqdm(noisy_time_series_array)]
    t1 = time.time()
    runningTime.append(t1-t0)
    
    lambda_e_noise_result.append(np.array(lambdas_e))

#%% plot the result 
# Create a mask with True values for nan and inf
mask = np.isnan(lambda_e_noise_result) | np.isinf(lambda_e_noise_result)
lambda_e_noise_result = np.array(lambda_e_noise_result)
# Replace nan and inf values with zeros
lambda_e_noise_result[mask] = 0
tent_correlation = np.array([
    np.corrcoef(tentLambdas, lambda_e_noise_result[i])[0, 1]
    for i in range(len(snr))
    ])
pickedidx = [0, len(snr)-1]
plt.figure(figsize=(20, 5))
plt.subplots_adjust(left=0.1, right=0.9, bottom=0.1, top=0.9, wspace=0.3, hspace=0.3)
for idx, i in enumerate(pickedidx):
    l = snr[i]
    plt.subplot(1, len(pickedidx), idx+1)
    plt.scatter(tentLambdas, lambda_e_noise_result[i], marker='.',alpha=0.5)
    plt.xlabel("ground true LE")
    plt.ylabel("tent AMI distance")
    plt.title("Eckmann, SNR = {}, correlation = {:.3f}".format(l, tent_correlation[i]))
plt.show()

#%% plot all
pickedidx = range(len(snr))
plt.figure(figsize=(20, 20))
plt.subplots_adjust(left=0.1, right=0.9, bottom=0.1, top=0.9, wspace=0.3, hspace=0.3)
for idx, i in enumerate(pickedidx):
    l = snr[i]
    plt.subplot(4,3, idx+1)
    plt.scatter(tentLambdas, lambda_e_noise_result[i], marker='.',alpha=0.5)
    plt.xlabel("ground true LE")
    plt.ylabel("tent AMI distance")
    plt.title("Eckmann, SNR = {}, correlation = {:.3f}".format(l, tent_correlation[i]))
plt.show()

#%% plot the correlation and time
plt.figure()
plt.plot(snr, tent_correlation, label="correlation")
plt.xlabel("SNR")
plt.ylabel("correlation")
plt.title("Eckmann's method for tent map")
plt.show()

plt.figure()
plt.plot(snr, runningTime, label="time")
plt.xlabel("SNR")
plt.ylabel("time (s)")
plt.title("Eckmann's method for tent map")
plt.show()