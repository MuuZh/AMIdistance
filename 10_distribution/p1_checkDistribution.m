clear
close all

series_length = 2000;
eta = 200;
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
step_AC = 1;
step_AMI = 1;


num_A = 2000;
series_AR = NaN(num_A, series_length);
a = 0.9;
for i = 1:num_A
    series_AR(i, :) = MkSg_AR(series_length, a, eta);
end


AC1_matrix_abs = NaN(num_A, 1);
AMI1_matrix = NaN(num_A, 1);



for i = 1:num_A
    temp = series_AR(i, :);
    
    AC1_matrix_abs(i) = abs(CO_AutoCorr(temp, step_AC, AC_using_method));
    AMI1_matrix(i) = IN_AutoMutualInfo(temp', step_AMI, AMI_using_method);
end

% a horizontal figure, two plots in
figure('Position', [100, 100, 3200, 900])
subplot(2, 3, 1)
histogram(AC1_matrix_abs,50);
title("|AC1| histogram")

subplot(2, 3, 2)
qqplot(AC1_matrix_abs)
grid on 
title("|AC1| qqplot")

subplot(2, 3, 3)
pd = fitdist(AC1_matrix_abs, 'Normal');
ci = paramci(pd);
probplot(AC1_matrix_abs);
grid on

h = probplot(gca, @(a,x,y)normcdf(a,x,y), [ci(1,1), ci(1,2)]);
set(h, 'color', 'r', 'linestyle', '-')

t = probplot(gca, @(a,x,y)normcdf(a,x,y), [ci(2,1), ci(2,2)]);
set(t, 'color', 'g', 'linestyle', '-')
title("|AC1| probplot with 95% confidence interval")


subplot(2, 3, 4)
histogram(AMI1_matrix,50);
title("AMI1 histogram")

subplot(2, 3, 5)
qqplot(AMI1_matrix)
grid on
title("AMI1 qqplot")

subplot(2, 3, 6)
pd = fitdist(AMI1_matrix, 'Normal');
ci = paramci(pd);
probplot(AMI1_matrix);
grid on

h = probplot(gca, @(a,x,y)normcdf(a,x,y), [ci(1,1), ci(1,2)]);
set(h, 'color', 'r', 'linestyle', '-')

t = probplot(gca, @(a,x,y)normcdf(a,x,y), [ci(2,1), ci(2,2)]);
set(t, 'color', 'g', 'linestyle', '-')
title("AMI1 probplot with 95% confidence interval")
sgtitle(sprintf("%d series with a = %.3f", num_A, a))



figure
qqplot(AC1_matrix_abs, AMI1_matrix)
grid on
title("qqplot for AC1 and AMI1")