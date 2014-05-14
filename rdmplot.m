% Plot RDM panel with labels. NaN dissimilarities get coloured white, as
% does the diagonal. We plot with a custom colormap conversion to support
% vector graphics (rather than using the alpha channel to remove NaNs,
% which is incompatible with the painters renderer).
%
% INPUTS:
% ax: (default gca) axis handle
% rdm: a single valid RDM in mat, vector or struct form
%
% NAMED INPUTS (all optional):
% labels: cell array of text or image labels
% imagealpha: cell array of alpha images for image labels
% nrows: (default 2) number of rows for image stacking
% cmap: (default cmap_bwr) colormap
% rotatelabels: (default 90) rotate text xticklabels
% collapseunused: (default false) remove NaNed out conditions before
%   plotting.
% collapsesplitrdm: (default false) plot only lower left quadrant of split
%   data RDM (currently unsupported)
% limits: for colormap intensity range
% gridlines: (default [])
% gridcolor: (default []) if set, we plot a grid with this colour. If
%   gridlines is set, gridcolor defaults to [1 1 1]
% greythresh: (default []) if set, convert intensities under threshold to
%   muted greyscale
%
% OUTPUTS:
% ax: axis handle
% intmap: intensity map
% cmap: colormap (the last two can be passed to colorbarbetter)
%
% [ax,intmap,cmap] = rdmplot(ax,rdm,varargin)
function [ax,intmap,cmap] = rdmplot(ax,rdm,varargin)

getArgs(varargin,{'labels',[],'imagealpha',[],'nrows',2,'cmap',cmap_bwr,...
    'rotatelabels',90,'collapseunused',false,'collapsesplitrdm',false,...
    'limits',[],'gridcolor',[],'gridlines',[],'greythresh',[]});

if ieNotDefined('ax')
    ax = gca;
end

if ~isempty(gridlines) && isempty(gridcolor)
    gridcolor = [1 1 1];
end

rdmmat = asrdmmat(rdm);
[ncon,~,nrdm] = size(rdmmat);
assert(nrdm==1,'only one RDM can be entered at a time')
rowind = 1:ncon;
colind = 1:ncon;

if collapseunused
    rdmtest = rdmmat;
    rdmtest(diagind(size(rdmtest))) = NaN;
    validrows = ~all(isnan(rdmtest),2);
    assert(isequal(validrows,~all(isnan(rdmtest),1)'),'asymmetric NaNs in RDM');

    rdmmat = rdmmat(validrows,validrows);
    if ~isempty(labels)
        labels = labels(validrows);
    end
    rowind = rowind(validrows);
    colind = colind(validrows);
end

if collapsesplitrdm && issplitdatardm(rdmmat)
    error('currently unsupported');
    goodcol = ~isnan(rdmmat(:,1));
    goodrow = ~isnan(rdmmat(1,:));
    rdmmat = rdmmat(goodrow,goodcol);
    if ~isempty(labels)
        rowlabels = labels(goodrow);
        collabels = labels(goodcol);
    end
    whitediagonal = false;
    rowind = rowind(goodrow);
    colind = colind(goodcol);
else
    rowlabels = labels;
    collabels = labels;
    whitediagonal = true;
end
% update ncon
ncon = size(rdmmat,1);

% convert to RGB with white diagonal
[im,intmap,cmap] = intensity2rgb(rdmmat,cmap,limits,greythresh);

if whitediagonal
    im(diagind(size(im))) = 1;
end

image(im,'parent',ax);
set(ax,'xlim',[.5 ncon+.5],'ylim',[.5 ncon+.5],'xtick',1:ncon,...
    'ytick',1:ncon,'tickdir','out');

% sort out x/y labels
if isempty(labels)
    % probably don't want axis display. But we set labels anyway so you can
    % see collapse behaviours
    set(ax,'xticklabel',colind,'yticklabel',rowind);
    axis(ax,'off');
elseif isnumeric(labels) || ischar(labels) || (iscell(labels) && ischar(labels{1}))
    % text labels
    set(ax,'xticklabel',collabels,'yticklabel',rowlabels);
    if ~isempty(rotatelabels) && rotatelabels~=0
        rotateXLabels(ax,rotatelabels);
    end
elseif iscell(labels) && ~isempty(labels{1})
    % image labels
    if isequal(rowlabels,collabels)
        h = imageticks(ax,rowlabels,nrows,[1 2],imagealpha);
    else
        h = imageticks(ax,rowlabels,nrows,2,imagealpha);
        h = imageticks(ax,collabels,nrows,1,imagealpha);
    end
else
    error('could not parse input: labels')
end
box(ax,'off');
set(ax,'dataaspectratio',[1 1 1]);

if ~isempty(gridcolor)
    if isempty(gridlines)
        gridlines = 0:ncon;
    end
    [x,y] = meshgrid(gridlines+.5,[.5 ncon+.5]);
    gridh = line([x y],[y x],'linewidth',.5,'color',gridcolor);
end
