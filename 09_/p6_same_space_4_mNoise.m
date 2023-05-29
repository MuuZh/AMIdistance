clear
close all

num_A = 200;
a_sine = linspace(0.89, 0.994, num_A);
a_logisitic = linspace(3.6791, 3.996, num_A);

initial_sine = 1/sqrt(2);
initial_logistic = 1/sqrt(2);

series_length = 2000;
eta = 200;

series_sine = NaN(num_A, series_length);
series_logistic = NaN(num_A, series_length);
for i = 1:num_A
    series_sine(i,:) = MkSg_Map('sine', series_length, initial_sine, a_sine(i), eta);
    % series_logistic(i,:) = MkSg_Map('logistic', series_length, initial_logistic, a_logisitic(i), eta);
end

mNoise_levle = 0.00001;
series_sine_mNoise = series_sine + mNoise_levle*randn(size(series_sine));


AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute AR and AMI fetures for each sample
AC_features_sine = NaN(num_A,1);
AMI_features_sine = NaN(num_A,1);

AC_features_sine_mNoise = NaN(num_A,1);
AMI_features_sine_mNoise= NaN(num_A,1);



% AC_features_logisitic = NaN(num_A,1);
% AMI_features_logisitic = NaN(num_A,1);


totalt = 0;
for i = 1:num_A
    tic;
        AC_features_sine(i) = CO_AutoCorr(series_sine(i, :)',1, AC_using_method);
        AC_features_sine_mNoise(i) = CO_AutoCorr(series_sine_mNoise(i, :)',1, AC_using_method);
        % AC_features_logisitic(i) = CO_AutoCorr(series_logistic(i, :)',1, AC_using_method);
        AMI_features_sine(i) = IN_AutoMutualInfo(series_sine(i, :)', 1, AMI_using_method);
        AMI_features_sine_mNoise(i) = IN_AutoMutualInfo(series_sine_mNoise(i, :)', 1, AMI_using_method);
        % AMI_features_logisitic(i) = IN_AutoMutualInfo(series_logistic(i, :)', 1, AMI_using_method);
    t2 = toc;
    totalt = totalt + t2;
    if i == num_A
        fprintf("Processing i = %d, time used for this a: %.3fs, total time used: %.3fs\n", i, t2, totalt)
    else
        % fprintf("Processing i = %d, time used for this a: %.3fs\n", i, t2)
    end
end

AC1_sine_abs = abs(AC_features_sine);
AC1_sine_mNoise_abs = abs(AC_features_sine_mNoise);
% AC1_logistic_abs = abs(AC_features_logisitic);


scatter(AC1_sine_abs, AMI_features_sine,'.');
hold on 
scatter(AC1_sine_mNoise_abs, AMI_features_sine_mNoise,'.');
grid on
legend("sine", "sine with measruement noise " + num2str(mNoise_levle))
legend('Location','southeast');
legend('FontSize', 14)
xlabel('AC feature')
ylabel('AMI feature')
title('AMI vs AC for f-f correlation')




