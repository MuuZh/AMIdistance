clear
close all

num_A = 100;
A = linspace(1.0001, 1.9999, num_A);
series_length = 1000;;
eta = 100;
series = NaN(num_A, series_length);

for i = 1:num_A
    series(i,:) = MkSg_Map('tent', series_length, 1/sqrt(2), A(i), eta);
end

for i = 1:num_A
    x = series(i, 1:end-1);
    y = series(i, 2:end);

    c = polyfit(x, y, 1);
    plot_distribution(series(i, :));
    axis([0 1 0 1])
    hold on
    plot(x, c(1)*x + c(2), 'r', 'LineWidth', 2);
    hold off
    title(sprintf('tent map a =  %.1f', A(i)));
    legend('distribution', 'linear fit')
    save2gif('tent1to2.gif', i, 'DelayTime', 0.03);
    pause(0.06);
end

