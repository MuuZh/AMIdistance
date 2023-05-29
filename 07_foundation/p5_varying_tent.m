clear 
close all


num_A = 50;
A = linspace(1.0001, 1.9999, num_A);
series_length = 20000;
k = 2000;
% creat a num_A*series_length NaN matrix
series = NaN(num_A, series_length);

% generate logisitic sereies with varing a
for i = 1:num_A
    series(i, :) = MkSg_Map('tent', series_length, 1/sqrt(2), A(i), k);
end

AC_features = NaN(num_A,1);
AMI_features = NaN(num_A,1);

% compute AC and AMI features for each AR1 series
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
for i = 1:num_A
    AC_features(i) = CO_AutoCorr(series(i,:)',1, AC_using_method);
    AMI_features(i) = IN_AutoMutualInfo(series(i,:)', 1, AMI_using_method);
end

% plot AC and AMI features


plot(A, AC_features, 'LineWidth', 1)
xlabel('a')
hold on 
plot(A, AMI_features, 'LineWidth', 1)
xlabel('A')
ylabel('feature value')
% legend('AC1', 'AMI1')
title("AC/AMI features for tent series")
hold on
