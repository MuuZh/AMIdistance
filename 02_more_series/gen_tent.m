function s = gen_tent(N,k)

    s = zeros(N+k, 1);

    noise = randn(N+k, 1);
    s(1) = abs(randn(1)); % the initial value

    % The model
    mu = 1;

    for i = 2:N+k

        next = NaN;
        if s(i)<0.5
            next = mu*s(i);
        elseif s(i) >= 0.5
            next = mu*(1-s(i));
        else
            sprintf("error")
        end
        s(i+1) = next + 0.5*noise(i);
    end

    s = s(k+1:k+N); % Remove the first k values



end