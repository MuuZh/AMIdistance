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
map_params{end+1} = a_tent_w_noise;
map_params{end+1} = a_large_sine;

% add measurement noise
mNoise_levle = 0.00001;
for i = 1:length(series_cell)
    if i ~= 4 % Do not add noise to AR map
        series_cell{i} = series_cell{i} + mNoise_levle * randn(size(series_cell{i}));
    end
end
% series_cell = series_cell(1:2);
num_maps = length(series_cell);
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute AR and AMI fetures for each sample
AC1_matrix = NaN(num_maps, num_A);
AC1_matrix_abs = NaN(num_maps, num_A);
AC1_matrix_surro_abs = NaN(num_maps, num_A);
AMI1_matrix = NaN(num_maps, num_A);
AMI1_matrix_abs = NaN(num_maps, num_A);
AMI1_matrix_surro = NaN(num_maps, num_A);


totalt = 0;
step_AC = 1;
step_AMI = 1;
for i = 1:num_maps
    tic;
        for j = 1:num_A
            temp = series_cell{i}(j, :)';
            temp_surro = generate_surrogate_iaaft(temp,verbose=false);
            AC1_matrix_abs(i, j) = abs(CO_AutoCorr(temp, step_AC, AC_using_method));
            AMI1_matrix(i, j) = IN_AutoMutualInfo(temp, step_AMI, AMI_using_method);
            AC1_matrix_surro_abs(i, j) = abs(CO_AutoCorr(temp_surro, step_AC, AC_using_method));
            AMI1_matrix_surro(i, j) = IN_AutoMutualInfo(temp_surro, step_AMI, AMI_using_method);
        end
    t2 = toc;
    totalt = totalt + t2;
    if i == num_maps
        fprintf("Processing No. %d map, time used for this a: %.3fs, total time used: %.3fs\n", i, t2, totalt)
    else
        fprintf("Processing No. %d map, time used for this a: %.3fs\n", i, t2)
    end
end

% p = [3470378.44825176	-24953902.5367082	80805902.1690628	-155709477.765235	198761818.670307	-177057799.050891	112952509.521355	-52116433.5853588	17353712.2141604	-4113814.85965617	675958.230742955	-73601.9802550120	4927.31505504605	-176.724474158128	2.54583402316481	-0.00363638820213637];
% tol = 0.1234*3;
map_legends = {"sine", "logistic", "tent" , "AR", "tent w noise", "sine periods"};
AC1_AR = AC1_matrix_abs(4,:);
AMI1_AR = AMI1_matrix(4,:);
dist = NaN(length(series_cell), num_A);
for i=1:length(series_cell)
    current_map_name = map_legends{i};
    % compute distance between original and surrogate for each point
    for j=1:num_A
        dist(i,j) = sqrt((AC1_matrix_abs(i, j) - AC1_matrix_surro_abs(i, j))^2 + (AMI1_matrix(i, j) - AMI1_matrix_surro(i, j))^2);
    end
    % print out the distance
    % fprintf("average distance for %-12s: %.4f\n", current_map_name, mean(dist(i,:)))
    % fprintf("average shift on AC1 for %-12s: %.4f\n", current_map_name, mean(abs((AC1_matrix_abs(i, j) - AC1_matrix_surro_abs(i, j)))))
    fprintf("average shift on AMI1 for %-12s: %.4f\n", current_map_name, mean(abs((AMI1_matrix(i, j) - AMI1_matrix_surro(i, j)))))

end




