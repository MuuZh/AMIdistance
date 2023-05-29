close all
clear

num = 20; % number of each type of time series
N_length = 20000; % length of each generated series
k_length = 1000; % length of first k data points to be removed

tags = ['AR1', 'AR tent'];

series_matrix = NaN(40,N_length);



% first 20 are linear and last 20 are nonlinear
for i = 1:num
    series_matrix(i,:) = gen_linear_AR(N_length,k_length,0.9178)';
    series_matrix(i+num,:) = gen_tent_2(N_length, k_length, 1.028)';

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
fn = sprintf('data/tent_mu122.mat');
save(fn, 'series_matrix')

