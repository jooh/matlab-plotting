% draw lines between all non-nan points in the distance matrix pmat.
% typically used to visualise contrasts in conjunction with barchart.
%
% INPUT         DEFAULT                 DESCRIPTION
% ax            gca                     axis handle
% pmat          -                       ncon by ncon symmetrical matrix
%
% NAMED INPUT
% ypos          max(ylim(ax))           vertical offset
% xpos          1:size(pmat,1)          position of each point
% yshift        range(ylim(ax))*.07     amount of shift between each row of
%                                           lines
% xshiftprop    .01                     shift between lines on the same row
%                                           as a proportion of x range
%
% OUTPUT
% lhand     row vector with handles to each line (NaN rows for NaN pmats)
% ypos      maximum y position of lines
% xy        position of each line. useful for adding p text, e.g.,
%               addptext(xy(:,1),xy(:,2),squareform(pmat)',[],[],...
%                   'verticalalignment','top',...
%                   'horizontalalignment','center');
%
% [lhand,ypos,xy] = contrastlines(ax,pmat,varargin)
function [lhand,ypos,xy] = contrastlines(ax,pmat,varargin);

if ieNotDefined('ax')
    ax = gca;
end
ncon = size(pmat,1);
assert(isrdm(pmat),'input must be a valid RDM');

getArgs(varargin,{'ypos',max(ylim(ax)),'xpos',1:ncon,'yshift',...
    range(ylim(ax))*.07,'xshiftprop',.02});

cap = yshift/2;

% get the unique dissimilarities
pmat = tril(pmat,-1);
% indices to each line
[xend,xstart] = find(pmat~=0);
% we want to draw the shortest lines first
[~,ind] = sort(abs(xstart-xend),1,'ascend');
xstart = xstart(ind);
xend = xend(ind);
xs = xpos(xstart);
xe = xpos(xend);
nline = numel(ind);

xrange = range([min(xs) max(xe)]);
xoff = xrange * xshiftprop;

% every entry in linemat is a line _between_ two points (hence -1)
linemat = NaN([1,numel(xpos)-1]);

% generate a matrix that defines which lines to draw
xy = NaN([nline 2]);
lhand = NaN([nline 1]);
% offset
ypos = ypos+yshift;
for x = 1:nline
    % skip nans here
    if isnan(pmat(xend(x),xstart(x)))
        continue;
    end
    % find indices for current line -1 again to draw lines between points
    thisind = [xstart(x):xend(x)-1];
    % find rows where the current line would fit
    rowind = find(all(isnan(linemat(:,thisind)),2),1,'first');
    if isempty(rowind)
        % need a new row (maybe prepend instead?)
        linemat = [linemat; NaN([1 numel(xpos)-1])];
        rowind = size(linemat,1);
        ypos = [ypos ypos(end) + yshift];
    end
    % plug in the line index (pick the first available row)
    linemat(rowind,thisind) = x;
    % with offset to make room for neighbouring lines
    thisxs = xs(x)+xoff;
    thisxe = xe(x)-xoff;
    xy(x,1) = [thisxs+thisxe]/2;
    xy(x,2) = ypos(rowind);
    lhand(x) = line([thisxs thisxs thisxe thisxe],...
        [ypos(rowind)-cap ypos(rowind) ypos(rowind) ypos(rowind)-cap],...
        'color',[0 0 0],'linewidth',.5,'clipping','off','parent',ax);
end
% resort the lines and xy so that squareform will return correct order
[~,reverseind] = sort(ind);
lhand = lhand(reverseind);
xy = xy(reverseind,:);
ypos = max(ypos(:));
