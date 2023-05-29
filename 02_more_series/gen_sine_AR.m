function s = gen_sine_AR(N, k)
% N: length of target ts
% k: to avoid bad values from the initial process, k values from the start is removed

s = zeros(N+k, 1);

noise = randn(N+k, 1);
s(1) = abs(randn(1)); % the initial value

% The model
a = 2;

for i = 2:N+k
    s(i) = a * sin(s(i-1)) + noise(i);
end

s = s(k+1:k+N); % Remove the first k values

end