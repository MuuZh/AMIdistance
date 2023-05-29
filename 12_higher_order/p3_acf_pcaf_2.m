clear
close all




rstart = 3.57;
rend = 4;
rstep = 0.002;
logistic_LE = LEofLogisticMap(rstart, rend, rstep);

num_A = length(logistic_LE);
series_length = 2000;
eta = 200;
a_logisitic = linspace(rstart, rend, num_A);
initial_logistic = 1/sqrt(2);

logistic_series = NaN (num_A, series_length);
for i=1:num_A
    logistic_series(i,:) = MkSg_Map('logistic', series_length, initial_logistic ,a_logisitic(i), eta);
end
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

step_AC = 1;
step_AMI = 1;


useful_range = logistic_LE > 0;
useful_LE = logistic_LE(useful_range);

useful_logistic = logistic_series(useful_range, :);
useful_a = a_logisitic(useful_range);

testing_series = useful_logistic(189,:);
figure('Position', [100, 100, 1800, 500])
subplot(1,2,1)
autocorr(testing_series, NumLags=100);
subplot(1,2,2)
parcorr(testing_series, NumLags=100);
sgtitle(sprintf("Logistic Map (r=%.3f)", useful_a(198)));


[acf,acflags] = autocorr(testing_series, NumLags=100);
[pacf,pacflags] = parcorr(testing_series, NumLags=100);
