clear 
close all
a_num = 50;
sample_num = 20;
series_length = 2000;
eta = 200;

param1 = linspace(-1,1,a_num);
param2 = linspace(-1,1,a_num);


load('AMI2_29700.mat')
load('AC_29700.mat')
n_bins = 250;
AC2_matrix = abs(AC(:,3));
binnedAMI = AMI_in_bins(AC2_matrix,AMI2_matrix,n_bins);
mu = NaN(n_bins, 1);
sigma = NaN(n_bins, 1);
mu_CI = NaN(n_bins, 2);
sigma_CI = NaN(n_bins, 2);
for i = 1:n_bins
    bin = binnedAMI{i};
    [mu(i), sigma(i), mu_CI(i,:), sigma_CI(i,:)] = normfit(bin);
end
[N, binedges] = histcounts(AC2_matrix, n_bins);
bincenters = binedges(1:end-1) + diff(binedges)/2;

% figure
% binscatter(AC2_matrix, AMI2_matrix, [250 200])
% xlabel('AC2')
% ylabel('AMI2')
% title('bin scstter showing the distribution')

