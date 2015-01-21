% Plot an image (probably an RDM) with labels. Mainly used by the rdmplot
% wrapper function. The primary functionality here is upscaling by nearest
% neighbour interpolation, which helps get around an unfixed Matlab bug
% that produces blurry EPS output on Macs.
%
% imageplot(ax,im,varargin)
function imageplot(ax,im,varargin)

getArgs(varargin,{'rowlabels',[],'collabels',[],'nrows',2,...
    'rotatelabels',45,'gridcolor',[1 1 1],'gridlines',[],...
    'ticklines',0,'upscale','auto'});

ncon = size(im,1);

minsize = 500;
if strcmp(upscale,'auto') && ncon<minsize
    % find a multiplication by 8 that gets us over 500 pixels
    upscale = ceil(minsize / ncon / 8) * 8;
end

if upscale>1
    im = imresize(im,upscale,'nearest');
end

% upscale but preserve the overall positioning (each entry centered on
% integers 1:n)
pixr = (ncon)/size(im,1)/2;
% +pixr because the width of the pixel takes care of drawing the rest
startpoint = .5+pixr;
% -pixr ...
endpoint = ncon+.5-pixr;
ih = image([startpoint endpoint],[startpoint endpoint],im,'parent',ax);
lims = [.5 ncon+.5];
ticks = 1:ncon;
set(ax,'xlim',lims,'ylim',lims,'xtick',ticks,'ytick',ticks,...
    'tickdir','out');

% for display only dataaspectratio needs to be set, but by also setting
% plotboxaspectratio we obtain more accurate estimates of axis position
% from e.g. get(ax,'position').
set(ax,'dataaspectratio',[1 1 1],'plotboxaspectratio',[1 1 1]);

% sort out x/y labels
if isempty(rowlabels) && isempty(collabels)
    set(ax,'xticklabel',ticks,'yticklabel',ticks);
    axis(ax,'off');
elseif isnumeric(rowlabels) || ischar(rowlabels) || (iscell(rowlabels) && ischar(rowlabels{1}))
    % text labels
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
    % remove any gridlines exceeding ncon (can happen e.g. when collapsing
    % split RDMs)
    gridlines(gridlines>ncon) = [];
    [x,y] = meshgrid(gridlines+.5,[.5 ncon+.5]);
    gridh = line([x y],[y x],'linewidth',.5,'color',gridcolor);
end
