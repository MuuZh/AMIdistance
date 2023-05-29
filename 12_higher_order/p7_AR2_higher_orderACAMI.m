clear
close all

% test for AR2
% set parameters
a_num = 200;

series_length = 2000;
eta = 200;

ARmatrix = NaN(a_num, series_length);

% random number from -1 to 1
lag1_a = rand(a_num,1)*2-1;
lag2_a = rand(a_num,1)*2-1;

lag1_a = sort(lag1_a);
lag2_a = sort(lag2_a);
filter1 = lag2_a + lag1_a < 1;
lag1_a = lag1_a(filter1);
lag2_a = lag2_a(filter1);
filter2 = lag2_a - lag1_a < 1;
lag1_a = lag1_a(filter2);
lag2_a = lag2_a(filter2);


tStart = tic;
TT = [];
% sample all lag1 and lag2
for i = 1:length(lag1_a)
    for j = 1:length(lag2_a)
        ARmatrix(i,j,:) = MkSg_AR(series_length,[lag2_a(j), lag1_a(i)]', eta);
    end
    TT = [TT toc];
    if mod(i, 50) == 0
        disp(['i = ', num2str(i), ' time = ', num2str(sum(TT))]);
    end
end
tEnd = toc(tStart);
disp(['total time = ', num2str(tEnd)]);

AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

lags = 1:4;


% AC_matrix = NaN(length(lags),a_num);
AMI_matrix = NaN(length(lags),a_num);

tStart = tic;
TT = [];
for lag = lags
    tic;
    for i = 1:a_num
        % AC_matrix(lag,i) = (CO_AutoCorr(ARmatrix(i,:)', lag, AC_using_method));
        % AC_matrix(lag,i) = corr(ARmatrix(i,1:end-lag)', ARmatrix(i,1+lag:end)');
        AMI_matrix(lag,i) = IN_AutoMutualInfo(ARmatrix(i,:)', lag, AMI_using_method);
    end
    TT = [TT toc];
    disp(['lag = ', num2str(lag), ' time = ', num2str(sum(TT))]);
end
tEnd = toc(tStart);
disp(['total time = ', num2str(tEnd)]);

% figure('Position', [100, 100, 1800, 1600])
% for lag = 1:length(lags)
%     subplot(3,4,lag)
%     scatter(AC_matrix(lag,:), AMI_matrix(lag,:), 10 ,'filled')
%     grid on
%     xlabel(sprintf("AC%d", lag))
%     ylabel(sprintf("AMI%d", lag))
% end
% sgtitle('AC-AMI correlation for AR1 process')

% alternative method
AC_matrix = NaN(length(lags),a_num);
PAC_matrix = NaN(length(lags),a_num);
for i = 1:a_num
    [acf,acflags] = autocorr(ARmatrix(i,:), NumLags=10);
    [pacf,pacflags] = parcorr(ARmatrix(i,:), NumLags=10);

    AC_matrix(acflags(2:end),i) = acf(2:end);
    PAC_matrix(pacflags(2:end),i) = pacf(2:end);
end
figure('Position', [100, 100, 1800, 1600])
for lag = 1:length(lags)
    subplot(3,4,lag)
    scatter(AC_matrix(lag,:), AMI_matrix(lag,:), 10 ,'filled')
    grid on
    xlabel(sprintf("AC%d", lag))
    ylabel(sprintf("AMI%d", lag))
end
sgtitle('AC-AMI correlation for AR1 process')

figure('Position', [100, 100, 1800, 1600])
for lag = 1:length(lags)
    subplot(3,4,lag)
    scatter(PAC_matrix(lag,:), AMI_matrix(lag,:), 10 ,'filled')
    grid on
    xlabel(sprintf("PAC%d", lag))
    ylabel(sprintf("AMI%d", lag))
end
sgtitle('PAC-AMI correlation for AR1 process')
