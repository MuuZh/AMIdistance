clear
close all
a_num = 10000;

series_length = 2000;
eta = 0;

tic
a = linspace(-1,1,a_num);
ARmatrix = NaN(a_num, series_length);
for i = 1:a_num
    ARmatrix(i,:) = MkSg_AR(series_length, a(i), eta);
end
toc

AC_using_method = "Fourier";

tic
acf = NaN(a_num,1);
for i = 1:a_num
    temp = autocorr(ARmatrix(i,:), NumLags=1);
    acf(i)= temp(2);
end
toc
plot(a, acf)


tic
ami = NaN(a_num,1);
for i = 1:a_num
    ami(i)= IN_AutoMutualInfo(ARmatrix(i,:)', 1, "kraskov2");
end
toc
figure
plot(a, ami)
