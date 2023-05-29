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



a_num = 500
lag1para = np.linspace(0, 1, a_num)
series_length = 2000
ARpara = [np.r_[1, -arparams] for arparams in lag1para]
AR1matrix = [ArmaProcess(ar, [1]).generate_sample(series_length) for ar in tqdm(ARpara)]


jpype.startJVM(jpype.getDefaultJVMPath(), "-ea", "-Djava.class.path=" + jarLocation)

teCalcClass = jpype.JPackage("infodynamics.measures.continuous.kraskov").MutualInfoCalculatorMultiVariateKraskov2
miCalc = teCalcClass()
miCalc.setProperty('k','3')
miCalc.initialise(1,1)
# print(teCalcClass)

timelag = 1
AMIresult = np.zeros(a_num)
for i,y in tenumerate(AR1matrix):
    miCalc.initialise(1,1)
    y1 = y[:-timelag]
    y2 = y[timelag:]
    miCalc.setObservations(y1,y2)
    ami = miCalc.computeAverageLocalOfObservations()
    AMIresult[i] = ami
    # print(np.corrcoef(y1,y2)[0,1])

jpype.shutdownJVM() 
plt.figure()
plt.plot(lag1para, AMIresult)
plt.show()
