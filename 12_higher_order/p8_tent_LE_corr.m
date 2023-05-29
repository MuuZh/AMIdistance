clear
close all




rstart = 1.0001;
rend = 1.9999;
rstep = 0.02;
tent_LE = LEofTentMap(rstart, rend, rstep);

num_A = length(tent_LE);
series_length = 2000;
eta = 200;
a_tent = linspace(rstart, rend, num_A);
initial_tent = 0.1;

tent_series = NaN (num_A, series_length);
for i=1:num_A
    tent_series(i,:) = MkSg_Map('tent', series_length, initial_tent ,a_tent(i), eta);
end
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute AR and AMI fetures for each sample
AC1_matrix_abs = NaN(num_A,1);
AMI1_matrix = NaN(num_A,1);

step_AC = 1;
step_AMI = 1;

for i=1:num_A
    AC1_matrix_abs(i) = abs(CO_AutoCorr(tent_series(i,:)', step_AC, AC_using_method));
    AMI1_matrix(i) = IN_AutoMutualInfo(tent_series(i,:)', step_AMI, AMI_using_method);
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

useful_range = tent_LE > 0;
useful_AC1 = AC1_matrix_abs(useful_range);
useful_AMI1 = AMI1_matrix(useful_range);
% make a poper size of figer that can contain 2 plots
% figure('Position', [100, 100, 800, 600])
% subplot(2,1,1);
% scatter(AC1_matrix_abs, AMI1_matrix, '.');
% xlabel('AC1');
% ylabel('AMI1');
% title('All samples');
% subplot(2,1,2);
% scatter(useful_AC1, useful_AMI1, '.');
% xlabel('AC1');
% ylabel('AMI1');
% title('filtered out for LE < 0');


useful_LE = tent_LE(useful_range);
% figure('Position', [100, 100, 1200, 600])
% subplot(1,2,1);
% scatter(useful_LE, useful_AC1, '.');
% xlabel('Lyapunov Exponent');
% ylabel('AC1');
% subplot(1,2,2);
% scatter(useful_LE, useful_AMI1, '.');
% xlabel('Lyapunov Exponent');
% ylabel('AMI1'); 


AMImean = NaN(length(useful_LE), 1);
AMIstd = NaN(length(useful_LE), 1);
tStart = tic;
TT = [];


for i=1:length(useful_LE)
    current_AC = useful_AC1(i);
    tic;     
    [AMImean(i), AMIstd(i)] = p1_GetAMI_MeanStd(current_AC, 100, series_length, eta);
    TT = [TT toc];
    if mod(i, 10) == 0
        disp(['i = ', num2str(i), ' time = ', num2str(sum(TT))]);
    end
end

AMI_distance = abs(useful_AMI1 - AMImean)./AMIstd;

tEnd = toc(tStart);
disp(['total time = ', num2str(tEnd)]);



figure;
scatter(a_tent(useful_range), AMI_distance, '.');
xlabel('r');
ylabel('AMI distance');
figure
c = linspace(rstart,rend,length(useful_LE));
scatter(useful_LE, AMI_distance, 10, c ,'filled');   
colorbar
cb = colorbar;
xlabel('Lyapunov Exponent');
ylabel('AMI distance (normalized by std)');
ylabel(cb, "r")


figure
scatter(useful_AC1, useful_AMI1, '.');
hold on
errorbar(useful_AC1, AMImean, AMIstd, 'r.');
xlabel('AC1');
ylabel('AMI1');
title('filtered out for LE < 0');
legend('tent', 'AR');