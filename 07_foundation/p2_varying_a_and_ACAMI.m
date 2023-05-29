clear 
close all

num_a = 100;
a = linspace(-0.99, -0.01, num_a);
series_length = 20000;
k = 2000;
eta = 1;

series = NaN(num_a, series_length);

% generate AR series with varing a
for i = 1:num_a
    series(i, :) = gen_AR(series_length, k, a(i), eta);
    % series(i, :) = MkSg_AR(series_length, a(i), k);
end

AC_features = NaN(num_a,1);
AMI_features = NaN(num_a,1);

% compute AC and AMI features for each AR1 series
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
for i = 1:num_a
    AC_features(i) = CO_AutoCorr(series(i,:)',1, AC_using_method);
    AMI_features(i) = IN_AutoMutualInfo(series(i,:)', 1, AMI_using_method);
end

% plot AC and AMI features
figure

plot(a, AC_features)
xlabel('a')
hold on 
plot(a, AMI_features)
xlabel('a')
ylabel('feature value')
legend('AC1', 'AMI1')
title("AC/AMI features for AR1 series")
