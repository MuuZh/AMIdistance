%implements the iterative surrogate routine from Schreiber and Schmitz, 2000
% returns the exact signal distribution result, but very similar power spectrum too.
function sur = SS_iter_surro(X, max_it)

    if nargin<2
        max_it = 5000;
    end 

    N = length(X);

    r = X(randperm(N));

    c = sort(X);

    f_amp = abs(fft(X));

    for i = 1:max_it
        R = fft(r);
        phases = angle(R);
        s = real(ifft(f_amp .* exp(1i.*phases) ));

        [~,k] = sort(s);
        r(k) = c;

        if mean(abs(R - f_amp)) < 0.1*max(X)
            fprintf('ended early')
            break
        end

    end

    sur = s; % r or s (dist or spec).

end 
