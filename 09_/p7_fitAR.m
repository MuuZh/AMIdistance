clear
close all
series_length = 2000;
eta = 100;
num_A = 3000;
a = linspace(0,1,num_A);
series_matrix = NaN(num_A, series_length);
% generate samples for each a
for i = 1:length(a)
        series_matrix(i, :) = MkSg_AR(series_length, a(i), eta); 
end

AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute AR and AMI fetures for each sample
AC_features = NaN(length(a), 1);
AMI_features = NaN(length(a), 1);

totalt = 0;
for i = 1:length(a)
    tic;
        AC_features(i) = abs(CO_AutoCorr(series_matrix(i,:)',1, AC_using_method));
        AMI_features(i) = IN_AutoMutualInfo(series_matrix(i,:)', 1, AMI_using_method);
    t2 = toc;
    totalt = totalt + t2;
    if i == length(a)
        fprintf("Processing a = %.2f, time used for this a: %.3fs, total time used: %.3fs\n", a(i), t2, totalt)
    elseif mod(i,100) == 0
        fprintf("Processing a = %.2f, time used for this a: %.3fs\n", a(i), t2)
    end
end

% p = polyfit(AC_features,AMI_features,15);
p = [3470378.44825176	-24953902.5367082	80805902.1690628	-155709477.765235	198761818.670307	-177057799.050891	112952509.521355	-52116433.5853588	17353712.2141604	-4113814.85965617	675958.230742955	-73601.9802550120	4927.31505504605	-176.724474158128	2.54583402316481	-0.00363638820213637];

plot(AC_features, polyval(p, AC_features))
xlabel('|AC1|')
ylabel('AMI1')
hold on
scatter(AC_features,AMI_features, '.')
xlabel('|AC1|')
ylabel('AMI1')
tol = max(abs(polyval(p, AC_features) - AMI_features))