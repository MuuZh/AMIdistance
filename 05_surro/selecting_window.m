clear
close all

% addpath('/Users/muuzh/Documents/catch22-0.4.0/wrap_Matlab');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data
load('data/surr_1.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% compute AC/AM fetures for the long series
longACfeatures = NaN(40,1);
longAMfeatures = NaN(40,1);


AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

for rownum = 1:40
    longACfeatures(rownum) = CO_AutoCorr(series_matrix(rownum,:)',1, AC_using_method);
    longAMfeatures(rownum) = CO_AutoCorr(series_matrix(rownum,:)',2, AC_using_method);;
end
ARpart_mean = [];
ARpart_std = [];
tentpart_mean = [];
tentpart_std = [];

possible_w = [5 10 20 40 50 80 100 200 250 400 500 625 800 1000];
ffcorrs_at_window = {};

dataCelltop20 = {};
dataCellbot20 = {};
% compute AC features for each row
for i = 1:length(possible_w)
    window_num = possible_w(i);
    window_length = 20000/window_num;
    ACfeatures = NaN(40,window_num);
    AMfeatures = NaN(40,window_num);
    for rownum = 1:40
        current_long_row = series_matrix(rownum,:);
        rownum
        for colnum = 1:window_num
            current_short_row = current_long_row(1+(colnum-1)*window_length:colnum*window_length);
            ACfeatures(rownum, colnum) = CO_AutoCorr(current_short_row', 1, AC_using_method);
            AMfeatures(rownum, colnum) = CO_AutoCorr(current_short_row', 2, AC_using_method);
        end

    end
    ffcorrs = NaN(40,1);
    xdata = ACfeatures;
    ydata = AMfeatures;
    for rownum = 1:40
        ffcorrs(rownum) = corr(xdata(rownum, :)', ydata(rownum, :)');
    end
    ffcorrs_at_window{i} = ffcorrs;
    dataCelltop20{i} = ffcorrs(1:20);
    dataCellbot20{i} = ffcorrs(21:40);
    % figure
    % imagesc(ffcorrs)
    % title(sprintf("f-f correlations with %d windows, each length %d" , window_num, window_length))
    % ylabel("each long time series")
    % xlabel("each short piece")
    % colorbar


    ARpart_mean = [ARpart_mean mean(ffcorrs(1:20))];
    ARpart_std = [ARpart_std std(ffcorrs(1:20))];

    tentpart_mean = [tentpart_mean mean(ffcorrs(21:40))];
    tentpart_std = [tentpart_std std(ffcorrs(21:40))];

end


% save('computedwindows.mat', 'ffcorrs_at_window');
% figure
% for i = 1:length(possible_w)
%     current_windownumk = possible_w(i);
%     dtop = {dataCelltop20{i}};
%     BF_ViolinPlot(dtop,true,true,0,struct('customOffset',current_windownumk/100))
% end
BF_ViolinPlot(dataCelltop20,true,true,true);
BF_ViolinPlot(dataCellbot20,true,true,0);
plot(1:length(possible_w), ARpart_mean)
plot(1:length(possible_w), tentpart_mean)
plot(1:length(possible_w), ARpart_mean - tentpart_mean)
% legend('AR1 part mean', 'AR2 part mean', 'difference')
BF_ViolinPlot({longACfeatures(1:20)},true,true,0,struct('customOffset', 16));
BF_ViolinPlot({[],longACfeatures(21:40)},true,true,0,struct('customOffset', 15));

BF_ViolinPlot({longAMfeatures(1:20)},true,true,0,struct('customOffset', 17));
BF_ViolinPlot({[],longAMfeatures(21:40)},true,true,0,struct('customOffset', 16));



rawtop_mean = mean(longAMfeatures(1:20));
rawtop_std = std(longAMfeatures(1:20));


rawbot_mean = mean(longAMfeatures(21:40));
rawbot_std = std(longAMfeatures(21:40));



figure
errorbar(possible_w, ARpart_mean, ARpart_std)
hold on
errorbar(possible_w, tentpart_mean, tentpart_std)
plot(possible_w, ARpart_mean - tentpart_mean)

xlabel("window numbers")
ylabel("means")

legend('tent part mean', 'surrgate part mean', 'difference')