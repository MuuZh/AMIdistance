close all
clear

num = 20; % number of each type of time series
N_length = 20000; % length of each generated series
k_length = 1000; % length of first k data points to be removed

tags = ['AR1', 'tent'];

series_matrix = NaN(40,N_length);

eta_ar = 0.2;
eta_tent = 0.025;

a = 0.85;
mu = 1.015;

% first 20 are linear and last 20 are nonlinear
for i = 1:num
    series_matrix(i,:) = gen_AR_p(N_length,k_length,a, eta_ar)';
    series_matrix(i+num,:) = gen_tent_p(N_length,k_length,mu, eta_tent)';
end

% have a look of some examples
lAR = series_matrix(5,:);
nonlAR = series_matrix(25,:);
plot(lAR);
hold on
plot(nonlAR)
legend('AR1', 'tent')

figure
plot_distribution(series_matrix(1,:))
hold on
plot_distribution(series_matrix(21,:))

% % save to files
% fn = sprintf('data/long_linear_and_nonlinear_40_v2.txt');
% save(fn, 'series_matrix', '-ascii')

% fn = sprintf('data/Ar1-tent-v2.mat');
fn = sprintf('data/testdata.mat');
save(fn, 'series_matrix')

