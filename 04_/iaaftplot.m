% illustrate iAAFT
clear
eta_ar = 0.2;
eta_tent = 0.03;

a = 0.78;
mu = 1.03;
N_length = 20000; % length of each generated series
k_length = 1000; % length of first k data points to be removed
X = gen_tent_p(N_length,k_length,mu, eta_tent);
N = N_length;
iters = [10,100,500,1000,2500,5000,1000000];
% 
i = 6;

sur = SS_iter_surro(X,iters(i));


figure;
plot(1:N,X)
xlim([0,N])
title('tent')
xlabel('t')
ylabel('x')

figure;
plot(1:N,sur)
xlim([0,N])
title('tent Surrogate')
xlabel('t')
ylabel('x')
figure;
hold on
h1 = histogram(X,'FaceAlpha',0.5,'EdgeAlpha',0.5);
h2 = histogram(sur,'FaceAlpha',0.5,'EdgeAlpha',0.5);
set(h1,'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'facealpha',0.5,'EdgeAlpha',0.5);
set(h2,'FaceColor',[1 0 0],'EdgeColor',[1 0 0],'facealpha',0.5,'EdgeAlpha',0.5);
legend('tent',' tent surrogate')
xlabel('x')
ylabel('Counts')
hold off
title('Distributions of Chaotic and Surrogate Series')


figure;
plot(1:N,abs(fft(X)).^2-abs(fft(sur)).^2)

Fs = 1/6;                           % Sampling Frequency
Fn = Fs/2;                                      % Nyquiat Frequency
% L = size(D,1);
FTsC = fft(X)/N;
FTsS = fft(sur)/N;
Fv = linspace(0, 1, fix(N/2)+1)*Fn;             % Frequency Vector
Iv = 1:numel(Fv);   





plot(Fv, (abs(FTsC(Iv))*2).^2 -  (abs(FTsS(Iv))*2).^2)    

xlabel('Frequency')
ylabel('Power')

xlim([0,max(Fv)])
title('Power Spectrum Difference')

