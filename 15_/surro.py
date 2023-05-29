import numpy as np
def SS_iter_surro(X, max_it=5000):
    N = len(X)

    r = np.random.permutation(X)

    c = np.sort(X)

    f_amp = np.abs(np.fft.fft(X))

    for i in range(max_it):
        R = np.fft.fft(r)
        phases = np.angle(R)
        s = np.real(np.fft.ifft(f_amp * np.exp(1j * phases)))

        k = np.argsort(s)
        r[k] = c

        if np.mean(np.abs(R - f_amp)) < 0.1 * np.max(X):
            print('ended early')
            break

    sur = s
    return sur