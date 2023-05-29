aclear
close all

series_length = 1000;
eta = 200;
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
step_AC = 1;
step_AMI = 1;


num_A = 150; % number of a and AC1
num_gap_sample = 150;
a_AR = linspace(0, 1, num_A);

load("p4_result")


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
[AC1_grid,AMI1_grid] = meshgrid(bincenters,linspace(-0.5,3,500));
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
% compute the height of the CI
CI_hight = NaN(2, size(AC1_grid,2));
for i = 1:size(AC1_grid,2)
    CI_hight(1,i) = normpdf(CI_curve(1,i), mu(i), sigma(i));
    CI_hight(2,i) = normpdf(CI_curve(2,i), mu(i), sigma(i));
end
hold on
plot3(AC1_grid(1,:), CI_curve(1,:), CI_hight(1,:),  'LineWidth', 2)
plot3(AC1_grid(1,:), CI_curve(2,:), CI_hight(2,:),  'LineWidth', 2)
hold off


[AC1_matrix_abs, AMI1_matrix] = p4_get_features(series_length);

% compute height for each AMI1 in each bin
map_AMI = {};
for map_idx = 1:size(AC1_matrix_abs,1)
    temp_AMI1 = AMI1_matrix(map_idx,:);
    temp_AC1 = AC1_matrix_abs(map_idx,:);
    tempAC1_coor = [];
    tempAMI1_coor = [];
    tempAMI1_height_coor = [];
    for pos_idx = 1:size(temp_AMI1,2)
        tempAC1_coor = [tempAC1_coor ,temp_AC1(pos_idx)];
        tempAMI1_coor = [tempAMI1_coor, temp_AMI1(pos_idx)];
        % find nearest AC1 that we already have
        [AC1val, AC1idx] = min(abs(a_AR-temp_AC1(pos_idx)));
        % nearstAC1 = a_AR(AC1idx);
        tempAMI1_height_coor = [tempAMI1_height_coor, normpdf(temp_AMI1(pos_idx), mu(AC1idx), sigma(AC1idx))];

    end
    map_AMI{map_idx} = [tempAC1_coor; tempAMI1_coor; tempAMI1_height_coor];
end


% plot curve for each map on the same figure
hold on
for map_idx = 1:size(map_AMI,2)
    temp_map_AMI = map_AMI{map_idx};
    scatter3(temp_map_AMI(1,:), temp_map_AMI(2,:), temp_map_AMI(3,:), 5, 'filled')
end


legend('PDF', '95% CI lower', '95% CI upper', "sine", "logistic", "tent" , "AR", "tent with noise", "sine with more periods")
