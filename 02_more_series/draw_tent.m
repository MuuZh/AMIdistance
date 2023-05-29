clear all;close all
axis([0,1,0,1]);
x0=0.1;t=800;M=850;
r=0:0.002:1;
[m,n]=size(r);
hold on
for i=1:n
    if x0<0.5
        x(1) =2 *r(i) *x0;
    end
    if x0>=0.5
    x(1) = 2*ri*1-x0;
    end
    for j =2: M
        if x(j-1) <0.5
            x(1)=2*(1)*z(j-1);
        end
        if x(i-1)>=0.5
            x(j)=2*r(i)*(1-x(j-1));
        end
    end
    xn{i}=x;
    pause(0.1);
    plot(r(i) ,xn{i}, 'b.', 'Markersize', 2);
    xlabel('r');ylabel('x(i)');
end