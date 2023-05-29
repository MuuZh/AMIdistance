clear
close all

N = 100;
num_A = 20;
a_sine = linspace(0.89, 0.994, num_A);
a_logisitic = linspace(3.6791, 3.996, num_A);

initial_sine = linspace(-0.1, 0.1, N) * 1/sqrt(2) + 1/sqrt(2);
initial_logistic = linspace(-0.1, 0.1, N) * 1/sqrt(2) + 1/sqrt(2);

series_length = 1000;
eta = 100;

series_sine = NaN(N, series_length, num_A);
series_logistic = NaN(N, series_length, num_A);
for i = 1:num_A
    for j = 1:N
        series_sine(j, :, i) = MkSg_Map('sine', series_length, initial_sine(j), a_sine(i), eta);
        series_logistic(j, :, i) = MkSg_Map('logistic', series_length, initial_logistic(j), a_logisitic(i), eta);
    end
end

AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute AR and AMI fetures for each sample
AC_features_sine = NaN(num_A,N);
AMI_features_sine = NaN(num_A,N);

AC_features_logisitic = NaN(num_A,N);
AMI_features_logisitic = NaN(num_A,N);


totalt = 0;
for i = 1:num_A
    tic;
    for j = 1:N
        AC_features_sine(i, j) = CO_AutoCorr(series_sine(j, :, i)',1, AC_using_method);
        AC_features_logisitic(i, j) = CO_AutoCorr(series_logistic(j, :, i)',1, AC_using_method);
        AMI_features_sine(i, j) = IN_AutoMutualInfo(series_sine(j, :, i)', 1, AMI_using_method);
        AMI_features_logisitic(i, j) = IN_AutoMutualInfo(series_logistic(j, :, i)', 1, AMI_using_method);

    end
    t2 = toc;
    totalt = totalt + t2;
    if i == num_A
        fprintf("Processing i = %d, time used for this a: %.3fs, total time used: %.3fs\n", i, t2, totalt)
    else
        fprintf("Processing i = %d, time used for this a: %.3fs\n", i, t2)
    end
end

xx_sine = [];
yy_sine = [];
xx_logistic = [];
yy_logistic = [];

figure
for i=1:num_A
    x = AC_features_sine(i, :);
    y = AMI_features_sine(i, :);
    xx_sine = [xx_sine x];
    yy_sine = [yy_sine y];
    
    x = AC_features_logisitic(i, :);
    y = AMI_features_logisitic(i, :);
    xx_logistic = [xx_logistic x];
    yy_logistic = [yy_logistic y];
end

scatter(xx_sine, yy_sine,'.');
hold on 
scatter(xx_logistic, yy_logistic,'.');
grid on
legend("sine", "logistic")
legend('Location','southeast');
legend('FontSize', 14)
xlabel('AC feature')
ylabel('AMI feature')
title('AMI vs AC for f-f correlation')


