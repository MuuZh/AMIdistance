clear
close all

NL = 10000;
g1num = 1;
g2num = 1;

g1matrix = NaN(g1num, NL);
for i = 1:g1num
    % s0 =  [-1; 0; 0.5] + [randn(); randn(); randn()];
    % temp = MkSg_Flow("RabFab",NL, [], s0);
    temp = MkSg_Flow("RabFab",NL);
    g1matrix(i,:) = temp(:,1)';
end

g2matrix = NaN(g2num, NL);
for i = 1:g2num
    % s0 = [0; 0.96; 0] +  [randn(); randn(); randn()];
    % temp = MkSg_Flow("simpccf", [], s0);
    temp = MkSg_Flow("simpccf", NL);
    g2matrix(i,:) = temp(:,1)';
end

totalmatrix = [g1matrix;g2matrix];

save("signals_matrix", "totalmatrix")

% have a look of some examples
g1sample = g1matrix(1,:);
g2sample = g2matrix(1,:);
plot(zscore(g1sample));
hold on
plot(zscore(g2sample))
legend('group1', 'group2')

figure
plot_distribution_zscore(g1sample)
hold on
plot_distribution_zscore(g2sample)
legend('group1', 'group2')
