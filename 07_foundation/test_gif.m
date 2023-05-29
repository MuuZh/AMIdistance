close all
clear

for i = 1:10
    scatter(i,i);
    save2gif('giftest.gif', i)
    hold on
end