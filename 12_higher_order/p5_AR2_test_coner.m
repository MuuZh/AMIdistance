close all 
clear
series_length = 2000;
eta = 200;
test_series = MkSg_AR(series_length,[-1, 1]', eta);
plot(test_series)
[acf,acflags] = autocorr(test_series, NumLags=10)