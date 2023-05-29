clear
close all

num_A = 250;
a_AR = linspace(0, 1, num_A);
a_sine = linspace(0.88, 1, num_A);
a_logisitic = linspace(3.57, 4, num_A);
a_tent = linspace(1.0001, 1.9999, num_A);

initial_sine = 1/sqrt(2);
initial_logistic = 1/sqrt(2);
initial_tent = 0.1;

series_length = 2000;
eta = 200;

map_names = {'sine', 'logistic', 'tent'};
map_params = {a_sine, a_logisitic, a_tent};
map_inits = {initial_sine, initial_logistic, initial_tent};
series_cell = gen_maps(map_names, series_length, map_params,map_inits, eta);

num_maps = length(map_names);
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute AR and AMI fetures for each sample
AC1_matrix = NaN(num_maps, num_A);
AC1_matrix_abs = NaN(num_maps, num_A);
AMI1_matrix = NaN(num_maps, num_A);
AMI1_matrix_abs = NaN(num_maps, num_A);

totalt = 0;
step_AC = 1;
step_AMI = 1;
for i = 1:num_maps
    tic;
        for j = 1:num_A
            AC1_matrix(i, j) = CO_AutoCorr(series_cell{i}(j, :)', step_AC, AC_using_method);
            AC1_matrix_abs(i, j) = abs(AC1_matrix(i, j));
            AMI1_matrix(i, j) = IN_AutoMutualInfo(series_cell{i}(j, :)', step_AMI, AMI_using_method);
            AMI1_matrix_abs(i, j) = abs(AMI1_matrix(i, j));
        end
    t2 = toc;
    totalt = totalt + t2;
    if i == num_maps
        fprintf("Processing %s map, time used for this a: %.3fs, total time used: %.3fs\n", map_names{i}, t2, totalt)
    else
        fprintf("Processing %s map, time used for this a: %.3fs\n", map_names{i}, t2)
    end
end


figure
for i=1:num_maps
    scatter(AC1_matrix_abs(i, :), AMI1_matrix(i, :) ,'.');
    hold on
    grid on
end
legend(map_names)
legend('Location','southeast');
legend('FontSize', 14)
xlabel('|AC1|')
ylabel('AMI1')
title('AMI1 vs AC1 correlation')




