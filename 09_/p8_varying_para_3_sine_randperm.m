clear
close all

num_segments = 100;
series_length = 1000;
eta = 100;
total_length = num_segments*series_length;
a_sine = linspace(1,8,num_segments);
a_sine = a_sine(randperm(num_segments));
result_series = [];
for i = 1:num_segments
    result_series = [result_series; MkSg_Map('sine', series_length, 1/sqrt(2), a_sine(i), eta);];
end

figure
plot(result_series)
xlabel('t')
ylabel('x')


figure
plot_distribution(result_series)
grid on
title('100 segments of 1000 points each')


windows = [10,20,50,100,200,500,1000];
num_windows = length(windows);
AC1_cell = {};
AMI1_cell = {};
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

for i = 1:num_windows
    w = windows(i);
    AC1_vector = NaN(w,1);
    AMI1_vector = NaN(w,1);
    for j = 1:w
        current_window = result_series((j-1)*total_length/w+1:j*total_length/w);
        AC1_vector(j) = abs(CO_AutoCorr(current_window, 1, AC_using_method));
        AMI1_vector(j) = abs(IN_AutoMutualInfo(current_window, 1, AMI_using_method));
    end
    AC1_cell{i} = AC1_vector;
    AMI1_cell{i} = AMI1_vector;
end


rhos = [];
for i = 1:num_windows
    xx = AC1_cell{i};
    yy = AMI1_cell{i};
    [RHO,PVAL] = corr(xx,yy,'Type','Spearman');
    rhos = [rhos; RHO];
end

figure('Renderer', 'painters', 'Position', [10 10 1600 530])
for i = 1:num_windows
    subplot(2,4,i)
    scatter(AC1_cell{i}, AMI1_cell{i}, '.')
    hold on
    grid on
    title(sprintf('w = %d, RHO = %.4f', windows(i), rhos(i)))
    xlabel('|AC1|')
    ylabel('|AMI1|')    
end
