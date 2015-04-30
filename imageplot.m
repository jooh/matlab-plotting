% Plot an image (probably an RDM) with labels. Mainly used by the rdmplot
% wrapper function. The primary functionality here is upscaling by nearest
% neighbour interpolation, which helps get around an unfixed Matlab bug
% that produces blurry EPS output on Macs.
%
% INPUT:
% ax            gca         axis handle
% im            -           RGB image
%
% rowlabels     []          for imageticks
% collabels     []          for imageticks
% nrows         2
% rotatelabels  45
% gridcolor     [1 1 1]     t
% gridlines     []
% ticklines     0
% upscale       'auto'
% outline       []
% outlinecolor  'm'
%
% ih = imageplot(ax,im,varargin)
function ih = imageplot(ax,im,varargin)

nrow = size(im,1);
ncol = size(im,2);
getArgs(varargin,{'rowlabels',[],'collabels',[],'nrows',2,...
    'rotatelabels',45,'gridcolor',[1 1 1],'gridlines',[],...
    'ticklines',0,'upscale','auto','outline',[],'outlinecolor','m',...
    'xlims',[1 ncol],'ylims',[1 nrow]});


minsize = 500;
minn = min([nrow ncol]);
if strcmp(upscale,'auto')
    % find a multiplication by 8 that gets us over 500 pixels
    upscale = ceil(minsize / minn / 8) * 8;
end

if upscale>1
    % we could use imresize with 'nearest' but this reduces the licensing
    % requirements...
    im = im(repinds(1,nrow,upscale),repinds(1,ncol,upscale),:);
end

% here the .5 modifiers are probably an issue. 

% I think we need to take 1 off here to allow for the extra span (the first
% pixel needs an extra half pixelwidth to the left and the last an extra
% half to the right)
pixheight = range(ylims) / (nrow-1);
pixwidth = range(xlims) / (ncol-1);
% so this tells us how much padding is needed around the sides to avoid
% clipping off the first and final half pixel.

% width of each actual pixel after upscaling
pixwidth_up = pixwidth / upscale;
pixheight_up = pixheight / upscale;

% so here's what we do
% 1) find the left edge where we want to start drawing
% (xlims(1)-pixwidth/2)
% 2) increment at each upscaled pixel width
% 3) finish at the RIGHT edge where we want to end (xlims(2)+pixwidth/2)
% 4) shift this array by half an upscaled pixel to center
allx = [xlims(1)-pixwidth/2:pixwidth_up:xlims(2)+pixwidth/2] + ...
    pixwidth_up/2;
% 5) drop off the final pixel that goes outside the range (this is covered
% by the centering)
allx(end) = [];

ally = [ylims(1)-pixheight/2:pixheight_up:ylims(2)+pixheight/2] + ...
    pixheight_up/2;
% drop off overshoot
ally(end) = [];

ih = image(allx,ally,im,'parent',ax);
set(ax,'xlim',xlims + pixwidth./[-2 2],'ylim',ylims + pixheight./[-2 2],...
    'xtick',xlims(1):pixwidth:xlims(2),...
    'ytick',ylims(1):pixheight:ylims(2),'tickdir','out');

% for display only dataaspectratio needs to be set, but by also setting
% plotboxaspectratio we obtain more accurate estimates of axis position
% from e.g. get(ax,'position').
set(ax,'dataaspectratio',[1 1 1],'plotboxaspectratio',[1 1 1]);

% sort out x/y labels
if isempty(rowlabels) && isempty(collabels)
    axis(ax,'off');
elseif isnumeric(rowlabels) || ischar(rowlabels) || (iscell(rowlabels) && ischar(rowlabels{1}))
    % text labels
    assert(numel(collabels)==numel(get(ax,'xtick')),...
        'number of collabels does not match number of xtick');
    assert(numel(rowlabels)==numel(get(ax,'ytick')),...
        'number of rowlabels does not match number of ytick');
    set(ax,'xticklabel',collabels,'yticklabel',rowlabels);
    if ~isempty(rotatelabels) && rotatelabels~=0
        rotateXLabels(ax,rotatelabels);
    end
elseif iscell(rowlabels) && ~isempty(rowlabels{1})
    % image labels
    [h,lh] = imageticks(ax,[],'yimages',rowlabels,'ximages',collabels,...
        'nrows',nrows,'ticklines',ticklines);
else
    error('could not parse input: rowlabels')
end
box(ax,'off');

if ~isempty(gridlines)
    % remove any gridlines exceeding nrow (can happen e.g. when collapsing
    % split RDMs)
    gridlines(gridlines>nrow) = [];
    [x,y] = meshgrid(gridlines+.5,[.5 nrow+.5]);
    gridh = line([x y],[y x],'linewidth',.5,'color',gridcolor);
end

if ~isempty(outline)
    outhand = imoutline(outline,'color',outlinecolor,...
        'linewidth',1);
end

