% Generate a set of images at [xy] locations in axis ax.  images and alphas
% are cell arrays. This function will set your dataaspectratio to [1 1 1]
% to enable square pixels.
%
% imheight: height of image in axis units (width gets set appropriately to
%   preserve aspect ratios). Defaults to 15% of range(ylim)
%
% outh = imageaxes(ax,xy,images,[alphas],[imheight])
function [outh] = imageaxes(ax,xy,images,alphas,imheight)

% input checks and setup
if ieNotDefined('ax')
    ax = gca;
end
% essential for square pixels
set(ax,'dataaspectratio',[1 1 1]);
if ieNotDefined('imheight')
    % 15% of current y limits
    imheight = range(ylim)*.15;
end

[n,ndim] = size(xy);
assert(ndim==2,'only 2 dimensions are supported!')
assert(n==length(images),'images and xy are different lengths')
% flag for alpha channel
hasalpha = ~ieNotDefined('alphas');
if hasalpha
    assert(n==length(alphas),'alpha and xy are different lengths');
end

% unfortunately imshow likes to muck about with the plot settings so to
% stop this...
axx = get(ax,'xlim');
axy = get(ax,'ylim');
axpos = get(ax,'position');
axstate = get(ax,'visible');
axdir = get(ax,'ydir');
axtickdir = get(ax,'tickdir');

if strcmp(axdir,'normal')
    % need to flip all the images and alphas upside down
    for im = 1:n
        images{im} = images{im}(end:-1:1,:,:);
        if hasalpha
            alphas{im} = alphas{im}(end:-1:1,:,:);
        end
    end
end

washold = ishold;
hold on;
for im = 1:n
    imsize = size(images{im});
    aspectratio = imsize(1)/imsize(2);
    % scale width by ar
    imwidth = imheight / aspectratio;
    % offset to centre images rather than place in top left corner
    xpos = [0 imwidth] - imwidth/2;
    ypos = [0 imheight] - imheight/2;
    outh(im) = imshow(images{im},'parent',ax,'initialmagnification','fit',...
        'xdata',xpos+xy(im,1),'ydata',ypos+xy(im,2));
    if hasalpha
        set(outh(im),'alphadata',alphas{im});
    end
end
set(outh,'clipping','off');
% return plot to sanity
set(ax,'visible',axstate,'position',axpos,'xlim',axx,'ylim',axy,...
    'ydir',axdir,'tickdir',axtickdir);
if ~washold
    hold off;
end
