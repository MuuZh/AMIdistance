function s = gen_sigmoid_AR(N,k)
    sig = @(x) -3/2 + 3./sqrt(1+exp(-x/0.3));

    s = zeros(N+k, 1);

    noise = randn(N+k, 1);
    s(1) = abs(randn(1)); % the initial value

    % The model
    a = 0.9;

    for i = 2:N+k
        s(i) = a*sig(s(i-1))+ 0.2*noise(i);
    end

    s = s(k+1:k+N); % Remove the first k values



end