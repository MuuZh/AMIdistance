clear
close all


a_num = 200;
series_length = 2000;
eta = 200;
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

load('a1a2_400square.mat')
load('AMI1_29700.mat')
load('AMI2_29700.mat')
load('availiable_params_29700.mat')
load("AC_29700.mat")
load('PAC_29700.mat')

n_params = size(availiable_params,1);
AC1 = AC(:,2);
AC2 = AC(:,3);

PAC2 = PAC(:,3);
figure
scatter(AC2,AMI2_matrix,'.')
figure
scatter(PAC2, AMI2_matrix, '.')

% f = waitbar(0,'Please wait...');
% PAC = NaN(n_params, 3);
% for i = 1:n_params
%     waitbar(i/n_params,f,sprintf('Progress: %d/%d',i,n_params))
%     PAC(i,:) = parcorr(AR2matrix(i,:), NumLags=2);
% end
