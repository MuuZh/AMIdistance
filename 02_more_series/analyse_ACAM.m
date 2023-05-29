clear
close all


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data
% series_matrix = load('data/long_linear_and_nonlinear_40_v2.txt');
load('data/Ar1-Ar1-v3.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Have a look of how catch22 work for this data
% % compute Euclidean distances with parameter 'seuclidean'
% ed = pdist(featurevecs, 'seuclidean');
% % ed = pdist(featurevecs);
% sqred = squareform(ed);
% imagesc(sqred);
% colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % have a look of the series
% plot(series_matrix(1,:))
% hold on
% plot(series_matrix(21,:))
% figure


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There are 40 (20000-long) series
% here we cut each of them to 10 segments
% so there is a total of 400 (2000-long) series

% using mat2cell to cut the matrix
% rowpara = ones(1,40);
% colpara = ones(1,10)*2000; 
% pieces = mat2cell(series_matrix, rowpara, colpara);

% lag = 1; % using lag 1 to lag 6
% % compute AC/AM fetures for the long series
% longACfeatures = NaN(40,1);
% longAMfeatures = NaN(40,1);
% for rownum = 1:40
%     longACfeatures(rownum) = CO_AutoCorr(series_matrix(rownum,:),1);
%     longAMfeatures(rownum) = IN_AutoMutualInfo(series_matrix(rownum,:));
% end

% % compute AC features for each row
% ACfeatures = NaN(40,10);
% AMfeatures = NaN(40,10);
% each_lag_features = NaN(40,10);
% for rownum = 1:40
%     for colnum = 1:10
%         rowdata = pieces{rownum, colnum};
%         ACfeatures(rownum, colnum) = CO_AutoCorr(rowdata,1);
%         AMfeatures(rownum, colnum) = IN_AutoMutualInfo(rowdata);
%     end
% end


% save('ACAM_computed.mat', 'longACfeatures', 'longAMfeatures', 'ACfeatures', 'AMfeatures');
load('ACAM_computed.mat');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % plot the features
imagesc([longACfeatures longAMfeatures])
title("raw AC and AM")
ylabel("each long time series")
xlabel("AC and AM")
colorbar

figure
imagesc(ACfeatures)
title("AC")
ylabel("each long time series")
xlabel("each short piece")
colorbar

figure
imagesc(AMfeatures)
title("AM")
ylabel("each long time series")
xlabel("each short piece")
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
xlabel("f-f corrs between AC and AMI features")
colorbar

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% how features computed by ARcorr at different lags correlated with others
% compute feature-feature correlation between for feature 1 to 6
% there are 6C2 = 15 combinations/pairs
% pairs = [];
% for i = 1:5
%     for j = i+1:6
%        pairs = [pairs; [i, j]];
%     end
% end

% pairs_str = string(NaN(15,1));
% for p = 1:size(pairs ,1)
%     pairs_str(p) = sprintf("%d-%d", [pairs(p,1), pairs(p,2)]);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ffcorrs = NaN(40, size(pairs,1));
% for p = 1:size(pairs, 1)
%     p1 = pairs(p, 1);
%     p2 = pairs(p, 2);
    
%     xdata = ACfeatures{p1};
%     ydata = ACfeatures{p2};
    
%     for rownum = 1:size(xdata, 1)
%         ffcorrs(rownum, p) = corr(xdata(rownum, :)', ydata(rownum, :)');
%     end
% end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the correlations
% figure
% imagesc(ffcorrs)
% colorbar
% set(gca, 'xtick',1:size(pairs,1))
% set(gca, 'xticklabel', pairs_str)


% % set(gca, 'ytick',1:2)
% % set(gca, 'yticklabel', ["linear", "nonlinear"])
% % ylabel('feature pairs')
% xlabel('correlations cocoefficients with lags 1-6')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% using catch22(24)
% compute features for long/raw features

% longc22features = NaN(40, 24);
% for rownum = 1:40
%     currentrow = series_matrix(rownum,:);
%     longc22features(rownum, :) = catch22_all(currentrow')';
% end

% % compute catch22 for each piece
% shortc22features = {};
% for rownum = 1:40
%     each_row_features = NaN(10, 24);
%     for colnum = 1:10
%         currentpiece = pieces{rownum, colnum};
%         each_row_features(colnum, :) = catch22_all(currentpiece')';
%     end
%     shortc22features{rownum} = each_row_features;
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save('c22_computed.mat', 'longc22features', 'shortc22features');
% load('c22_computed.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalization

% normlongfeatures = normalize(longc22features, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the rowfeatures
% figure
% imagesc(normlongfeatures)
% colorbar
% title(sprintf("catch22 to each long raw series"))
% ylabel("each long time series")
% xlabel("24 different features")
% featureList = importdata('featureList.txt');
% set(gca, 'xtick',1:24)
% set(gca, 'xticklabel', featureList)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute feature-feature correlations
% there are 24C2 = 276 combinations/pairs
% pairnum = 276;
% pairs = [];
% for i = 1:23
%     for j = i+1:24
%        pairs = [pairs; [i, j]];
%     end
% end

% pairs_str = string(NaN(pairnum,1));
% for p = 1:size(pairs ,1)
%     pairs_str(p) = sprintf("%d-%d", [pairs(p,1), pairs(p,2)]);
% end



% % compute
% ffcorrs = NaN(40, pairnum);
% for rownum = 1:40
%     currentpieces = shortc22features{rownum};
%     for p = 1:pairnum
%         p1 = pairs(p, 1);
%         p2 = pairs(p, 2);
%         xdata = currentpieces(:,p1);
%         ydata = currentpieces(:,p2);
%         ffcorrs(rownum, p) = corr(xdata, ydata);
%     end
% end

% % plot
% figure
% imagesc(ffcorrs)
% colorbar
% hold on
% plot([0, 276],[20,20],'blue', 'linewidth', 3)
% set(gca, 'xtick',1:pairnum)
% set(gca, 'xticklabel', string(1:276))

% % portrait
% figure
% imagesc(ffcorrs')
% colorbar
% hold on
% plot([20, 20],[0, 276],'blue', 'linewidth', 3)
% set(gca, 'ytick',1:pairnum)
% set(gca, 'yticklabel', string(1:276))
