% Generate a set of images at [xy] locations in axis ax.  images and alphas
% are cell arrays. Supports any manually set dataaspectratio. If
% dataaspectratio is left auto, we set it to [1 1 1].
%
% imheight: height of image in axis units (width gets set appropriately to
%   preserve aspect ratios). Defaults to 3*(range(ylim)/nstim)
%
% outh = imageaxes(ax,xy,images,[alphas],[imheight],[autolim])
function [outh] = imageaxes(ax,xy,images,alphas,imheight,autolim)

% input checks and setup
if ieNotDefined('ax')
    ax = gca;
end

if ieNotDefined('autolim')
    autolim = true;
end

[n,ndim] = size(xy);
assert(n==length(images),'images and xy are different lengths');
% flag for alpha channel
hasalpha = ~ieNotDefined('alphas');
if hasalpha
    assert(n==length(alphas),'alpha and xy are different lengths');
end

washold = ishold(ax);
hold(ax,'on');

maxax = max(range(xy));
if ieNotDefined('imheight')
    imheight = 3*maxax/n;
end

% unfortunately imshow likes to muck about with the plot settings so to
% stop this...
axx = get(ax,'xlim');
axy = get(ax,'ylim');
axz = get(ax,'zlim');
axpos = get(ax,'position');
axstate = get(ax,'visible');
axdir = get(ax,'ydir');
axtickdir = get(ax,'tickdir');

if strcmp(get(ax,'dataaspectratiomode'),'auto')
    set(ax,'dataaspectratio',[1 1 1]);
end
axisar = get(ax,'dataaspectratio');
axisaspectratio = axisar(1) / axisar(2);

if strcmp(axdir,'normal')
    % need to flip all the images and alphas upside down
    for im = 1:n
        images{im} = images{im}(end:-1:1,:,:);
        if hasalpha
            alphas{im} = alphas{im}(end:-1:1,:,:);
        end
    end
end

switch ndim
    case 2
        imager = @(im,xpos,ypos) imshow(im,'parent',ax,...
            'initialmagnification','fit',...
            'xdata',xpos,'ydata',ypos);
    otherwise
        error('unsupported input dimensionality: %d',ndim);
end

for im = 1:n
    imsize = size(images{im});
    imaspectratio = imsize(1)/imsize(2);
    % scale width by ar
    imwidth = imheight / imaspectratio;
    % and height data ar
    thisimheight = imheight / axisaspectratio;
    % offset to centre images rather than place in top left corner
    xpos = [0 imwidth] - imwidth/2;
    ypos = [0 thisimheight] - thisimheight/2;
    outh(im) = imager(images{im},xpos+xy(im,1),ypos+xy(im,2));
    if hasalpha
        set(outh(im),'alphadata',alphas{im});
    end
end
set(outh,'clipping','off','tag','imageaxes');

% return plot to sanity
set(ax,'visible',axstate,'position',axpos,'xlim',axx,'ylim',axy,...
    'ydir',axdir,'tickdir',axtickdir,'zlim',axz,'dataaspectratio',axisar);
if ~washold
    hold(ax,'off');
end

if autolim
    % scale up axis to accommodate points on periphery (and add a fudge
    % factor since Matlab doesn't consistently render images close to axis
    % limits, even with clipping off.
    % go back to height scale from axis
    imhs = imheight / maxax;
    axis(ax,[min(xy(:,1)) max(xy(:,1)) min(xy(:,2)) max(xy(:,2))] .* ...
        (1+imhs+.3));
end
