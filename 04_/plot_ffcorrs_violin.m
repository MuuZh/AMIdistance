close all
clear
load 'computedwindows.mat'
possible_w = [5 10 20 40 50 80 100 200];
n = length(possible_w);
tops = [];
bots = [];
strtags = [];

grouporder = {};
for i = 1:n
    ffcorrs = ffcorrs_at_window{i};
    tops = [tops;ffcorrs(1:20)];
    bots = [bots;ffcorrs(21:40)];
    
    numtags = ones(20,1)*possible_w(i);
    
    strtags = [strtags;cellstr(num2str(numtags, '%04d'))]
    grouporder{i} = num2str(possible_w(i), '%04d');
end

violinplot(tops, strtags, 'GroupOrder', grouporder)
ylabel('AC1 against AMI1 f-f correlation')
xlabel('window numbers')
title('AR part')

figure
violinplot(bots, strtags, 'GroupOrder', grouporder)
ylabel('AC1 against AMI f-f correlation')
xlabel('window numbers')
title('tent part')
