clear
close all

addpath('../../catch22-0.4.0/wrap_Matlab');

% fnames = ["Lorenz", "Rossler", "DiffnLorenz", "ComplexButterfly", "Chen", "Hadley", "ACT", "RabFab", "lfrbms", "Chua", "MooreSpiegel", "thomascsa", "halvorsencsa", "BurkeShaw", "Rucklidge", "windmi", "simpqcf", "simpccf", "simpplcf", "DoubleScroll"];
fnames = ["Lorenz", "Rossler", "DiffnLorenz", "ComplexButterfly", "Chen", "Hadley", "RabFab", "Chua", "MooreSpiegel", "thomascsa", "halvorsencsa", "Rucklidge", "windmi", "simpqcf", "simpccf", "simpplcf"];
features = [
"DN HistogramMode 5",
"DN HistogramMode 10",
"CO f1ecac",
"CO FirstMin ac",
"CO HistogramAMI even 2 5",
"CO trev 1 num",
"MD hrv classic pnn40",
"SB BinaryStats mean longstretch1",
"SB TransitionMatrix 3ac sumdiagcov",
"PD PeriodicityWang th0 01",
"CO Embed2 Dist tau d expfit meandiff",
"IN AutoMutualInfoStats 40 gaussian fmmi",
"FC LocalSimple mean1 tauresrat",
"DN OutlierInclude p 001 mdrmd",
"DN OutlierInclude n 001 mdrmd",
"SP Summaries welch rect area 5 1",
"SB BinaryStats diff longstretch0",
"SB MotifThree quantile hh",
"SC FluctAnal 2 rsrangefit 50 1 logi prop r1",
"SC FluctAnal 2 dfa 50 1 2 logi prop r1",
"SP Summaries welch rect centroid",
"FC LocalSimple mean3 stderr",
"DN Mean",
"DN Spread Std"
]
nmodels = length(fnames);

% NL = 10000;
% flowMatrix = NaN(nmodels, NL);
% for i = 1:nmodels
%     currentFlow = fnames(i)
%     flowMatrix = MkSg_Flow(currentFlow,NL);
% end

% c24Matrix = NaN(nmodels, 24);
% for i = 1:nmodels
%     c24Matrix(i,:) = catch22_all(flowMatrix(i,:)')';
% end

load("data")

normalizedc24 = NaN(nmodels, 24);
for i = 1:24
    normalizedc24(:,i) = normalize(c24Matrix(:,i));
end

imagesc(normalizedc24)
colorbar
xticks(1:24)
xticklabels(features)
yticks(1:nmodels)
yticklabels(fnames)
title("Normalized features")
xlabel("feature types")
ylabel("flows ")
tol = 0.03;
for i = 1:nmodels
    for j = 1:24
        currentValue = normalizedc24(i,j);
        currentText = sprintf("%.3f", currentValue);
        text(j-0.3,i, currentText)
    end
end

similar_pairs = {};
for colnum = 1:24
    col = c24Matrix(:,colnum);
    similar_pairs{colnum} = [];
    for rownum = 1:nmodels
        rowval = col(rownum);
        for i = rownum+1:nmodels
            temp = col(i);
            if (abs(temp-rowval)/abs(rowval) <= tol) 
                sp = [i, rownum];
                similar_pairs{colnum} = [similar_pairs{colnum} ;[min(sp) max(sp)]];
            end
        end
    end
end

celldisp(similar_pairs)