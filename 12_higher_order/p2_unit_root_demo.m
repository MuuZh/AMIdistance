clear
close all



series_length = 1000;
eta = 200;

figure('Position', [100, 100, 1800, 500])
subplot(1,3,1)
plot(MkSg_AR(series_length, 0.8, eta))
xlabel('t')
ylabel('x(t)')
title('a = 0.8')
grid on

subplot(1,3,2)
plot(MkSg_AR(series_length, 1.2, eta))
xlabel('t')
ylabel('x(t)')
title('a = 1.2')
grid on

subplot(1,3,3)
plot(MkSg_AR(series_length, 1, eta))
xlabel('t')
ylabel('x(t)')
title('a = 1')
grid on

