function surrogate = gen_surrogates(surrogate)
    spectrum = ifft(surrogate);% surrogate is the surrogate time series.
    phase    = angle(spectrum);              % Angle is the Matlab function to calculate the phase from a complex number.
    spectrum = fourierCoeff .* exp(i*phase); % fourierCoeff are the magnitudes of the Fourier coefficients of the template.
    surrogate = fft(spectrum);
    [dummy, index]   = sort(surrogate);  % We need only the indices. The first value of index points to the highest value, etc.
    surrogate(index) = sortedValues;     % sortedValues is the vector with the sorted values from the template.
end