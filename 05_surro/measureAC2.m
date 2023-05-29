clear
close all

addpath('/Users/muuzh/Documents/catch22-0.4.0/wrap_Matlab');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data
% series_matrix = load('data/long_linear_and_nonlinear_40_v2.txt');
load('data/surr_1.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
window_num = 200;
window_length = 20000/window_num;

% compute AC/AM fetures for the long series
longACfeatures = NaN(40,1);
longAMfeatures = NaN(40,1);


AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

for rownum = 1:40
    longACfeatures(rownum) = CO_AutoCorr(series_matrix(rownum,:)',1, AC_using_method);
    longAMfeatures(rownum) = CO_AutoCorr(series_matrix(rownum,:)',2, AC_using_method);
end

% compute AC features for each row
ACfeatures = NaN(40,window_num);
AMfeatures = NaN(40,window_num);

for rownum = 1:40
    current_long_row = series_matrix(rownum,:);
    for colnum = 1:window_num
        current_short_row = current_long_row(1+(colnum-1)*window_length:colnum*window_length);
        ACfeatures(rownum, colnum) = CO_AutoCorr(current_short_row', 1, AC_using_method);
        AMfeatures(rownum, colnum) = CO_AutoCorr(current_short_row', 2, AC_using_method);
    end
end


% save('ACAM_nl_computed.mat', 'longACfeatures', 'longAMfeatures', 'ACfeatures', 'AMfeatures');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % plot the features
imagesc([longACfeatures longAMfeatures])
title("raw AC and AM")
ylabel("first 20 rows: tent; last 20 rows: surrogate tent")
xlabel("left: raw AC1 features; right: raw AC2 fetures")

colorbar

figure
imagesc(ACfeatures)
title("AC1 features on windows")
% ylabel("each long time series")
xlabel("feature value at each window")
colorbar
figure
imagesc(AMfeatures)
title("AC2 features on windows")
% ylabel("each long time series")
xlabel("feature value at each window")
colorbar

ffcorrs = NaN(40,1);
xdata = ACfeatures;
ydata = AMfeatures;
for rownum = 1:40
    ffcorrs(rownum) = corr(xdata(rownum, :)', ydata(rownum, :)');
end
figure
imagesc(ffcorrs)
title("f-f correlations")
ylabel("each long time series")
xlabel("each short piece")
colorbar

rawtop_mean = mean(longAMfeatures(1:20));
rawtop_std = std(longAMfeatures(1:20));


rawbot_mean = mean(longAMfeatures(21:40));
rawbot_std = std(longAMfeatures(21:40));

fftop_mean = mean(ffcorrs(1:20));
fftop_std = std(ffcorrs(1:20));

ffbot_mean = mean(ffcorrs(21:40));
ffbot_std = std(ffcorrs(21:40));

sprintf("raw features: %f +- %f  and %f +- %f", rawtop_mean, rawtop_std, rawbot_mean, rawbot_std)
sprintf("ff corelation : %f +- %f  and %f +- %f", fftop_mean, fftop_std, ffbot_mean, ffbot_std)

for i = 1:40
    cm = mean(ACfeatures(i,:));
    dstd = std(ACfeatures(i,:));
    sprintf("AC1 cut into windows: %f +- %f", cm, dstd)
end