clear
close all


% a = 0.8;    
% series = MkSg_AR(11000, a, 1000);
% x = series(1:end-1);
% y = series(2:end);

% c = polyfit(x, y, 1);
% plot_distribution(series);
% hold on
% plot(x, c(1)*x + c(2), 'r', 'LineWidth', 2);
% axis equal
% % xlabel('x(t)')
% % ylabel('x(t+1)')
% title(sprintf('a =  %.1f', a))
% legend('distribution', 'linear fit')


series_length = 1000;
eta = 100;
% set a
a = 0.1:0.1:0.9;

% number of samples for each a
N = 100;

% make a 3 dimensional array to store the series
% 1st dimension: N
% 2nd dimension: length of series
% 3rd dimension: length of a
series_matrix = NaN(N, series_length, length(a));
% generate samples for each a
for i = 1:length(a)
    for j = 1:N
        series_matrix(j, :, i) = MkSg_AR(series_length, a(i), eta);
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
        fprintf("Processing a = %.2f, time used for this a: %.3fs, total time used: %.3fs\n", a(i), t2, totalt)
    else
        fprintf("Processing a = %.2f, time used for this a: %.3fs\n", a(i), t2)
    end
end

% plot the features
ax = axes();
xx = [];
yy = [];
c = colormap(hsv(length(a)));
for i = 1:length(a)
    x = AC_features(i, :);
    y = AMI_features(i, :);
    
    xx = [xx x];
    yy = [yy y]; 

    axis equal
    current_color = c(i, :);
    % scatter(x, y, '.','MarkerEdgeColor', current_color)
    h(i) = scatter(x, y, '.','MarkerEdgeColor', current_color, 'DisplayName', sprintf('a = %.5f', a(i)));

    hold on
end
% disply the legend for each a
hCopy = copyobj(h, ax);
for i = 1:length(a)
    set(hCopy(i), 'XData', NaN', 'YData', NaN);
    hCopy(i).Marker = 'O';
    hCopy(i).MarkerFaceColor = c(i,:);
    hCopy(i).MarkerEdgeColor = 'black';
end
legend(hCopy)
legend('Location','northwest');
legend('FontSize', 14)


grid on 

xlabel('AC feature')
ylabel('AMI feature')
title('feature feature correlation for AR(1) series')





% at a = 0.8
figure('Renderer', 'painters', 'Position', [10 10 900 600])
subplot(2, 2, 1)
% scatter(AC_features, AMI_features)
[~, minarg] = min(AC_features(8,:))
AC_features(8,minarg)
plot_distribution(series_matrix(minarg,:,8))
axis equal
title(sprintf('min AC = %f', AC_features(8,minarg)))
subplot(2, 2, 2)
[~, maxarg] = max(AC_features(8,:))
AC_features(8,maxarg)
plot_distribution(series_matrix(maxarg,:,8))
axis equal
title(sprintf('max AC = %f', AC_features(8,maxarg)))

subplot(2, 2, 3)
[~, minarg] = min(AMI_features(8,:))
AMI_features(minarg)
plot_distribution(series_matrix(minarg,:,8))
axis equal
title(sprintf('min AMI = %f', AMI_features(8,minarg)))
subplot(2, 2, 4)
[~, maxarg] = max(AMI_features(8,:))
AMI_features(8,maxarg)
plot_distribution(series_matrix(maxarg,:,8))
axis equal
title(sprintf('max AMI = %f', AMI_features(8,maxarg)))




[RHO,PVAL] = corr(xx',yy','Type','Spearman');

fprintf("Spearman correlation: %.5f\n", RHO)