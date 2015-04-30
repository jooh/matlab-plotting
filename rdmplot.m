% Plot RDM panel with labels. NaN dissimilarities get coloured white, as
% does the diagonal. We plot with a custom colormap conversion to support
% vector graphics (rather than using the alpha channel to remove NaNs,
% which is incompatible with the painters renderer). Wraps imageplot.
%
% INPUTS:
% ax: (default gca) axis handle
% rdm: a single valid RDM in mat, vector or struct form
%
% NAMED INPUTS (all optional):
% doranktrans: (default false) true to rank transform before plotting.
% labels: cell array of text or image labels
% ylabels: for imageticks
% xlabels: for imageticks
% nrows: (default 2) number of rows for image stacking
% cmap: (default cmap_bwr) colormap
% rotatelabels: (default 90) rotate text xticklabels
% collapseunused: (default false) remove NaNed out conditions before
%   plotting.
% collapsesplitrdm: (default false) plot only lower left quadrant of split
%   data RDM (currently unsupported)
% limits: for colormap intensity range
% gridlines: (default []) if set, we overlay a grid in gridcolor
% gridcolor: (default [1 1 1]) 
% greythresh: (default []) if set, convert intensities under threshold to
%   muted greyscale
% ticklines: imageticks input
% upscale: default 'auto') if set, upscale the pixels by some factor (see
%   imageplot)
% outline: a binary RDM coding which dissimilarities to outline
% outlinecolor: (default in imageplot) colour for outline
%
% OUTPUTS:
% ax: axis handle
% intmap: intensity map
% cmap: colormap (the last two can be passed to colorbarbetter)
%
% [ax,intmap,cmap] = rdmplot(ax,rdm,varargin)
function [ax,intmap,cmap] = rdmplot(ax,rdm,varargin)

getArgs(varargin,{'labels',[],'nrows',2,'cmap',cmap_bwr,...
    'rotatelabels',45,'collapseunused',false,'collapsesplitrdm',false,...
    'limits',[],'gridcolor',[1 1 1],'gridlines',[],'greythresh',[],...
    'doranktrans',0,'xlabels',[],'ylabels',[],'ticklines',0,'upscale',...
    'auto','outline',[],'outlinecolor',[]});

if nargin==1
    % special single input mode
    rdm = ax;
    clear ax;
end

if ieNotDefined('ax')
    ax = gca;
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
    rowind = rowind(ncon/2+1:ncon);
    colind = colind(1:ncon/2);
    rdmmat = rdmmat(rowind,colind);
    if ~isempty(labels)
        rowlabels = labels(rowind);
        collabels = labels(colind);
    end
    whitediagonal = false;
else
    rowlabels = labels;
    collabels = labels;
    if ~isempty(xlabels)
        collabels = xlabels;
    end
    if ~isempty(ylabels)
        rowlabels = ylabels;
    end
    whitediagonal = true;
end
% update ncon
ncon = size(rdmmat,1);

if doranktrans
    if whitediagonal
        rdmmat = asrdmmat(ranktrans(asrdmvec(rdmmat)));
    else
        % split data RDM
        rdmmat = reshape(ranktrans(rdmmat(:)),[ncon ncon]);
    end
    assert(isempty(limits),'if doranktrans, limits must be undefined');
    assert(isempty(greythresh),'if doranktrans, greythresh must be undefined');
end

% convert to RGB with white diagonal
[im,intmap,cmap] = intensity2rgb(rdmmat,cmap,limits,greythresh);

if whitediagonal
    im(diagind(size(im))) = 1;
end

imageplot(ax,im,'nrows',nrows,'rotatelabels',rotatelabels,...
    'gridcolor',gridcolor,...
    'gridlines',gridlines,'rowlabels',rowlabels,'collabels',collabels,...
    'ticklines',ticklines,'upscale',upscale,'outline',...
    asrdmmat(double(outline)),'outlinecolor',outlinecolor);
