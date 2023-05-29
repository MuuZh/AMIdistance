import numpy as np
import datasets as datasets
import measures as nolds
from AMI import automutual_info_single, automutual_info, automutual_info_k1
from statsmodels.tsa.arima_process import ArmaProcess
from statsmodels.tsa.stattools import acf

def poincare_plot(data, stride=1):
    """
    Create a Poincare plot from a time series.

    Parameters
    ----------
    data : array_like
        The time series data.
    stride : int, optional
        The stride between consecutive points in the time series. Default is 1.

    Returns
    -------
    tuple
        A tuple containing the x and y coordinates of the Poincare plot.
    """
    x = data[:-stride]
    y = data[stride:]
    return x, y
def plot_lyap(maptype):
  # local import to avoid dependency for non-debug use
  import matplotlib.pyplot as plt

  x_start = 0.1
  n = 140
  nbifur = 40
  if maptype == "logistic":
    param_name = "r"
    param_range = np.arange(2, 4, 0.01)
    full_data = np.array([
      np.fromiter(datasets.logistic_map(x_start, n, r), dtype="float32")
      for r in param_range
    ])

    lambdas = [
      np.mean(np.log(abs(r - 2 * r * x[np.where(x != 0.5)])))
      for x, r in zip(full_data, param_range)
    ]
  elif maptype == "tent":
    param_name = "$\\mu$"
    param_range = np.arange(0, 2, 0.01)
    full_data = np.array([
      np.fromiter(datasets.tent_map(x_start, n, mu), dtype="float32")
      for mu in param_range
    ])

    lambdas = np.log(param_range, where=param_range > 0)
    lambdas[np.where(param_range <= 0)] = np.nan
  else:
    # raise Error("maptype %s not recognized" % maptype)
    pass

  kwargs_e = {"emb_dim": 6, "matrix_dim": 2}
  kwargs_r = {"emb_dim": 6, "lag": 2, "min_tsep": 20, "trajectory_len": 20}
  # algorithm of Eckmann
  lambdas_e = [max(nolds.lyap_e(d, **kwargs_e)) for d in full_data]
  # ################
  # 
  # algorithm of Rosenstein
  lambdas_r = [nolds.lyap_r(d, **kwargs_r) for d in full_data]
  # ################
  bifur_x = np.repeat(param_range, nbifur)
  bifur = np.reshape(full_data[:, -nbifur:], nbifur * param_range.shape[0])

  plt.figure(figsize=(10, 6))
  plt.title("Lyapunov exponent of %s map" % maptype)
  plt.plot(param_range, lambdas, "b-", label="theoretical LE")
  elab = "Eckmann method"
  rlab = "largest LE, Rosenstein method"
  plt.plot(param_range, lambdas_e, color="#00AAAA", label=elab)
  plt.plot(param_range, lambdas_r, color="#AA00AA", label=rlab)
  plt.plot(param_range, np.zeros(len(param_range)), "g--")
  plt.plot(bifur_x, bifur, "ro", alpha=0.1, label="bifurcation plot")
  plt.ylim((-2, 2))
  plt.xlabel(param_name)
  plt.ylabel("LE")
  plt.legend(loc="best")
  plt.show()

  def AMI_for_AR1(AC1, sample_size=100):
    # genenerate AR(1) series with AC1, with sample_size points
    lag1para = AC1
    series_length = 2000
    ARpara = np.r_[1, -lag1para]
    AR1matrix = np.array([ArmaProcess(ARpara, [1]).generate_sample(series_length) for _ in trange(sample_size)])
    AR1AMI1 = automutual_info(AR1matrix, 1, 3)
    return AR1AMI1
def AMI_for_AR1_all_at_once(AC1s, sample_size=100, series_length=2000):
    # genenerate AR(1) series with AC1, with sample_size points
    # lag1para = AC1s
    ARpara = [np.r_[1, -arparams] for arparams in AC1s]
    AR1matrix = np.full((len(AC1s), sample_size, series_length), np.nan)
    for i, ar in enumerate(ARpara):
        AR1matrix[i] = [ArmaProcess(ar, [1]).generate_sample(series_length) for _ in range(sample_size)]
    AR1AMI1 = automutual_info(AR1matrix, 1, 3)
    return AR1AMI1