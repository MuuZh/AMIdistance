clear
close all

num_A = 1000;
a_sine = linspace(0.89, 0.994, num_A);
a_logisitic = linspace(3.6791, 3.996, num_A);
series_length = 1000;
eta = 100;

series_sine = NaN(num_A, series_length);
series_logistic = NaN(num_A, series_length);

for i = 1:num_A
    series_sine(i, :) = MkSg_Map('sine', series_length, 0.1, a_sine(i), eta);
    series_logistic(i, :) = MkSg_Map('logistic', series_length, 1/sqrt(2), a_logisitic(i), eta);
end

AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute AR and AMI fetures for each sample
AC_features_sine = NaN(1,num_A);
AMI_features_sine = NaN(1,num_A);

AC_features_logisitic = NaN(1,num_A);
AMI_features_logisitic = NaN(1,num_A);


totalt = 0;
for i = 1:num_A
    tic;

    AC_features_sine(i) = CO_AutoCorr(series_sine(i, :)',1, AC_using_method);
    AMI_features_sine(i) = IN_AutoMutualInfo(series_sine(i, :)', 1, AMI_using_method);

    AC_features_logisitic(i) = CO_AutoCorr(series_logistic(i, :)',1, AC_using_method);
    AMI_features_logisitic(i) = IN_AutoMutualInfo(series_logistic(i, :)', 1, AMI_using_method);
    % current_series = series_matrix(j, :, i)';
    % x_series = current_series(1:end-1);
    % y_series = current_series(2:end);
    % AMI_features(i, j)  = mi_cont_cont(x_series, y_series, 5);

    t2 = toc;
    totalt = totalt + t2;
    if i == num_A
        fprintf("time used for this a: %.3fs, total time used: %.3fs\n", t2, totalt)
    else
        % fprintf("Processing A = %.5f, time used for this a: %.3fs\n", a(i), t2)
    end
end

plot(1:num_A,AC_features_sine, '.')
hold on
plot(1:num_A,AC_features_logisitic, '.')
grid on
title('AC features of logistic map and sine map') 
% xlabel('A')
ylabel('AC features')
legend('sine map', 'logistic map')
figure
plot(1:num_A,AMI_features_sine, '.')
hold on
plot(1:num_A,AMI_features_logisitic, '.')
grid on
title(sprintf('AMI features of logistic map and sine map'))
% xlabel('A')
ylabel('AMI features')
legend('sine map', 'logistic map')
