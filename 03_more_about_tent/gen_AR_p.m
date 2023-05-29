function s = gen_AR_p(N, k, a, eta)
% N: length of target ts
% k: to avoid bad values from the initial process, k values from the start is removed


s = zeros(N+k, 1);

noise = randn(N+k, 1);
s(1) = 0; % the initial value


% The model using here is x_{t+1} = a * x_t + noise
% where a is a coefficient
% a = 0.8;

for i = 2:N+k
    s(i) = a * s(i-1) + eta*noise(i);
end

s = s(k+1:k+N); % Remove the first k values

end