clear
close all

series_length = 200;
eta = 200;
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
step_AC = 1;
step_AMI = 1;


num_A = 100000;
series_AR = NaN(num_A, series_length);
a_AR = linspace(0, 1, num_A);

load("computed100k")


% figure
% binscatter(AC1_matrix_abs, AMI1_matrix, [250 100])
% xlabel("AC1")
% ylabel("AMI1")
% title(sprintf("AC1 vs AMI1, %d series", num_A))
% grid on

% n_bins = 250;
% binedAMI = AMI_in_bins(AC1_matrix_abs, AMI1_matrix, n_bins);
% figure
% bin1 = binedAMI{1};
% histogram(bin1, 10)
% x = (bin1 - mean(bin1))/std(bin1);
% h = kstest(x)

% cdfplot(x)
% hold on
% x_values = linspace(min(x),max(x));
% plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')

% n_bins = 30;
% binedAMI = AMI_in_bins(AC1_matrix_abs, AMI1_matrix, n_bins);

% for i = 1:n_bins
%     bin = binedAMI{i};
%     x = (bin - mean(bin))/std(bin);
%     [h,p] = kstest(x);
%     if h == 1
%         fprintf("Bin %d is not normal\n", i)
%     end
% end

binsrange = 5:5:500;
num_reject = zeros(1,length(binsrange));
for i = 1:length(binsrange)
    binedAMI = AMI_in_bins(AC1_matrix_abs, AMI1_matrix, binsrange(i));
    for j = 1:binsrange(i)
        bin = binedAMI{j};
        x = (bin - mean(bin))/std(bin);
        [h,p] = kstest(x);
        if h == 1
            num_reject(i) = num_reject(i) + 1;
        end
    end
end

fraction_reject = num_reject./binsrange;
figure
plot(binsrange, num_reject)
xlabel("Number of bins")
ylabel("Number of bins rejected")
figure
plot(binsrange, fraction_reject)
xlabel("Number of bins")
ylabel("Fraction of bins rejected")