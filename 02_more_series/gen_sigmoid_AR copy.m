function s = gen_sigmoid_AR(N,k)
    sig = @(x) -x./sqrt(1+0.8*x.^2);

    s = zeros(N+k, 1);

    noise = randn(N+k, 1);
    s(1) = abs(randn(1)); % the initial value

    % The model
    a = 6;

    for i = 2:N+k
        s(i) = sig(a*s(i-1)) + 0.95*noise(i);
    end

    s = s(k+1:k+N); % Remove the first k values



end