function plot_AC_region(ts)
    scatter(ts(1:end-1), ts(2:end), '.')
    xlabel('x_t')
    ylabel('x_{t+1}')
end