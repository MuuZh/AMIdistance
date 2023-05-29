clear 
close all
a_num = 50;
sample_num = 20;
series_length = 2000;
eta = 200;

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
load('AR2cell_505020.mat')

AMI_using_method = "kraskov2";
AMI2_matrix = NaN(n_params,sample_num);
AC2_matrix = NaN(n_params,sample_num);
t1 = tic;
f = waitbar(0,'Please wait...', 'Name', 'Calculating AC and AMI');
for i =1:n_params
    waitbar(i/n_params,f,sprintf('Calculating AC and AMI: %d/%d',i,n_params))
    AR2matrix = AR2cell{i};
    for j=1:sample_num
        acf = autocorr(AR2matrix(j,:)', NumLags=2);
        AC2_matrix(i,j) = acf(3);
        AMI2_matrix(i,j) = IN_AutoMutualInfo(AR2matrix(j,:)', 2, AMI_using_method);
    end
end
save('AR2_ACAMI_505020.mat','AC2_matrix','AMI2_matrix','availiable_params')
t2 = toc(t1);
fprintf('Time elapsed: %d seconds',t2)


