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
AR2matrix = NaN(n_params,series_length);
for i = 1:n_params
    AR2matrix(i,:) = MkSg_AR(series_length,[availiable_params(i,2), availiable_params(i,1)]', eta);
end
% save('a1a2_400square.mat', 'AR2matrix')
% AC = NaN(n_params,3);
% for i = 1:n_params
%     AC(i,:) = autocorr(AR2matrix(i,:), NumLags=2);
% end

% figure
% scatter(availiable_params(:,1),availiable_params(:,2),10,AC(:,2),'filled')
% colorbar
% figure
% scatter(availiable_params(:,1),availiable_params(:,2),10,AC(:,3),'filled')
% colorbar