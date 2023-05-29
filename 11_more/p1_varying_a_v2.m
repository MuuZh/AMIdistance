clear
close all

series_length = 2000;
eta = 200;
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
step_AC = 1;
step_AMI = 1;


num_A = 2000; % increace for more samples
series_AR = NaN(num_A, series_length);
a_AR = linspace(0, 1, num_A);

for i = 1:num_A
    series_AR(i, :) = MkSg_AR(series_length, a_AR(i), eta);
end


AC1_matrix_abs = NaN(num_A, 1);
AMI1_matrix = NaN(num_A, 1);

tic
toc
totalt = 0;
current_k = 0;
for i = 1:num_A
    
    temp = series_AR(i, :)';
    if mod(i, 1000) == 0
        tic
        current_k = i;
    end
    AC1_matrix_abs(i) = abs(CO_AutoCorr(temp, step_AC, AC_using_method));
    AMI1_matrix(i) = IN_AutoMutualInfo(temp, step_AMI, AMI_using_method);
    % AMI1_matrix(i) = mi_cont_cont(temp(1:end-1), temp(2:end), 5);
    if mod(i, current_k + 999) == 0
        t2 = toc;
        totalt = totalt + t2;
        fprintf("i = %d, time uesd for this 1000i = %f\n", i, t2)
    end

    if i == num_A
        fprintf("i = %d, total time used = %f\n", i, totalt)
    end
    
end


figure
binscatter(AC1_matrix_abs, AMI1_matrix, [250 100])
xlabel("AC1")
ylabel("AMI1")
title(sprintf("AC1 vs AMI1, %d series", num_A))
grid on