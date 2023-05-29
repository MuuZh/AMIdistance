function plot_map_process_logistic(ts, A, points, pause_time)
%  Plot the Cobweb diagram for the logistic map
    figure
    tempx = linspace(0, 1, 1000);
    plot(tempx, A*tempx.*(1-tempx))
    hold on
    plot([0,1], [0,1])
   
    x = ts(1:end-1);
    y = ts(2:end);

    c = colormap(copper(points));
    for i = 1:points
        p1x = x(i);
        p1y = x(i);
        if i == 1
            p1x = x(i);
            p1y = 0;
        end
        p2x = x(i);
        p2y = y(i);
        p3x = y(i);
        p3y = y(i);
        current_color = c(i,:);
        plot([p1x, p2x], [p1y p2y], 'color', current_color)
        pause(pause_time)
        plot([p2x, p3x], [p2y p3y], 'color', current_color)
        pause(pause_time)
        % plot([p2x, p3x], [p2y p3y])
        % pause(pause_time)
        xlabel('x_t')
        ylabel('x_{t+1}')
        title(sprintf('Map: %s with A = %.3f, Current point: %d', "logistic", A, i))
        
        
    end

end