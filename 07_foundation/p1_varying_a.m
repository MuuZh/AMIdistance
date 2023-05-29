clear 
close all

num_a = 50;
a = linspace(0.5, 0.99, num_a);
series_length = 20000;
k = 2000;
eta = 0.01;
% creat a num_a*series_length NaN matrix
series = NaN(num_a, series_length);

% general AR series with varing a
for i = 1:num_a
    series(i, :) = gen_AR(series_length, k, a(i), eta);
end

% plot the series
for i = 1:num_a
    pause(0.07)
    plot_distribution_zscore(series(i,:))
    % print float number with 2 decimal places
    title(sprintf('image z-scored, a = %.2f, a/eta = %.2f', a(i), a(i)/eta))
    % fixed x and y axis in range (-4,4)
    axis([-4 4 -4 4])

    % save to gif
    save2gif("stepcompar_0.5to0.99.gif", i);

end
