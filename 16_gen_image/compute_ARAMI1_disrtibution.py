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
import datasets as datasets
import matplotlib.gridspec as gridspec
import measures as nolds
import scipy.io
from helper_functions import *

num_of_AC1 = 1000
sample_for_eash = 100
AC1s = np.linspace(0, 1, num_of_AC1)
results = AMI_for_AR1_all_at_once(AC1s, sample_size=sample_for_eash)
# np.savez('numAC1_{}_sample_{}.npz'.format(num_of_AC1, sample_for_eash), AC1s = AC1s, AMIs = results)