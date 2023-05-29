clear
close all


% a = 1.2;    
% series = MkSg_Map('tent', 1000, 1/sqrt(2), a, 100);
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
a = linspace(3.6,3.8,10);

% number of samples for each a
N = 100;

% make a 3 dimensional array to store the series
% 1st dimension: N
% 2nd dimension: length of series
% 3rd dimension: length of a

% different initial contidion
initial_a = linspace(-0.1, 0.1, N) * 0.1 + 0.1;

series_matrix = NaN(N, series_length, length(a));
% generate samples for each a
for i = 1:length(a)
    for j = 1:N
        % series_matrix(j, :, i) = MkSg_AR(series_length, a(i), eta);
        series_matrix(j, :, i) = MkSg_Map('logistic', series_length, initial_a(j), a(i), eta);
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
    h(i) = scatter(x, y, '.','MarkerEdgeColor', current_color, 'DisplayName', sprintf('a = %.5f', a(i)));
    hold on
end

hCopy = copyobj(h, ax);
for i = 1:length(a)
    set(hCopy(i), 'XData', NaN', 'YData', NaN);
    hCopy(i).Marker = 'O';
    hCopy(i).MarkerFaceColor = c(i,:);
    hCopy(i).MarkerEdgeColor = 'black';
end
legend(hCopy)
legend('Location','northeast');
legend('FontSize', 14)


grid on 

xlabel('AC feature')
ylabel('AMI feature')
title('feature feature correlation for logistic map')


% [~, I] = sort(xx);

% MI_value = mi_cont_cont(xx(I), yy(I), 5);
MI_value = mi_cont_cont(xx, yy, 5);

fprintf("MI value: %.5f\n", MI_value)