clear
close all


a_num = 200;
series_length = 2000;
eta = 200;
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";


param1 = linspace(-1,1,a_num);
param2 = linspace(-1,1,a_num);
availiable_params = [];
for a1 =param1
    for a2 = param2
        if (a2 < 1-abs(a1)) && (a2 > -1)
            availiable_params = [availiable_params; a1, a2];
        end
    end
end

n_params = size(availiable_params,1);

load('AMI1_29700.mat')
load('AMI2_29700.mat')
figure('Position',[100 100 1000 500]')
subplot(1,2,1)
AMI1_matrix_zcore = zscore(AMI1_matrix);
scatter(availiable_params(:,1),availiable_params(:,2),10,caxis(AMI1_matrix_zcore),'filled')
axis equal
cb= colorbar'
xlabel('a1')
ylabel('a2')
ylabel(cb,'AMI1')
title('AMI1 zcored')


subplot(1,2,2)
AMI2_matrix_zcore = zscore(AMI2_matrix);

scatter(availiable_params(:,1),availiable_params(:,2),10,AMI2_matrix_zcore,'filled')
axis equal
cb= colorbar;
xlabel('a1')
ylabel('a2')
ylabel(cb,'AMI2')
title('AMI2 zscored')

