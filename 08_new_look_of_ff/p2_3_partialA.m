clear
close all


series_length = 1000;
eta = 100;
% set a
a = linspace(1.01,1.999,10);

% number of samples for each a
N = 100;

% make a 3 dimensional array to store the series
% 1st dimension: N
% 2nd dimension: length of series
% 3rd dimension: length of a

% different initial contidion
initial_a = linspace(-0.1, 0.1, N) * 1/sqrt(2) + 1/sqrt(2);

series_matrix = NaN(N, series_length, length(a));
% generate samples for each a
for i = 1:length(a)
    for j = 1:N
        % series_matrix(j, :, i) = MkSg_AR(series_length, a(i), eta);
        series_matrix(j, :, i) = MkSg_Map('tent', series_length, initial_a(j), a(i), eta);
    end
end


AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute AR and AMI fetures for each sample
AC_features = NaN(length(a), N);
AMI_features = NaN(length(a), N);

totalt = 0;
for i = 1:length(a)
    tic;
    for j = 1:N
        AC_features(i, j) = CO_AutoCorr(series_matrix(j, :, i)',1, AC_using_method);
        AMI_features(i, j) = IN_AutoMutualInfo(series_matrix(j, :, i)', 1, AMI_using_method);
    end
    t2 = toc;
    totalt = totalt + t2;
    if i == length(a)
        fprintf("Processing a = %.5f, time used for this a: %.3fs, total time used: %.3fs\n", a(i), t2, totalt)
    else
        fprintf("Processing a = %.5f, time used for this a: %.3fs\n", a(i), t2)
    end
end

% plot for A
figure('Renderer', 'painters', 'Position', [10 10 900 900])
aI = 2;
for i = 1:9
    subplot(3,3,i)
    plot_distribution(series_matrix(i,:,aI))
    axis equal
    title(sprintf("A=%.3f, AC=%.3f ,AMI=%.3f", a(aI), AC_features(aI, i), AMI_features(aI, i)))
end

% 
% figure('Renderer', 'painters', 'Position', [10 10 900 600])
% subplot(2, 2, 1)
% % scatter(AC_features, AMI_features)
% [~, minarg] = min(AC_features(8,:))
% AC_features(8,minarg)
% plot_distribution(series_matrix(minarg,:,8))
% axis equal
% title(sprintf('min AC = %f', AC_features(8,minarg)))
% subplot(2, 2, 2)
% [~, maxarg] = max(AC_features(8,:))
% AC_features(8,maxarg)
% plot_distribution(series_matrix(maxarg,:,8))
% axis equal
% title(sprintf('max AC = %f', AC_features(8,maxarg)))
% 
% subplot(2, 2, 3)
% [~, minarg] = min(AMI_features(8,:))
% AMI_features(minarg)
% plot_distribution(series_matrix(minarg,:,8))
% axis equal
% title(sprintf('min AMI = %f', AMI_features(8,minarg)))
% subplot(2, 2, 4)
% [~, maxarg] = max(AMI_features(8,:))
% AMI_features(8,maxarg)
% plot_distribution(series_matrix(maxarg,:,8))
% axis equal
% title(sprintf('max AMI = %f', AMI_features(8,maxarg)))