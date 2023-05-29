import numpy as np
import matplotlib.pyplot as plt
from tqdm import tqdm
from teaspoon.parameter_selection.MI_delay import MI_kraskov
from teaspoon.parameter_selection.MI_delay import MI_DV

def MkSg_AR(rho):
  steps = 2000

  e = np.random.randn(steps)
  y = [0]

  # Possible to get rid of this loop?
  for i in range(len(e)):
      y.append(rho*y[i] + e[i])
  return np.array(y)

def AC1(series):
    return np.corrcoef(series[0:-1], series[1:])[0][1]

a = np.linspace(0,1,200)
ARmatrix = np.array([])
for i in tqdm(range(a.size)):
  zzz = MkSg_AR(a[i])
  if ARmatrix.size == 0:
    ARmatrix = zzz
  else:
    ARmatrix = np.vstack((ARmatrix, zzz))

AC1matrix = []
for seriesidx in tqdm(range(ARmatrix.shape[0])):
  AC1matrix.append(AC1(ARmatrix[seriesidx]))

# plt.plot(AC1matrix)
# plt.show()
# print(ARmatrix.shape)


AMI1matrix = []
for seriesidx in tqdm(range(ARmatrix.shape[0])):
  series = ARmatrix[seriesidx]
  MI = MI_kraskov(series[0:-1], series[1:])
  AMI1matrix.append(MI[0])
plt.plot(AMI1matrix)
plt.show()

