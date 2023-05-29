clear
close all

series_length = 1000;
eta = 200;
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
step_AC = 1;
step_AMI = 1;


num_A = 150; % number of a and AC1
num_gap_sample = 150;
series_AR = NaN(num_A, series_length);
a_AR = linspace(0, 1, num_A);

series_AR = {};
for i = 1:num_A
    temp_matrix = NaN(num_gap_sample, series_length);
    for j = 1:num_gap_sample
        temp_matrix(j,:) = MkSg_AR(series_length, a_AR(i), eta);
    end
    series_AR{i} = temp_matrix;
    
end


AMI1_matrix = NaN(num_A, num_gap_sample);

tic
toc
totalt = 0;
current_k = 0;
for i = 1:num_A
    if mod(i, 50) == 0
        tic
        current_k = i;
    end
    temp_cell = series_AR{i};
    for j=1:num_gap_sample
        temp = temp_cell(j,:)';
        AMI1_matrix(i,j) = IN_AutoMutualInfo(temp, step_AMI, AMI_using_method);
    end
    % AMI1_matrix(i) = mi_cont_cont(temp(1:end-1), temp(2:end), 5);
    if mod(i, current_k + 50) == 0
        t2 = toc;
        totalt = totalt + t2;
        fprintf("i = %d, time uesd for this 1000i = %f\n", i, t2)
    end

    if i == num_A
        fprintf("i = %d, total time used = %f\n", i, totalt)
    end
    
end


n_bins = num_A;
mu = NaN(n_bins, 1);
sigma = NaN(n_bins, 1);
mu_CI = NaN(n_bins, 2);
sigma_CI = NaN(n_bins, 2);
for i = 1:n_bins
    bin = AMI1_matrix(i,:);
    [mu(i), sigma(i), mu_CI(i,:), sigma_CI(i,:)] = normfit(bin);
end

bincenters = a_AR;

% plot pdf
[AC1_grid,AMI1_grid] = meshgrid(bincenters,linspace(-0.5,3,300));
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