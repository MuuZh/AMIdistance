clear
close all

N_length = 20000; % length of each generated series
k_length = 1000; % length of first k data points to be removed

testnums = 150;
as = linspace(0.2, 1, testnums);
results = NaN(testnums, N_length);
for i = 1:testnums
    current_a = as(i);
    results(i, :) = gen_linear_AR(N_length, k_length, current_a)';
end


f_AC1 = NaN(1, testnums);
f_AMI1 = NaN(1, testnums);

AC_using_method = "Fourier";
AMI_using_method = "kraskov1";

for i =  1:testnums
    ts = results(i,:);
    f_AC1(i) = CO_AutoCorr(ts,1,AC_using_method);
    f_AMI1(i) = IN_AutoMutualInfo(ts, 1, AMI_using_method);
end

figure;
plot(as, f_AC1)
hold on
plot(as, f_AMI1)
xlabel("a")
ylabel("feature value")

legend("AC1", "AMI1")
