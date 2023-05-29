function s = gen_sigmoid_p(N,k,theta,eta)
    sig = @(x)  1./sqrt(1+exp(-x/theta));

    s = zeros(N+k, 1);

    noise = randn(N+k, 1);
    s(1) = abs(randn(1)); % the initial value

    % The model

    for i = 2:N+k
        s(i) = theta*sig(s(i-1))+ eta*noise(i);
    end

    s = s(k+1:k+N); % Remove the first k values



end