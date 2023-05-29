function s = gen_tent(N,k,mu)

    s = zeros(N+k, 1);

    noise = randn(N+k, 1);
    s(1) = abs(randn(1)); % the initial value

    % The model
    % mu = 1;

    for i = 2:N+k
        next = NaN;
        if s(i)<0.5
            next = max(0, mu*s(i));
        elseif s(i) >= 0.5
            next = min(1,mu*(1-s(i)));
        else
            sprintf("error")
        end
        s(i+1) = next + 0.1*noise(i);
    end

    s = s(k+1:k+N); % Remove the first k values



end