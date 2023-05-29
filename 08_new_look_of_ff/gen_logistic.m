function s = gen_logistic(N, k, A, init_v,eta)
    % N: length of target ts
    % k: to avoid bad values from the initial process, k values from the start is removed
    % A: the parameter
    % init_v: initial value
    % eta: noise level
    
    
    s = zeros(N+k, 1);
    
    noise = randn(N+k, 1);
    s(1) = init_v; % the initial value
    
    
    
    for i = 2:N+k
        last = s(i-1) + eta * noise(i);
        last = max(last,0);
        last = min(last,1);

        % s(i) = A*s(i-1)*(1-s(i-1))+ eta * noise(i);
        s(i) = A*last*(1-last);
    end
    
    s = s(k+1:k+N); % Remove the first k values
    
    end