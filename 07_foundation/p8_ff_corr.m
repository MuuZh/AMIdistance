clear
close all

% addpath('/Users/muuzh/Documents/catch22-0.4.0/wrap_Matlab');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
series_length = 20000;
k = 2000;
num_A = 50;
num_series = 20;
num_series = 1;




% TENT MAP
% creat a num_A*series_length NaN matrix
series_tent = NaN(num_series, series_length);
As = linspace(1.0001, 1.9999, num_A);
A = As(45);
% generate sereies with varing a
for i = 1:num_series
    series_tent(i, :) = MkSg_Map('tent', series_length, 1/sqrt(2), A, k);
end


% LOGISTIC MAP
% creat a num_A*series_length NaN matrix
series_logistic = NaN(num_series, series_length);
As = linspace(3.57, 4, num_A);
A = As(45);
% generate sereies with varing a
for i = 1:num_series
    series_logistic(i, :) = MkSg_Map('logistic', series_length, 0.1, A, k);
end

series_matrix = [series_tent; series_logistic];

% compute AC/AM fetures for the long series
longACfeatures = NaN(2,1);
longAMfeatures = NaN(2,1);


AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

for rownum = 1:2
    longACfeatures(rownum) = CO_AutoCorr(series_matrix(rownum,:)',1, AC_using_method);
    longAMfeatures(rownum) = IN_AutoMutualInfo(series_matrix(rownum,:)', 1, AMI_using_method);
end
ARpart_mean = [];
ARpart_std = [];
tentpart_mean = [];
tentpart_std = [];

possible_w = [5 10 20 25 32 40 50 80 100 125 160 200 250 400 500 625 800 1000 1250 2000];
ffcorrs_at_window = {};
idx = 1;
% compute AC features for each row
for window_num = possible_w

    window_length = 20000/window_num;
    ACfeatures = NaN(2,window_num);
    AMfeatures = NaN(2,window_num);
    for rownum = 1:2
        current_long_row = series_matrix(rownum,:);
        rownum
        for colnum = 1:window_num
            current_short_row = current_long_row(1+(colnum-1)*window_length:colnum*window_length);
            ACfeatures(rownum, colnum) = CO_AutoCorr(current_short_row', 1, AC_using_method);
            AMfeatures(rownum, colnum) = IN_AutoMutualInfo(current_short_row', 1, AMI_using_method);
        end
    end
    ffcorrs = NaN(2,1);
    xdata = ACfeatures;
    ydata = AMfeatures;
    for rownum = 1:2
        ffcorrs(rownum) = corr(xdata(rownum, :)', ydata(rownum, :)');
    end
    ffcorrs_at_window{idx} = ffcorrs;
    idx = idx+1;
    % figure
    % imagesc(ffcorrs)
    % title(sprintf("f-f correlations with %d windows, each length %d" , window_num, window_length))
    % ylabel("each long time series")
    % xlabel("each short piece")
    % colorbar


    ARpart_mean = [ARpart_mean mean(ffcorrs(1))];

    tentpart_mean = [tentpart_mean mean(ffcorrs(2))];

end


% save('computedwindows.mat', 'ffcorrs_at_window');

rawtop_mean = mean(longAMfeatures(1));

rawbot_mean = mean(longAMfeatures(2));

figure
plot(possible_w, ARpart_mean)
hold on
plot(possible_w, tentpart_mean)
plot(possible_w, abs(ARpart_mean - tentpart_mean))

xlabel("window numbers")
ylabel("means")

legend('tnet part', 'logistic part', 'difference')
rawtop_mean
rawbot_mean
