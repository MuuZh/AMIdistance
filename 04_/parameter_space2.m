clear
close all

% firstly try 2 parameters with fixed noise levels


eta_ar = 0.2;
eta_tent = 0.03;

paranums_a = 600;
paranums_mu = 600;

AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
% AMI_using_method = "gaussian";



N_length = 5000; % length of each generated series
k_length = 1000; % length of first k data points to be removed

as = linspace(0.1, 0.99, paranums_a);
mus = linspace(0.9, 1.1, paranums_mu);

data_ar = NaN(paranums_a, N_length);
data_tent = NaN(paranums_mu, N_length);

for i = 1:paranums_a
    data_ar(i,:) = gen_AR_p(N_length,k_length,as(i), eta_ar);
end

for i = 1:paranums_mu
    data_tent(i,:) = gen_tent_p(N_length,k_length,mus(i), eta_tent);
end





AC_AR = NaN(paranums_a, 1);
AMI_AR = NaN(paranums_a, 1);
AC_tent = NaN(1, paranums_mu);
AMI_tent = NaN(1, paranums_mu);


for i = 1:paranums_a
    current_AR = data_ar(i, :)';
    AC_AR(i) = CO_AutoCorr(current_AR,1, AC_using_method);
    AMI_AR(i) = IN_AutoMutualInfo(current_AR, 1, AMI_using_method);
end

for i = 1:paranums_mu
    current_tent = data_tent(i, :)';
    AC_tent(i) = CO_AutoCorr(current_tent,1, AC_using_method);
    AMI_tent(i) = IN_AutoMutualInfo(current_tent, 1, AMI_using_method);
end



distance_matrix = NaN(paranums_a, paranums_mu);

for rownum = 1:paranums_a
    for colnum = 1:paranums_mu
        distance_matrix(rownum, colnum) = abs(AC_tent(colnum) - AC_AR(rownum)) + abs(AMI_tent(colnum) - AMI_AR(rownum));
    end
end


save('distance_matrix.mat', 'distance_matrix')
% load('distance_matrix.mat')
% imagesc(distance_matrix)

% colorbar

% xt = get(gca, 'XTick'); 
% xtlbl = linspace(min(mus), max(mus), numel(xt)); 
% set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',0) 

% yt = get(gca, 'YTick'); 
% ytlbl = linspace(min(as), max(as), numel(yt)); 
% set(gca, 'YTick',xt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 


% xlabel('\mu')
% ylabel('a')



figure
imshow(distance_matrix, [], 'XData', mus, 'YData', as);
colormap(parula(256));
% colormap(hot(256));
colorbar;
axis on
xlabel('\mu')
ylabel('a')
title({"G(a,\mu)=|\DeltaAC_1^{tent/AR}| + |\DeltaAMI_1^{tent/AR}|"; "AMI using method "+AMI_using_method} )



figure
plot(as, AC_AR)
xlabel('a')
ylabel('AC AR')
title({'AC1 features on AR procrss with different a';'AMI using method '+AMI_using_method})
figure
plot(as, AMI_AR)
xlabel('a')
ylabel('AMI AR')
title({'AMI1 features on AR procrss with different a';'AMI using method '+AMI_using_method})


figure
plot(mus, AC_tent)
xlabel('\mu')
ylabel('AC tent')
title({'AC1 features on tent procrss with different \mu';'AMI using method '+AMI_using_method})

figure
plot(mus, AMI_tent)
xlabel('\mu')
ylabel('AMI tent')
title({'AMI1 features on tent procrss with different \mu';'AMI using method '+AMI_using_method})