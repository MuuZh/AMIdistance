close all
clear

num = 20; % number of each type of time series
N_length = 20000; % length of each generated series
k_length = 1000; % length of first k data points to be removed

series_matrix = NaN(40,N_length);

eta_ar = 0.2;
% eta_tent = 0.03;

a = 0.78;
% mu = 1.01;

% first 20 are linear and last 20 are nonlinear
for i = 1:num
    series_matrix(i,:) = gen_tent_p(N_length,k_length,mu, eta_tent)';
    series_matrix(i+num,:) = generate_surrogate_iaaft(series_matrix(i,:));
    % series_matrix(i+num,:) = SS_iter_surro(series_matrix(i,:),10);
end

% have a look of some examples
lAR = series_matrix(5,:);
nonlAR = series_matrix(25,:);
plot(zscore(lAR));
hold on
plot(zscore(nonlAR))
legend('tent', 'surrotage tent')

figure
plot_distribution_zscore(lAR)
hold on
plot_distribution_zscore(nonlAR)
legend('tent', 'surrotage tent')

% % save to files
% fn = sprintf('data/long_linear_and_nonlinear_40_v2.txt');
% save(fn, 'series_matrix', '-ascii')

% fn = sprintf('data/Ar1-tent-v2.mat');
fn = sprintf('data/surr_nonoisetent.mat');
save(fn, 'series_matrix')

