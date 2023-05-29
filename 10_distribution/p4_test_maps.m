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


[AC1_matrix_abs, AMI1_matrix] = p4_get_features();

bined_map_AMI = {};
% collect AC1 and AMI1 of maps
for i = 1:size(AC1_matrix_abs,1)
    temp_AC1 = AC1_matrix_abs(i,:);
    temp_AMI1 = AMI1_matrix(i,:);
    bined_map_AMI{i} = AMI_in_bins_maps(temp_AC1, temp_AMI1, n_bins, binedges);
end



% compute height for each AMI1 in each bin
map_AMI = {};
for map_idx = 1:size(bined_map_AMI,2)
    temp_AMI1 = bined_map_AMI{map_idx};
    tempAC1_coor = [];
    tempAMI1_coor = [];
    tempAMI1_height_coor = [];
    for bin_idx = 1:size(temp_AMI1,2)
        for bined_AMI_idx = 1:size(temp_AMI1{bin_idx},2)
            tempAC1_coor = [tempAC1_coor, bincenters(bin_idx)];
            AMI_in_this_bin = temp_AMI1{bin_idx};
            tempAMI1_coor = [tempAMI1_coor, AMI_in_this_bin(bined_AMI_idx)];
            tempAMI1_height_coor = [tempAMI1_height_coor, normpdf(AMI_in_this_bin(bined_AMI_idx), mu(bin_idx), sigma(bin_idx))];
        end
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
