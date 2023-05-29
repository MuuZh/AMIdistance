clear
close all

% series_length = 1000;
% eta = 200;
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";
step_AC = 1;
step_AMI = 1;


num_A = 150; % number of a and AC1
num_gap_sample = 150;
a_AR = linspace(0, 1, num_A);

load("p4_result")


n_bins = num_A;
mu = NaN(n_bins, 1);
sigma = NaN(n_bins, 1);
mu_CI = NaN(n_bins, 2);
sigma_CI = NaN(n_bins, 2);
for i = 1:n_bins
    bin = AMI1_matrix(i,:);
    [mu(i), sigma(i), mu_CI(i,:), sigma_CI(i,:)] = normfit(bin);
end
bincenters = a_AR;
% series_length = 
map_accept_n = {};
for nlidx = 1:length(nl)
    thisnl = nl(nlidx);

    [AC1_matrix_abs, AMI1_matrix] = p6_get_features(series_length,thisnl);
    CI_curve = NaN(2, num_A);
    for i = 1:num_A
        CI_curve(1,i) = norminv(0.025, mu(i), sigma(i));
        CI_curve(2,i) = norminv(0.975, mu(i), sigma(i));
    end
    % compute height for each AMI1 in each bin
    map_accept = NaN(size(AC1_matrix_abs,1), size(AC1_matrix_abs,2));
    for map_idx = 1:size(AC1_matrix_abs,1)
        temp_AMI1 = AMI1_matrix(map_idx,:);
        temp_AC1 = AC1_matrix_abs(map_idx,:);
        tempAC1_coor = [];
        tempAMI1_coor = [];
        tempAMI1_height_coor = [];
        for pos_idx = 1:size(temp_AMI1,2)
            % tempAC1_coor = [tempAC1_coor ,temp_AC1(pos_idx)];
            current_AMI1 = temp_AMI1(pos_idx);
            % find nearest AC1 that we already have
            [AC1val, AC1idx] = min(abs(a_AR-temp_AC1(pos_idx)));
            if current_AMI1 > CI_curve(1,AC1idx) && current_AMI1 < CI_curve(2,AC1idx)
                map_accept(map_idx, pos_idx) = 1;
            else
                map_accept(map_idx, pos_idx) = 0;
            end

            % nearstAC1 = a_AR(AC1idx);
            % AR1AMI1forthisAC1 = IN_AutoMutualInfo(MkSg_AR(series_length, temp_AC1(pos_idx), eta), step_AMI, AMI_using_method);
            % tempAMI1_height_coor = [tempAMI1_height_coor, normpdf(temp_AMI1(pos_idx), mu(AC1idx), sigma(AC1idx))];

        end
    end
    map_accept_n{nlidx} = map_accept;

   

    % plot curve for each map on the same figure
    % hold on
    % for map_idx = 1:size(map_AMI,2)
    %     temp_map_AMI = map_AMI{map_idx};
    %     scatter3(temp_map_AMI(1,:), temp_map_AMI(2,:), temp_map_AMI(3,:), 5, 'filled')
    % end
    % view(0,90)

    % legend('PDF', '95% CI lower', '95% CI upper', "sine", "logistic", "tent" , "AR", "tent with noise", "sine with more periods")
end

accept_rate = NaN(length(map_accept_n), length(nl));
for i=1:length(map_accept_n)
    thislevel = map_accept_n{i};
    for j=1:size(thislevel,1)
        accept_rate(i,j) = sum(thislevel(j,:))/size(thislevel,2);
    end
end
map_names = {'noise level', 'sine', 'logistic', 'tent' , 'AR', 'tent with noise', 'sine with more periods'};

T = table(nl', accept_rate(:,1), accept_rate(:,2), accept_rate(:,3), accept_rate(:,4), accept_rate(:,5), accept_rate(:,6), 'VariableNames', map_names);

% plot the accept rate for each map
figure

hold on
plot(nl, accept_rate(:,1), 'LineWidth', 2)
plot(nl, accept_rate(:,2), 'LineWidth', 2)
plot(nl, accept_rate(:,3), 'LineWidth', 2)
plot(nl, accept_rate(:,4), 'LineWidth', 2)
plot(nl, accept_rate(:,5), 'LineWidth', 2)
plot(nl, accept_rate(:,6), 'LineWidth', 2)
legend('sine', 'logistic', 'tent' , 'AR', 'tent with noise', 'sine with more periods')