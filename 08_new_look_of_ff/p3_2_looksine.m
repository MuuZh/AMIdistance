clear
close all

% num_A = 10;
% A = linspace(1.0001, 1.9999, num_A);
% series_length = 1000;
% eta = 100;
% series = NaN(num_A, series_length);

% for i = 1:num_A
%     series(i,:) = MkSg_Map('tent', series_length, 1/sqrt(2), A(i), eta);
% end

% figure('Renderer', 'painters', 'Position', [10 10 1200 450])
% for i = 1:num_A
%     subplot(2,5,i)
%     plot_distribution(series(i,:))
%     axis equal
%     title(['A = ' num2str(A(i))])
% end

num_A = 2000;
a = linspace(1, 10, num_A);
series_length = 1000;
eta = 100;
series = NaN(num_A, series_length);

for i = 1:num_A
    series(i,:) = MkSg_Map('sine', series_length, 0.1, a(i), eta);
end
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute AR and AMI fetures for each sample
AC_features = NaN(1,length(a));
AMI_features = NaN(1,length(a));

totalt = 0;
for i = 1:length(a)
    tic;

    AC_features(i) = CO_AutoCorr(series(i, :)',1, AC_using_method);
    AMI_features(i) = IN_AutoMutualInfo(series(i, :)', 1, AMI_using_method);
    % current_series = series_matrix(j, :, i)';
    % x_series = current_series(1:end-1);
    % y_series = current_series(2:end);
    % AMI_features(i, j)  = mi_cont_cont(x_series, y_series, 5);

    t2 = toc;
    totalt = totalt + t2;
    if i == length(a)
        fprintf("Processing A = %.5f, time used for this a: %.3fs, total time used: %.3fs\n", a(i), t2, totalt)
    else
        % fprintf("Processing A = %.5f, time used for this a: %.3fs\n", a(i), t2)
    end
end


plot(a,AC_features, '.')
grid on
title('sine map AC features vs A')
xlabel('A')
ylabel('AC features')
figure
plot(a,AMI_features, '.')
grid on
title(sprintf('sine map AMI features vs A'))
xlabel('A')
ylabel('AMI features')
% perform polyfit to find the relationship between a and AMI features
p = polyfit(a, AMI_features, 1);
p
co = corr(a', AMI_features');
co

figure
A3 = 3.5;
A333 = MkSg_Map('sine', series_length, 1/sqrt(2), A3, eta);
x = A333(1:end-1);
y = A333(2:end);
c = polyfit(x, y, 1);
plot_distribution(A333);
hold on
plot(x, c(1)*x + c(2), 'r', 'LineWidth', 2);
title(sprintf('A=%.4f', A3))




