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
AR2cell = {};
f = waitbar(0,'Please wait...');
t1 = tic;
for i = 1:n_params
    waitbar(i/n_params,f,['Please wait... ',num2str(i),'/',num2str(n_params)]);
    AR2matrix = NaN(sample_num,series_length);
    for j = 1:sample_num
        AR2matrix(j,:) = MkSg_AR(series_length,[availiable_params(i,2), availiable_params(i,1)]', eta);
    end
    AR2cell{i} = AR2matrix;
end
save('AR2cell_505020.mat','AR2cell')
t2=toc(t1);
disp(['Time elapsed: ',num2str(t2),' seconds.'])