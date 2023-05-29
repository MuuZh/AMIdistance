function noise = noise_term(series, noise_mag)
    noise = randn(size(series))*std(series)/noise_mag;