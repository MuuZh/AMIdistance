clear all
close all

series_length = 20000;
k = 2000;

tentSeries = MkSg_Map('tent', series_length, 1/sqrt(2), 1.9999, k);

sineSeries =  MkSg_Map('sine', series_length, 0.1, 1, k);



logisticSeries1 = MkSg_Map('logistic', series_length, 0.1, 3.59, k);
logisticSeries2 = MkSg_Map('logistic', series_length, 0.1, 3.8, k);
logisticSeries3 = MkSg_Map('logistic', series_length, 0.1, 4, k);

ARSeries1 = MkSg_AR(series_length, 0.8, k);

ARSeries2 = MkSg_AR(series_length,[0.6, 0.2]', k);



autocorr(ARSeries2)
ylabel('Autocorrelation')


figure
plot_distribution(logisticSeries1)
hold on
plot_distribution(logisticSeries2)
plot_distribution(logisticSeries3)
grid on
legend('A = 3.59','A = 3.80', 'A = 4')
title('Logistic map evolves')

figure
subplot(2,2,1)
scatter(ARSeries1(1:end-1), ARSeries1(2:end),'.')
title('AR(1) map')
xlabel('x(t)')
ylabel('x(t+1)')
grid on

subplot(2,2,2)
scatter(logisticSeries3(1:end-1), logisticSeries3(2:end),'.')
title('Logistic map')
xlabel('x(t)')
ylabel('x(t+1)')
grid on

subplot(2,2,3)
scatter(sineSeries(1:end-1), sineSeries(2:end),'.')
title('Sine map')
xlabel('x(t)')
ylabel('x(t+1)')
grid on

subplot(2,2,4)
scatter(tentSeries(1:end-1), tentSeries(2:end),'.')
title('Tent map')
xlabel('x(t)')
ylabel('x(t+1)')
grid on


