methods = ["gaussian","kernel", "kraskov1" ,"kraskov2"];
% N_length = 20000; % length of each generated series
k_length = 1000;
ls = linspace(11000,20000,10);
series_matrix = {};
for i = 1:10
    series_matrix{i} = gen_tent(ls(i), k_length, 1.22)';
end

timeused = NaN(10, 4);
for i = 1:4
    for j = 1:10
        t1 = cputime;
        tic
        IN_AutoMutualInfo(series_matrix{j}', 1, methods(i));
        toc
        t2 = cputime;
        timeused(j,i) = (t2 - t1);
    end
end
for i = 1:4
%     subplot(1,3,i)
    plot(ls, timeused(:,i)')
    xlabel("length of input series")
    ylabel("time used")
    hold on
end
legend('gaussian','kernel', 'kraskov1' ,'kraskov2')
