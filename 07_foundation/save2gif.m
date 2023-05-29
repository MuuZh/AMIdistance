function save2gif(fn, mark, varargin)
    p = inputParser;
    addParameter(p,'DelayTime',0.1);
    parse(p,varargin{:});

    F = getframe(gcf);
    im = frame2im(F);
    [I,map] = rgb2ind(im,256);
    if mark == 1
        imwrite(I,map, fn,'GIF', 'Loopcount',inf,'DelayTime', p.Results.DelayTime);
        mark = mark + 1;
    else
        imwrite(I,map, fn,'WriteMode','append','DelayTime', p.Results.DelayTime);
    end
end