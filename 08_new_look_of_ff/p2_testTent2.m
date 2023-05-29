clear
close all


as = linspace(1.01,1.999,10);
for ii = 1:length(as)-1
    lower = as(ii);
    higher = as(ii+1);


    series_length = 1000;
    eta = 100;
    % set a
    a = linspace(lower,higher,10);

    % number of samples for each a
    N = 100;

    % make a 3 dimensional array to store the series
    % 1st dimension: N
    % 2nd dimension: length of series
    % 3rd dimension: length of a

    % different initial contidion
    initial_a = linspace(-0.1, 0.1, N) * 1/sqrt(2) + 1/sqrt(2);

    series_matrix = NaN(N, series_length, length(a));
    % generate samples for each a
    for i = 1:length(a)
        for j = 1:N
            % series_matrix(j, :, i) = MkSg_AR(series_length, a(i), eta);
            series_matrix(j, :, i) = MkSg_Map('tent', series_length, initial_a(j), a(i), eta);
        end
    end


    AC_using_method = "Fourier";
    AMI_using_method = "kraskov2";

    % compute AR and AMI fetures for each sample
    AC_features = NaN(length(a), N);
    AMI_features = NaN(length(a), N);

    totalt = 0;
    for i = 1:length(a)
        tic;
        for j = 1:N
            AC_features(i, j) = CO_AutoCorr(series_matrix(j, :, i)',1, AC_using_method);
            AMI_features(i, j) = IN_AutoMutualInfo(series_matrix(j, :, i)', 1, AMI_using_method);
            % current_series = series_matrix(j, :, i)';
            % x_series = current_series(1:end-1);
            % y_series = current_series(2:end);
            % AMI_features(i, j)  = mi_cont_cont(x_series, y_series, 5);

        end
        t2 = toc;
        totalt = totalt + t2;
        if i == length(a)
            fprintf("Processing A = %.5f, time used for this a: %.3fs, total time used: %.3fs\n", a(i), t2, totalt)
        else
            fprintf("Processing A = %.5f, time used for this a: %.3fs\n", a(i), t2)
        end
    end

    % plot the features
    figure
    ax = axes();
    xx = [];
    yy = [];
    c = colormap(hsv(length(a)));
    for i = 1:length(a)
        x = AC_features(i, :);
        y = AMI_features(i, :);
        
        xx = [xx x];
        yy = [yy y]; 

        axis equal
        current_color = c(i, :);
        h(i) = scatter(x, y, '.','MarkerEdgeColor', current_color, 'DisplayName', sprintf('A = %.5f', a(i)));
        hold on
    end

    hCopy = copyobj(h, ax);
    for i = 1:length(a)
        set(hCopy(i), 'XData', NaN', 'YData', NaN);
        hCopy(i).Marker = 'O';
        hCopy(i).MarkerFaceColor = c(i,:);
        hCopy(i).MarkerEdgeColor = 'black';
    end
    legend(hCopy)
    legend('Location','northeast');
    legend('FontSize', 14)


    grid on 

    xlabel('AC feature')
    ylabel('AMI feature')
    title(sprintf('a range: [%.5f, %.5f]', lower, higher))


    [RHO,PVAL] = corr(xx',yy','Type','Spearman');

    fprintf("Spearman correlation: %.5f\n", RHO)
end