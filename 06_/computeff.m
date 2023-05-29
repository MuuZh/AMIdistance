clear
close all

load("signals_matrix.mat")
rawfeatures_f1 = NaN(2,1);
rawfeatures_f2 = NaN(2,1);
for i = 1:2
    rawfeatures_f1(i) = catch22_CO_f1ecac(totalmatrix(i,:));
    rawfeatures_f2(i) = catch22_CO_HistogramAMI_even_2_5(totalmatrix(i,:));
end

possible_w = [5 8 10 16 20 25 40 50 80 100 125 200 250 500 625 400 500 625];
ARpart_mean = [];
ARpart_std = [];
tentpart_mean = [];
tentpart_std = [];
for i = 1:length(possible_w)
    window_num = possible_w(i);
    window_length = 10000/window_num;
    features_f1 = NaN(2,window_num);
    features_f2 = NaN(2,window_num);
    for rownum = 1:2
        current_long_row = totalmatrix(rownum,:);
        rownum
        for colnum = 1:window_num
            current_short_row = current_long_row(1+(colnum-1)*window_length:colnum*window_length);
            features_f1(rownum, colnum) = catch22_CO_f1ecac(current_short_row);
            features_f2(rownum, colnum) = catch22_CO_HistogramAMI_even_2_5(current_short_row);
        end

    end
    ffcorrs = NaN(2,1);
    xdata = features_f1;
    ydata = features_f2;
    for rownum = 1:2
        ffcorrs(rownum) = corr(xdata(rownum, :)', ydata(rownum, :)');
    end
    ffcorrs_at_window{i} = ffcorrs;

    % figure
    % imagesc(ffcorrs)
    % title(sprintf("f-f correlations with %d windows, each length %d" , window_num, window_length))
    % ylabel("each long time series")
    % xlabel("each short piece")
    % colorbar


    ARpart_mean = [ARpart_mean mean(ffcorrs(1))];


    tentpart_mean = [tentpart_mean mean(ffcorrs(2))];


end

figure
plot(possible_w, ARpart_mean)
hold on
plot(possible_w, tentpart_mean)
% plot(possible_w, ARpart_mean - tentpart_mean)

xlabel("window numbers")
ylabel("means")