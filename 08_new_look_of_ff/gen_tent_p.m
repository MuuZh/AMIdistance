function s = gen_tent_p(N,k,mu,init,eta)

    s = zeros(N+k, 1);

    noise = randn(N+k, 1);
    s(1) = init; % the initial value

    for i = 2:N+k
        temp = mu*min([s(i-1)+eta*noise(i),1-s(i-1)+eta*noise(i)]);
        s(i) = mod(temp, 1);
    end

    s = s(k+1:k+N); % Remove the first k values



end