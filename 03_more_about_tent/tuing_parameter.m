clear
close all

N_length = 20000; % length of each generated series
k_length = 1000; % length of first k data points to be removed

testnums = 7;
mus = linspace(0,2, testnums);
results = NaN(testnums, N_length);
for i = 1:testnums
    current_mu = mus(i);
    results(i, :) = gen_tent_repeating(N_length, k_length, current_mu)';
end

% figure
% for i = 1:testnums
%     plot_distribution(results(i,:))
%     title(sprintf("mu = %f", mus(i)))
%     hold on
%     pause(0.7)
% end

figure 
for i = 1:testnums
    mu = mus(i);
    subplot(2, testnums, i)
    axis equal
    plot([0, 0.5], [0, mu/2])
    hold on
    plot([0.5, 1], [mu/2 0])
    title(sprintf("mu = %f", mu))

    
    subplot(2, testnums, i+testnums)
    axis equal
    ts = results(i,:);
    scatter(ts(1:end-1), ts(2:end), '.')
    xlabel('x_t')
    ylabel('x_{t+1}')
    % plot_distribution(results(i, :))
    title(sprintf("mu = %f", mu))
    

end



% figure 
% mu = 1.028;
% mu1028 = gen_tent_2(N_length, k_length, mu);
% plot_distribution(mu1028)
% figure
% axis equal
% plot([0, 0.5], [0, mu/2])
% hold on
% plot([0.5, 1], [mu/2 0])