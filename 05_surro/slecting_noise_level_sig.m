clear
close all



AC_using_method = "Fourier";
AMI_using_method = "kraskov2";


N_length = 5000; % length of each generated series
k_length = 1000; % length of first k data points to be removed

nums = 100;
etas = linspace(0.001, 2, nums);
mus = linspace(0.1, 10, nums);
data_tent = NaN(N_length, nums, nums);
for eta_idx = 1:nums
    for mu_idx = 1:nums
        data_tent(:,mu_idx, eta_idx) = gen_sigmoid_p(N_length,k_length,mus(mu_idx), etas(eta_idx));
    end
end


AC_tent = NaN(nums, nums);
AMI_tent = NaN(nums, nums);

for eta_idx = 1:nums
    for mu_idx = 1:nums
    current_tent = data_tent(:,mu_idx, eta_idx);
    AC_tent(eta_idx,mu_idx) = CO_AutoCorr(current_tent,1, AC_using_method);
    AMI_tent(eta_idx, mu_idx) = IN_AutoMutualInfo(current_tent, 1, AMI_using_method);
    
    end
    eta_idx
end


figure
imshow(AC_tent, [], 'XData', mus, 'YData', etas);
colormap(parula(256));
% colormap(hot(256));
colorbar;
axis on
xlabel('\theta')
ylabel('\eta')
title('AC1 feature values')

figure
imshow(AMI_tent, [], 'XData', mus, 'YData', etas);
colormap(parula(256));
% colormap(hot(256));
colorbar;
axis on
xlabel('\theta')
ylabel('\eta')
title('AMI1 feature values')