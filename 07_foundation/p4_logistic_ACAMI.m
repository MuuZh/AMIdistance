clear
close all

num_eta = 10;
uppereta = 0.08;
lowereta = 0.01;
noises = linspace(lowereta,uppereta,num_eta);

c = colormap(turbo(num_eta));
figure
for ii = 1:num_eta
    num_A = 25;
    A = linspace(3.57, 3.75, num_A);
    series_length = 20000;
    k = 2000;
    eta = noises(ii);
    % creat a num_A*series_length NaN matrix
    series = NaN(num_A, series_length);

    % generate logisitic sereies with varing a
    for i = 1:num_A
        series(i, :) = gen_logistic(series_length, k, A(i), eta);
    end

    AC_features = NaN(num_A,1);
    AMI_features = NaN(num_A,1);

    % compute AC and AMI features for each AR1 series
    AC_using_method = "Fourier";
    AMI_using_method = "kraskov2";
    for i = 1:num_A
        AC_features(i) = CO_AutoCorr(series(i,:)',1, AC_using_method);
        AMI_features(i) = IN_AutoMutualInfo(series(i,:)', 1, AMI_using_method);
    end

    % plot AC and AMI features
    

    current_color = c(ii,:);
    plot(A, AC_features, 'Color', current_color, 'LineWidth', 1)
    xlabel('a')
    hold on 
    plot(A, AMI_features, 'Color', current_color, 'LineWidth', 1)
    xlabel('A')
    ylabel('feature value')
    % legend('AC1', 'AMI1')
    title("AC/AMI features for logistic series, current eta = " + eta)
    hold on
%     save2gif("AC_AMI_logistic_eta_0.01to0.08.gif",ii)
end
