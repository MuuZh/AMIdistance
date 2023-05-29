close all
clear

num = 20; % number of each type of time series
N_length = 20000; % length of each generated series
k_length = 1000; % length of first k data points to be removed

tags = ['AR1', 'AR tent'];

series_matrix = NaN(40,N_length);



% first 20 are linear and last 20 are nonlinear
for i = 1:num
    series_matrix(i,:) = gen_linear_AR(N_length,k_length,0.95)';
    
    series_matrix(i+num,:) = gen_tent(N_length, k_length)';
%     series_matrix(i+num,:) = gen_sigmoid_AR(N_length, k_length)';
    % series_matrix(i+num,:) = gen_linear_AR(N_length,k_length, 0.72)';
end

% have a look of some examples
lAR = series_matrix(5,:);
nonlAR = series_matrix(25,:);
% plot(lAR);
% hold on
% plot(nonlAR)
% legend('AR1', 'AR sigmoid')

% figure
% ts = series_matrix(1,:);
% scatter(ts(1:end-1), ts(2:end), '.')
% xlim([-1,1])
% ylim([-1,1])
% title('AR(1)')
% 
% figure
% ts = series_matrix(21,:);
% c = [0.85 0.32 0.09];
% scatter(ts(1:end-1), ts(2:end), [], c, '.')
% xlim([-1,1])
% ylim([-1,1])
% title('AR sigmoid')

% figure
% plot_AC_region(series_matrix(1,:))
% hold on
plot_AC_region(series_matrix(21,:))

% % save to files
% fn = sprintf('data/long_linear_and_nonlinear_40_v2.txt');
% save(fn, 'series_matrix', '-ascii')

% fn = sprintf('data/Ar1-tent-v2.mat');
% fn = sprintf('data/Ar1-Ar1-v3.mat');
save(fn, 'series_matrix')

