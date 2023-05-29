function plot_distribution_zscore(ts)
    zts = zscore(ts);
    scatter(zts(1:end-1), zts(2:end), '.')
    xlabel('x_t')
    ylabel('x_{t+1}')
    title('z-scored')
end