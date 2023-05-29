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
jarLocation = "C:/Users/BK/Documents/JIDT/v1.6/infodynamics.jar"



a_num = 100
lag1para = np.linspace(0, 1, a_num)
series_length = 2000
ARpara = [np.r_[1, -arparams] for arparams in lag1para]
sample_size = 50
# For each parameter, generate 20 AR time series
# Use a 3d numpy array to store the results, with placeholder nan
AR1matrix = np.full((a_num, sample_size, series_length), np.nan)
for i, ar in enumerate(tqdm(ARpara)):
    AR1matrix[i] = [ArmaProcess(ar, [1]).generate_sample(series_length) for _ in range(sample_size)]


timelag = 1
# use a 2d numpy array to store the results
AMIresult = np.full((a_num, sample_size), np.nan)

jpype.startJVM(jpype.getDefaultJVMPath(), "-ea", "-Djava.class.path=" + jarLocation)

teCalcClass = jpype.JPackage("infodynamics.measures.continuous.kraskov").MutualInfoCalculatorMultiVariateKraskov2
miCalc = teCalcClass()
miCalc.setProperty('k','3')
miCalc.initialise(1,1)
# print(teCalcClass)
# measure the total time for the loop
start_time = time.time()
for i in trange(a_num):
    for j,y in enumerate(AR1matrix[i]):
        miCalc.initialise(1,1)
        y1 = y[:-timelag]
        y2 = y[timelag:]
        miCalc.setObservations(y1,y2)
        ami = miCalc.computeAverageLocalOfObservations()
        AMIresult[i,j] = ami
    # print(np.corrcoef(y1,y2)[0,1])

jpype.shutdownJVM()
used_time = time.time() - start_time
print("--- %s seconds ---" % (used_time))
plt.figure()
# plt.scatter(lag1para, AMIresult)
# scatter the results with smaller markers, and opacity 0.5
for i in range(a_num):
    plt.scatter(lag1para[i]*np.ones(sample_size), AMIresult[i], s=1, alpha=0.5, c='k')

# save the results to a numpy file, in folder benchmarkdata
np.save('benchmarkdata/p2_benchmark_original_win.npy', AMIresult)
# save the image to a png file, with time uesd in the file name, in folder benchmarkdata
plt.savefig('benchmarkdata/p2_benchmark_original_win_{}.png'.format(used_time))
plt.show()
