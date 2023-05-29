clear 
close all

num_A = 50;
A = linspace(3.57, 4, num_A);
series_length = 20000;
k = 2000;
eta = 0;
% creat a num_a*series_length NaN matrix
series = NaN(num_A, series_length);

% generate logisitic sereies with varing a
for i = 1:num_A
    series(i, :) = gen_logistic(series_length, k, A(i), eta);
end

% plot the series
for i = 1:num_A
    pause(0.07)
    plot_distribution(series(i,:))
    % print float number with 2 decimal places
    title(sprintf('Logistic map, A = %.2f', A(i)))
    % fixed x and y axis in range (-4,4)
    axis([0 1 -0 1])

    % save to gif
    save2gif("logistic_stepcompar_3.57to4_noise.gif", i);

end