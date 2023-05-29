import numpy as np
from typing import Tuple
from scipy.special import digamma
from sklearn.neighbors import KDTree

class MutualInfoCalculatorMultiVariateKraskov2:

    def __init__(self, k: int = 4, dyn_corr_excl_time: int = 1):
        self.k = k
        self.dyn_corr_excl_time = dyn_corr_excl_time
        self.total_observations = 0
        self.kd_tree_joint = None
        self.nn_searcher_source = None
        self.nn_searcher_dest = None

    def _setup(self, var1_observations: np.ndarray, var2_observations: np.ndarray):
        self.total_observations = len(var1_observations)
        self.kd_tree_joint = KDTree(np.hstack((var1_observations, var2_observations)))
        self.nn_searcher_source = KDTree(var1_observations)
        self.nn_searcher_dest = KDTree(var2_observations)

    def estimate_mutual_info(self, var1_observations: np.ndarray, var2_observations: np.ndarray) -> float:
        self._setup(var1_observations, var2_observations)
        digamma_k = digamma(self.k)
        digamma_n = digamma(self.total_observations)
        inv_k = 1.0 / self.k

        sum_digammas = 0
        sum_nx = 0
        sum_ny = 0

        for t in range(self.total_observations):
            dists, idxs = self.kd_tree_joint.query([np.hstack((var1_observations[t], var2_observations[t]))], k=self.k+1)
            dists, idxs = dists[0], idxs[0]
            
            eps_x = np.max(dists[:, :1])
            eps_y = np.max(dists[:, 1:])

            n_x = self.nn_searcher_source.query_radius([var1_observations[t]], r=eps_x, count_only=True)[0] - 1
            n_y = self.nn_searcher_dest.query_radius([var2_observations[t]], r=eps_y, count_only=True)[0] - 1

            sum_nx += n_x
            sum_ny += n_y

            digamma_nx = digamma(n_x)
            digamma_ny = digamma(n_y)
            sum_digammas += digamma_nx + digamma_ny

        mi = digamma_k - inv_k - (sum_nx + sum_ny) / self.total_observations + digamma_n
        return mi

