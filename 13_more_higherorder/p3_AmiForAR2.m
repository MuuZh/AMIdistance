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
% AR2matrix = NaN(n_params,series_length);
% f=waitbar(0,'Generating AR2 series...', 'Name', 'Generating AR2 series...');
% t1 = tic;
% for i = 1:n_params
%     waitbar(i/n_params,f,sprintf('Progress: %d/%d',i,n_params))
%     AR2matrix(i,:) = MkSg_AR(series_length,[availiable_params(i,2), availiable_params(i,1)]', eta);
% end
% close(f)
% t2 = toc(t1);
% fprintf('Time uesd to generate series: %f\n',t2)

load("a1a2_400square.mat")

AMI2_matrix =NaN(n_params,1);
step_AMI = 2;

t1 = tic;
f = waitbar(0,'Computing AMI...', 'Name', 'Computing AMI...');
for i = 1:n_params
    waitbar(i/n_params,f,sprintf('Progress: %d/%d',i,n_params))
    AMI2_matrix(i) = IN_AutoMutualInfo(AR2matrix(i,:)', 2, AMI_using_method);
end

t2 = toc(t1);
fprintf('Time uesd to compute AMI: %f\n',t2)

figure
scatter(availiable_params(:,1),availiable_params(:,2),10,AMI2_matrix,'filled')
colorbar
