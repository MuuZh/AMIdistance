clear
close all

num_A = 50;
series_length = 20000;
k = 2000;



% TENT MAP
% creat a num_A*series_length NaN matrix
series_tent = NaN(num_A, series_length);
A = linspace(1.0001, 1.9999, num_A);
% generate sereies with varing a
for i = 1:num_A
    series_tent(i, :) = MkSg_Map('tent', series_length, 1/sqrt(2), A(i), k);
end

% SINE MAP
% creat a num_A*series_length NaN matrix
series_sine = NaN(num_A, series_length);
A = linspace(3.57, 4, num_A);
% generate sereies with varing a
for i = 1:num_A
    series_sine(i, :) = MkSg_Map('sine', series_length, 0.1, A(i), k);
end

% LOGISTIC MAP
% creat a num_A*series_length NaN matrix
series_logistic = NaN(num_A, series_length);
A = linspace(3.57, 4, num_A);
% generate sereies with varing a
for i = 1:num_A
    series_logistic(i, :) = MkSg_Map('logistic', series_length, 0.1, A(i), k);
end

% save('ThreeTypesOfSeries', 'series_tent', 'series_sine', 'series_logistic');

series = {series_tent, series_sine, series_logistic};

AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

num_maps = length(series);
AC_features = {};
AMI_features = {};
for m = 1:num_maps
    current_map = series{m};
    AC_features_temp = NaN(num_A,1);
    AMI_features_temp = NaN(num_A,1);
    for i = 1:num_A
        AC_features_temp(i) = CO_AutoCorr(current_map(i,:)',1, AC_using_method);
        AMI_features_temp(i) = IN_AutoMutualInfo(current_map(i,:)', 1, AMI_using_method);
    end
    AC_features{m} = AC_features_temp;
    AMI_features{m} = AMI_features_temp;
end

save('computed_features', 'AC_features', 'AMI_features');

figure
for i = 1:num_maps
    amif = AMI_features{i};
    plot(amif)
    hold on
end
legend('tent', 'sine', 'logistic')
title('AMI  1 fetures for different maps')

figure
for i = 1:num_maps
    acf = AC_features{i};
    plot(acf)
    hold on
end
legend('tent', 'sine', 'logistic')
title('AC1 fetures for different maps')