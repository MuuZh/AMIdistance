clear
close all


a = 0.8;
series_length = 1000;
eta = 100;
N = 100;

series_matrix = NaN(N, series_length, length(a));
for j = 1:N
    series_matrix(j, :) = MkSg_AR(series_length, a, eta);
end

AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute AR and AMI fetures for each sample
AC_features = NaN(length(a), N);
AMI_features = NaN(length(a), N);

totalt = 0;


for j = 1:N
    AC_features(j) = CO_AutoCorr(series_matrix(j, :)',1, AC_using_method);
    AMI_features(j) = IN_AutoMutualInfo(series_matrix(j, :)', 1, AMI_using_method);
end


figure('Renderer', 'painters', 'Position', [10 10 900 600])
subplot(2, 2, 1)
% scatter(AC_features, AMI_features)
[~, minarg] = min(AC_features)
AC_features(minarg)
plot_distribution(series_matrix(minarg,:))
axis equal
title(sprintf('min AC = %f', AC_features(minarg)))
subplot(2, 2, 2)
[~, maxarg] = max(AC_features)
AC_features(maxarg)
plot_distribution(series_matrix(maxarg,:))
axis equal
title(sprintf('max AC = %f', AC_features(maxarg)))

subplot(2, 2, 3)
[~, minarg] = min(AMI_features)
AMI_features(minarg)
plot_distribution(series_matrix(minarg,:))
axis equal
title(sprintf('min AMI = %f', AMI_features(minarg)))
subplot(2, 2, 4)
[~, maxarg] = max(AMI_features)
AMI_features(maxarg)
plot_distribution(series_matrix(maxarg,:))
axis equal
title(sprintf('max AMI = %f', AMI_features(maxarg)))
