clear
close all




rstart = 3.57;
rend = 4;
rstep = 0.001;
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

AC1_matrix_abs = NaN(num_A,1);
AMI1_matrix = NaN(num_A,1);

step_AC = 1;
step_AMI = 1;

for i=1:num_A
    AC1_matrix_abs(i) = abs(CO_AutoCorr(logistic_series(i,:)', 2, AC_using_method));
    AMI1_matrix(i) = IN_AutoMutualInfo(logistic_series(i,:)', 2, AMI_using_method);
end



useful_range = logistic_LE > 0;
useful_AC1 = AC1_matrix_abs(useful_range);
useful_AMI1 = AMI1_matrix(useful_range);



useful_LE = logistic_LE(useful_range);



AMImean = NaN(length(useful_LE), 1);
AMIstd = NaN(length(useful_LE), 1);
tStart = tic;
TT = [];




load('AMI2_29700.mat')
load('AC_29700.mat')
n_bins = 250;
AC2_matrix = abs(AC(:,3));
binnedAMI = AMI_in_bins(AC2_matrix,AMI2_matrix,n_bins);
mu = NaN(n_bins, 1);
sigma = NaN(n_bins, 1);
mu_CI = NaN(n_bins, 2);
sigma_CI = NaN(n_bins, 2);
for i = 1:n_bins
    bin = binnedAMI{i};
    [mu(i), sigma(i), mu_CI(i,:), sigma_CI(i,:)] = normfit(bin);
end
[N, binedges] = histcounts(AC2_matrix, n_bins);
bincenters = binedges(1:end-1) + diff(binedges)/2;

for i=1:length(useful_LE)
    current_AC = useful_AC1(i);
    tic;
    for j = 1:n_bins
        if current_AC >= binedges(j) && current_AC < binedges(j+1)
            AMImean(i) = mu(j);
            AMIstd(i) = sigma(j);
            break
        end
    end
    TT = [TT toc];
    if mod(i, 10) == 0
        disp(['i = ', num2str(i), ' time = ', num2str(sum(TT))]);
    end
end

AMI_distance = abs(useful_AMI1 - AMImean)./AMIstd;

tEnd = toc(tStart);
disp(['total time = ', num2str(tEnd)]);



figure;
scatter(a_logisitic(useful_range), AMI_distance, '.');
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
xlabel('AC2');
ylabel('AMI2');
title('filtered out for LE < 0');
legend('logistic', 'AR');

figure
errorbar(useful_AC1, AMImean, AMIstd, 'r.');
xlabel('AC2');
ylabel('AMI2');
title('filtered out for LE < 0');
legend('logistic', 'AR');

