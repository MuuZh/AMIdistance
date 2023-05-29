clear
close all

% firstly try 2 parameters with fixed noise levels


eta_ar = 0.2;
eta_tent = 0.1;

paranums_a = 100;
paranums_mu = 100;

AC_using_method = "Fourier";
AMI_using_method = "gaussian";



N_length = 5000; % length of each generated series
k_length = 1000; % length of first k data points to be removed

as = linspace(0.1, 0.99, paranums_a);
mus = linspace(0.1, 2, paranums_mu);

data_ar = NaN(paranums_a, N_length);
data_tent = NaN(paranums_mu, N_length);

for i = 1:paranums_a
    data_ar(i,:) = gen_AR_p(N_length,k_length,as(i), eta_ar);
end

for i = 1:paranums_mu
    data_tent(i,:) = gen_tent_p(N_length,k_length,mus(i), eta_tent);
end





distance_matrix = NaN(paranums_a, paranums_mu);


for rownum = 1:paranums_a
    current_AR = data_ar(rownum, :)';
    AC_AR = CO_AutoCorr(current_AR,1, AC_using_method);
    AMI_AR = IN_AutoMutualInfo(current_AR, 1, AMI_using_method);

    for colnum = 1:paranums_mu
        current_tent = data_tent(colnum, :)';
        AC_tent= CO_AutoCorr(current_tent,1, AC_using_method);
        AMI_tent = IN_AutoMutualInfo(current_tent, 1, AMI_using_method);

        distance_matrix(rownum, colnum) = abs(AC_tent - AC_AR) + abs(AMI_tent - AMI_AR);
    end
end


save('distance_matrix.mat', 'distance_matrix')
% load('distance_matrix.mat')
imagesc(distance_matrix)

colorbar

xt = get(gca, 'XTick'); 
xtlbl = linspace(min(mus), max(mus), numel(xt)); 
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',0) 

yt = get(gca, 'YTick'); 
ytlbl = linspace(min(as), max(as), numel(yt)); 
set(gca, 'YTick',xt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 

xlabel('\mu')
ylabel('a')