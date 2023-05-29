close all;clc;clear;
dt=0:0.3:7*pi;
lent = length(dt);
x = zeros(1,lent);
y = zeros(1,lent);
z = zeros(1,lent);
plot3(x(1),y(1),z(1),'b');
hold on;
xlabel('X ');
ylabel('Y ');
zlabel('Z ');
xlim([-1 1]);
ylim([-1 1]);
zlim([0 60]);
title('Spiral animation demo');
mark= 1;
for k = 1:lent
    x(k) = cos(dt(k));
    y(k) = sin(dt(k));
    z(k) = 2*dt(k);
    plot3(x(1:k),y(1:k),z(1:k),'b>-');
    pause(0.05);
    F = getframe(gcf);
    im = frame2im(F);
    [I,map] = rgb2ind(im,256);
    if mark == 1
        imwrite(I,map,'Spiral.gif','GIF', 'Loopcount',inf,'DelayTime',0.1);
        mark = mark + 1;
    else
        imwrite(I,map,'Spiral.gif','WriteMode','append','DelayTime',0.1);
    end
end