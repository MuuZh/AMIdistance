clear 
close all
clear 
close all

num_a = 200;
a = linspace(0, 1, num_a);
series_length = 2000;
k = 200;
eta = 1;
samplesize = 50;

series = NaN(num_a, samplesize, series_length);

% generate AR series with varing a
AMI_using_method = "kraskov2";

for i = 1:num_a
    for j = 1:samplesize
        series(i, j, :) = MkSg_AR(series_length, a(i), k);
    end
end

AMI_matrix = NaN(num_a,samplesize);

% compute AC and AMI features for each AR1 series
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
tic
for i = 1:num_a
    for j = 1: samplesize
        AMI_matrix(i,j) = IN_AutoMutualInfo(reshape(series(i,j,:), [series_length, 1]), 1, AMI_using_method);
    end
end
toc

% plot AC and AMI features
figure

for i = 1: num_a
    scatter(ones(1, samplesize)*a(i),AMI_matrix(i,:))
    hold on
end
