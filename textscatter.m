% plot scatter where text strings are used as markers into gca.
%
% INPUTS:
% xy: coordinates - can by xy or xyz in columns
% thand: cell array of strings
% colors: default [0 0 0]. If size(colors,1) matches numel(x) we plot each
%   text string (and maybe marker) in the specified color.
% plotmarker: default false. If true, we plot a . at each x,y coordinate
%   and shift the text labels over.
%
% OUTPUTS:
% thand: handles to text objects
% p: handles to markers
%
% [thand,p] = textscatter(xy,t,[colors],plotmarker)
function [thand,p] = textscatter(xy,t,colors,plotmarker)

% p may be left undefined if ~plotmarker
p = [];

% text fails in mysterious ways with single inputs
xy = double(xy);

% handle single char t inputs
if ischar(t)
    t = {t};
end
switch numel(t)
    case 1
        % support plotting the same text label multiple times
        t = repmat(t,[1,size(xy,1)]);
    case size(xy,1)
        % all good
    otherwise
        error('numel(t) does not match size(xy,1)');
end

% skip nans
nans = any(isnan(xy),2);
xy(nans,:) = [];
t(nans) = [];
n = size(xy,1);
% number of dimensions to plot over
nd = size(xy,2);

% track hold state
changedhold = false;
if ~ishold
    hold on;
    changedhold = true;
end

% if we are plotting a marker the text needs to shift away from center
if ieNotDefined('plotmarker')
    plotmarker = false;
end
if plotmarker
    halign = 'right';
    valign = 'bottom';
    % add space to clear the marker
    t = cellfun(@(thist)[thist '  '],t,'uniformoutput',0);
else
    halign = 'center';
    valign = 'middle';
end

% handle 2D or 3D plots
switch nd
    case 2
        plotter = @(p,co)plot(p(:,1),p(:,2),'o','markerfacecolor',co,...
            'markeredgecolor','none');
        texter = @(p,t,co)text(p(:,1),p(:,2),t,'horizontalalignment',...
            halign,'verticalalignment',valign,'color',co);
    case 3
        plotter = @(p,co)plot3(p(:,1),p(:,2),p(:,3),'o',...
            'markerfacecolor',co,'markeredgecolor','none');
        texter = @(p,t,co)text(p(:,1),p(:,2),p(:,3),t,...
            'horizontalalignment',halign,'verticalalignment',valign,...
            'color',co);
    otherwise
        error('unsupported input dimensionality: %d',nd);
end

if ieNotDefined('colors')
    colors = [0 0 0];
elseif size(colors,1)>1
    colors(nans,:) = [];
end

if ~plotmarker
    % invisible plot to get axis limits set properly
    p = plotter(xy,[1 1 1]);
    set(p,'linestyle','none','marker','none');
end

if size(colors,1)==1
    % one call will do
    thand = texter(xy,t,colors);
    if plotmarker
        p = plotter(xy,colors);
    end
else
    for ind = 1:n
        thand(ind) = texter(xy(ind,:),t(ind),colors(ind,:));
        if plotmarker
            p(ind) = plotter(xy(ind,:),colors(ind,:));
        end
    end
end

% we assume you want the text on top
uistack(thand,'top')

if changedhold
    hold off;
end
