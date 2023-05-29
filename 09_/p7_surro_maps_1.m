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

map_names = {'sine', 'logistic', 'tent' , 'AR'};
map_params = {a_sine, a_logisitic, a_tent, a_AR};
map_inits = {initial_sine, initial_logistic, initial_tent, NaN};


series_cell = gen_maps(map_names, series_length, map_params,map_inits, eta);



noise_level = 0.01;
tent_w_noise = NaN(num_A, series_length);
a_tent_w_noise = linspace(1.00001, 8, num_A);
for i = 1:num_A
    tent_w_noise(i, :) = gen_tent_p(series_length, eta, a_tent_w_noise(i), initial_tent, noise_level);
end

large_sine = NaN(num_A, series_length);
a_large_sine = linspace(1, 10, num_A);
for i=1:num_A
    large_sine(i, :) = MkSg_Map('sine', series_length, initial_sine ,a_large_sine(i), eta);
end


series_cell{end+1} = tent_w_noise;
series_cell{end+1} = large_sine;


num_maps = length(series_cell);
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
            temp = series_cell{i}(j, :)';
            temp_surro = generate_surrogate_iaaft(temp);
            AC1_matrix(i, j) = CO_AutoCorr(temp_surro, step_AC, AC_using_method);
            AC1_matrix_abs(i, j) = abs(AC1_matrix(i, j));
            AMI1_matrix(i, j) = IN_AutoMutualInfo(temp_surro, step_AMI, AMI_using_method);
            AMI1_matrix_abs(i, j) = abs(AMI1_matrix(i, j));
        end
    t2 = toc;
    totalt = totalt + t2;
    if i == num_maps
        fprintf("Processing No. %d map, time used for this a: %.3fs, total time used: %.3fs\n", i, t2, totalt)
    else
        fprintf("Processing No. %d map, time used for this a: %.3fs\n", i, t2)
    end
end


figure
for i=1:num_maps
    scatter(AC1_matrix_abs(i, :), AMI1_matrix_abs(i, :) ,'.');
    hold on
    grid on
end
legend("sine", "logistic", "tent" , "AR", "tent with noise", "sine with more periods")
legend('Location','southeast');
legend('FontSize', 14)
xlabel('|AC1|')
ylabel('|AMI1|')
title('surrogate AMI1 vs AC1 correlation')




