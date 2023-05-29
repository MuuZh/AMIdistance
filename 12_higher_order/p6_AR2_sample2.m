clear
close all
tic
% test for AR2
% set parameters
a_num = 200;

series_length = 2000;
eta = 200;

ARmatrix = NaN(a_num, a_num, series_length);

% random number from -1 to 1
lag1_a = rand(a_num,1)*2-1;
lag2_a = rand(a_num,1)*2-1;

lag1_a = sort(lag1_a);
lag2_a = sort(lag2_a);
filter1 = lag2_a + lag1_a < 1;
lag1_a = lag1_a(filter1);
lag2_a = lag2_a(filter1);
filter2 = lag2_a - lag1_a < 1;
lag1_a = lag1_a(filter2);
lag2_a = lag2_a(filter2);

toc
tStart = tic;
TT = [];
% sample all lag1 and lag2
for i = 1:length(lag1_a)
    for j = 1:length(lag2_a)
        ARmatrix(i,j,:) = MkSg_AR(series_length,[lag2_a(j), lag1_a(i)]', eta);
    end
    TT = [TT toc];
    if mod(i, 50) == 0
        disp(['i = ', num2str(i), ' time = ', num2str(sum(TT))]);
    end
end
tEnd = toc(tStart);
disp(['total time = ', num2str(tEnd)]);
AC_using_method = "Fourier";
AMI_using_method = "kraskov2";

% compute what values of lag1 and lag2 cause explosion using IsExploded()
tic
useful_parameter = NaN(a_num, a_num);
for i = 1:length(lag1_a)
    for j = 1:length(lag2_a)
        if IsExploded(reshape(ARmatrix(i,j,:),[],1))
            useful_parameter(i,j) = 0;
        else
            useful_parameter(i,j) = 1;
        end
    end
end

toc

% plot the result
% [~, lag1_a_idx] = sort(lag1_a);
% [~, lag2_a_idx] = sort(lag2_a);
% useful_parameter = useful_parameter(lag1_a_idx, lag2_a_idx);
figure
imagesc(lag2_a, lag1_a, useful_parameter)
grid on
xlabel('parameter lag2')
ylabel('parameter lag1')
colorbar
title('parameter pairs for AR2')



% test_series = MkSg_AR(series_length,[0.7, 0.29]', eta);
% plot(test_series)
% xlabel('t')
% ylabel('y')
% title('MkSg\_AR(series_length,[0.7, 0.4]'', eta)')
% [acf, ~] = autocorr(test_series, NumLags=20)