% y - data to plot (ngroup by ndata)
%
% NAMED INPUTS:
% labels: xticklabels (cell array or char)
% x: x positions for bar (numeric vector)
% edgecolor: default none - can be n by 3 color matrix with length ndata or
%   1 (same color for all)
% facecolor: default [.6 .6 .6] - as edgecolor
% errorcolor: default [0 0 0]
% errors: []: either same shape as y for symmetrical error bars OR 2 by
%   yshape for non-symmetrical bars, e.g. confidence intervals (we subtract
%   mean from each before passing to errorbar)
% pvalues: we plot all p values so threshold before calling this
% pstyle: 'marker' or 'text'
% rotatelabels: default 45 - only applied to string xlabels
% fighand: default [] - if defined, we plot to this figure instead of
%   making a new one.
% pad: default .5 - xlim padding on either side of bars. 
%
% [fighand,barhand] = barchart(y,varargin)
function [fighand,B] = barchart(y,varargin)

getArgs(varargin,{'labels',[],'edgecolor','none','facecolor',[.6 .6 .6],...
    'errorcolor',[0 0 0],'width',[],'errors',[],'rotatelabels',45,...
    'x',[],'fighand',[],'pad',.5,'pvalues',[],'pstyle','marker'});

if isempty(fighand)
    fighand = figurebetter('medium');
end

assert(ndims(y)<3,'max 2d inputs supported');
if iscol(y)
  y = y';
end
[ngroup ndata] = size(y);

if isempty(width)
  if ngroup==1
    width = .6;
  else
    width = 1;
  end
end

if isempty(x)
  if ngroup == 1
    x = 1:ndata;
  else
    x = 1:ngroup;
  end
end

nface = size(facecolor,1);
nedge = size(edgecolor,1);
if nface>1
  if nedge==1
    edgecolor = repmat(edgecolor,[nface 1]);
  else
    assert(nedge==nface,'edgecolor must be one entry or same as nface');
  end
end
if nedge>1
  if nface==1
    facecolor = repmat(facecolor,[nedge 1]);
  else
    assert(nedge==nface,'edgecolor must be one entry or same as nface');
  end
end
ncolor = nface;
if (ngroup>1 && ncolor~=ndata)
  warning('not enough colors for data - switching to color mapped colors');
  ncolor = 0;
end

if ngroup==1
  % simple bars
  % x position for errors is easy
  xerr = x;
  if ncolor==1
    % simple case
    B = bar(x,y,width,'edgecolor',edgecolor,'facecolor',facecolor,...
        'showbaseline','off');
  else
    % need one call per color
    hold on
    B = arrayfun(@(ind)bar(x(ind),y(ind),width,'edgecolor',...
      edgecolor(ind,:),'facecolor',facecolor(ind,:),...
        'showbaseline','off'),1:ncolor);
  end
else
  % grouped bars - one bar handle per data
  B = bar(x,y,width,'showbaseline','off');
  if ncolor>0
    % set colors for each bar group - this method is roundabout but avoids
    % changing the colormap for the figure.
    arrayfun(@(ind)set(B(ind),'facecolor',facecolor(ind,:),...
      'edgecolor',edgecolor(ind,:)),1:ncolor);
  end
  % infer X position for each y - this is harder than you'd think
  xerr = NaN([ngroup ndata]);
  % for each data
  for b = 1:ndata
    barxs = unique(get(get(B(b),'children'),'xdata'));
    % one x position per group
    xerr(:,b) = mean(reshape(barxs,[2 length(barxs)/2]));
  end
end

if ~isempty(errors) && ~all(isnan(errors(:)))
  if iscol(errors) && nface ~= 1
      errors = errors';
  end
  errsize = size(errors);
  if ~isequal(size(y),size(errors));
    assert(errsize(1)==2,['3d errors inputs must have ' ...
      'positive/negative CI in first dim'])
    % remove mean (probably CIs)
    errpos = squeeze(errors(1,:,:))-y;
    errneg = squeeze(errors(2,:,:))-y;
  else
    errpos = errors;
    errneg = errors;
  end
  hold on
  E = errorbar(xerr(:),y(:),errpos(:),errneg(:),'linestyle','none',...
    'color',errorcolor);
  % kill errorbar caps
  arrayfun(@errorbar_tick,E(:),zeros(numel(E),1));
end

if ~isempty(pvalues) && ~all(isnan(pvalues(:)))
    psize = size(pvalues);
    assert(isequal(size(y),psize));
    ypos = y(:);
    if ~ieNotDefined('errpos')
        ypos = y(:) + errpos(:);
    end
    % pad
    ypos = ypos + (range(ylim) * .02);
    switch lower(pstyle)
        case 'marker'
            t = addpstars(gca,xerr(:)',pvalues(:)',[],'ypos',ypos);
        case 'text'
            t = addptext(xerr(:),ypos,pvalues(:),gca);
        otherwise
            error('unknown pstyle: %s',pstyle);
    end
end

% replot 0 line since Matlab usually messes this up
xlim([x(1)-pad x(end)+pad]);
lh=line(xlim,[0 0],'linewidth',1.2,'color',[0 0 0]);
uistack(lh,'top');
% also insure axis limits are on top of bars - both these are necessary
% when 0 point is not at xlim(1) 
set(gca,'layer','top');

set(gca,'xtick',x,'xticklabel',labels,'tickdir','out','ticklength',...
    get(gca,'ticklength')*.5);
if ~isempty(labels) && rotatelabels~=0
    rotateXLabels(gca,rotatelabels);
end
box off
