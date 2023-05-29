clear
close all




rstart = 3.57;
rend = 4;
rstep = 0.0005;
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

% compute AR and AMI fetures for each sample
max_lag = 4;
lags = 1:1:max_lag;
AC_lag = {};
AMI_lag = {};

for j = 1:length(lags)
    AC_matrix_abs = NaN(num_A,1);
    AMI_matrix = NaN(num_A,1);

    step_AC = lags(j);
    step_AMI = lags(j);

    for i=1:num_A
        AC_matrix_abs(i) = abs(CO_AutoCorr(logistic_series(i,:)', 1, AC_using_method));
        AMI_matrix(i) = IN_AutoMutualInfo(logistic_series(i,:)', step_AMI, AMI_using_method);
    end
    AC_lag{j} = AC_matrix_abs;
    AMI_lag{j} = AMI_matrix;
end

% figure;
% plot(rstart:rstep:rend, logistic_LE);
% hold on
% % plot line y = 0
% plot([rstart rend], [0 0], '--');
% xlim([rstart rend]);
% xlabel('r');
% ylabel('Lyapunov Exponent');
% title('Lyapunov Exponent of Logistic Map');


useful_range = logistic_LE > 0;

% figure('Position', [100, 100, 1600, 1200])
% for i=1:max_lag
%     AC1
%     useful_AC1 = AC1_matrix_abs(useful_range);
%     useful_AMI1 = AMI1_matrix(useful_range);
%     % make a poper size of figer that can contain 2 plots
%     subplot(2,1,1);
%     scatter(AC1_matrix_abs, AMI1_matrix, '.');
%     xlabel('AC1');
%     ylabel('AMI1');
%     title('All samples');
%     subplot(2,1,2);
%     scatter(useful_AC1, useful_AMI1, '.');
%     xlabel('AC1');
%     ylabel('AMI1');
%     title('filtered out for LE < 0');
% end



useful_LE = logistic_LE(useful_range);
% figure('Position', [100, 100, 1600, 450])
% for i = 1:length(lags)
%     AC_matrix_abs = AC_lag{i};
%     useful_AC = AC_matrix_abs(useful_range);
%     subplot(1,length(lags),i);
%     scatter(useful_LE, useful_AC, '.');
%     xlabel('Lyapunov Exponent');
%     ylabel(sprintf('AC%d', lags(i)));
% end

% figure('Position', [100, 100, 1600, 450])
% for i = 1:length(lags)
%     AMI_matrix = AMI_lag{i};
%     useful_AMI = AMI_matrix(useful_range);
%     subplot(1,length(lags),i);
%     scatter(useful_LE, useful_AMI, '.');
%     xlabel('Lyapunov Exponent');
%     ylabel(sprintf('AMI%d', lags(i)));
% end

distance_lag = {};
ARAMI_lag = {};
for j=1:length(lags)
    ARAMI = NaN(1,num_A);
    AMI_distance = NaN(1,num_A);
    AC_matrix_abs = AC_lag{j};
    AMI1_matrix = AMI_lag{j};
    for i=1:num_A
        current_AC = AC_matrix_abs(i);
        ARfortheAC = MkSg_AR(series_length, current_AC, eta);
        ARAMI(i) = IN_AutoMutualInfo(ARfortheAC, lags(j), AMI_using_method);
        AMI_distance(i) = abs(AMI1_matrix(i) - ARAMI(i));
    end
    distance_lag{j} = AMI_distance;
    ARAMI_lag{j} = ARAMI;
end


figure('Position', [100, 100, 1600, 450])
for i=1:length(lags)
    subplot(1,length(lags),i);
    AMI_distance = distance_lag{i};
    scatter(a_logisitic(useful_range), AMI_distance(useful_range), '.');
    xlabel('r');
    ylabel('AMI distance');
end
figure('Position', [100, 100, 1800, 450])
for i=1:length(lags)
    subplot(1,length(lags),i);
    AMI_distance = distance_lag{i};
    c = linspace(rstart,rend,length(useful_LE));
    scatter(useful_LE, AMI_distance(useful_range), [],c);   
    colorbar
    cb = colorbar;
    xlabel('Lyapunov Exponent');
    ylabel('AMI distance');
    ylabel(cb, "r")
end

