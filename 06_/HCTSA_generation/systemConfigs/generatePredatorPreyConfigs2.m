function TSconfigs = generatePredatorPreyConfigs2()
% parameter values to generate the TSconfig for
rVar =      [0.3 1];    rFix =      0.3; 
KVar =      [0.7 1.2];  KFix =      1;
alphaVar =  [4.4 5.5];  alphaFix =  5;

paramsCell = { ...
    {rVar; KFix; alphaFix}, ... 1D r
    {rFix; KVar; alphaFix}, ... 1D K
    {rVar; KVar; alphaFix}, ... 2D r, K
    };

Ns = [ ...
    100, ...
    400, ...
    400
    ];

TSconfigs = {};
for paramsInd = 1:length(paramsCell)
    TSconfigs = horzcat(TSconfigs, generateStochasticSineMapConfig(paramsCell{paramsInd}, Ns(paramsInd)));
end

end

function config = generateStochasticSineMapConfig(params, N)

    config.functionName = 'predatorPrey';
    config.signalNames = {'x', 'y'};

    config.nRealizations = N;

    config.paramNames = {'r', 'K', 'alpha'};
    config.params = params;

    config.timeParamNames = {'steps'};
    config.timeParams = [...
        1000; ...   signal steps
        ];
    
%     config.postprocessing = ...
%         {@(timeSeriesData, labels, keywords) ...
%         PP_removeTransients(timeSeriesData, labels, keywords, 500)};

end