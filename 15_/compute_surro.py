import surro 

import numpy as np
import datasets as datasets
from tqdm import tqdm
from matplotlib import pyplot as plt

x_start = 0.1
series_length = 2200
tent_a_num = 400
tent_logistic_num = 400

param_range_tent = np.linspace(1.001, 1.999, tent_a_num)
param_range_logistic = np.linspace(3.57, 4, tent_logistic_num)

tent_full_data = np.array([
    np.fromiter(datasets.tent_map(x_start, series_length, mu), dtype="float32")
    for mu in param_range_tent
])
logistic_full_data = np.array([
    np.fromiter(datasets.logistic_map(x_start, series_length, r), dtype="float32")
    for r in param_range_logistic
])

# take the last 2000 points of each series the series as the actual data
tent_full_data = tent_full_data[:, 200:]
logistic_full_data = logistic_full_data[:, 200:]

tentLambdas = np.log(param_range_tent, where=param_range_tent > 0)
tentLambdas[np.where(param_range_tent <= 0)] = np.nan
tentChaoticIdx = np.where(tentLambdas > 0)

logisticLambdas =np.array([
      np.mean(np.log(abs(r - 2 * r * x[np.where(x != 0.5)])))
      for x, r in zip(logistic_full_data, param_range_logistic)
    ])
logisticChaoticIdx = np.where(logisticLambdas > 0)

tentParamRangeChaotic = param_range_tent[tentChaoticIdx]

logisticParamRangeChaotic = param_range_logistic[logisticChaoticIdx]



tentSurrogates = np.array([surro.SS_iter_surro(series) for series in tqdm(tent_full_data)])
logisticSurrogates = np.array([surro.SS_iter_surro(series) for series in tqdm(logistic_full_data)])
plt.plot(tentSurrogates)
plt.show()
plt.plot(logisticSurrogates)
plt.show()


