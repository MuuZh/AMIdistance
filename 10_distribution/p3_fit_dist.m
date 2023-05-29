clear
close all

series_length = 200;
eta = 200;
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
step_AC = 1;
step_AMI = 1;


num_A = 100000;
series_AR = NaN(num_A, series_length);
a_AR = linspace(0, 1, num_A);

load("computed100k")

n_bins = 250;
binedAMI = AMI_in_bins(AC1_matrix_abs, AMI1_matrix, n_bins);

% for i = 1:n_bins
%     bin = binedAMI{i};
%     x = (bin - mean(bin))/std(bin);
%     [h,p] = kstest(x);
%     if h == 1
%         fprintf("Bin %d is not normal\n", i)
%     end
% end

% fit normal distribution to each bin
mu = NaN(n_bins, 1);
sigma = NaN(n_bins, 1);
mu_CI = NaN(n_bins, 2);
sigma_CI = NaN(n_bins, 2);
for i = 1:n_bins
    bin = binedAMI{i};
    [mu(i), sigma(i), mu_CI(i,:), sigma_CI(i,:)] = normfit(bin);
end

[N, binedges] = histcounts(AC1_matrix_abs, n_bins);
bincenters = binedges(1:end-1) + diff(binedges)/2;

% plot pdf
[AC1_grid,AMI1_grid] = meshgrid(bincenters,linspace(-0.5,2.5,500));
P_grid = NaN(size(AC1_grid));
for i = 1:size(AC1_grid,1)
    for j = 1:size(AC1_grid,2)
        P_grid(i,j) = normpdf(AMI1_grid(i,j), mu(j), sigma(j));
    end
end

figure('Position', [100, 100, 1200, 900])
surfl(AC1_grid, AMI1_grid, P_grid)
xlabel('|AC1|')
ylabel('AMI1')
title('Probability density function of AMI1 given |AC1|')

colormap(pink)    % change color map
shading interp

% plot the CI
% compute a curve for uppere and lower CI
CI_curve = NaN(2, size(AC1_grid,2));
for i = 1:size(AC1_grid,2)
    CI_curve(1,i) = norminv(0.025, mu(i), sigma(i));
    CI_curve(2,i) = norminv(0.975, mu(i), sigma(i));
end
% compute the hight of the CI
CI_hight = NaN(2, size(AC1_grid,2));
for i = 1:size(AC1_grid,2)
    CI_hight(1,i) = normpdf(CI_curve(1,i), mu(i), sigma(i));
    CI_hight(2,i) = normpdf(CI_curve(2,i), mu(i), sigma(i));
end
hold on
plot3(AC1_grid(1,:), CI_curve(1,:), CI_hight(1,:), 'k', 'LineWidth', 2)
plot3(AC1_grid(1,:), CI_curve(2,:), CI_hight(2,:), 'k', 'LineWidth', 2)
hold off

legend('PDF', '95% CI')