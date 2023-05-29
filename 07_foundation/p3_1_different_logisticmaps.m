clear
close all

% see how A affects the formation of logistic map
% 1 < A < 3 case
% lowerA = 1;
% upperA = 3;
% series_length = 1000;
% series_num = 100;
% As = linspace(lowerA,upperA,series_num);
% ts_matrix = NaN(series_num, series_length);
% figure
% for i = 1:series_num
%     ts_matrix(i,:) = gen_logistic(series_length, 0, As(i), 0);
%     plot_distribution(ts_matrix(i,:))
%     title(['A = ', num2str(As(i))])
%     pause(0.1)
%     save2gif('logistic_A_1to3.gif',i);
% end

% see how it converges

A = 4;
ts = gen_logistic(1000, 0, A, 0);
num_points = 100; % number of points to plot
pause_time = 0.07; % time to pause between each plot
pause_time = 0.03;

% plot_map_process_logistic(ts, A, num_points, pause_time);
% close 
save_map_process(ts, A, num_points, pause_time, 'logistic_A_4.gif');
% 
% roots_p = (A + 1 + sqrt((A-3)*(A+1)))/(2*A)
% roots_n = (A + 1 - sqrt((A-3)*(A+1)))/(2*A)


