% plot scatter where text strings are used as markers into gca.
%
% INPUTS:
% x: coordinates
% y: coordinates
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
% [thand,p] = textscatter(x,y,t,[colors],plotmarker)
function [thand,p] = textscatter(x,y,t,colors,plotmarker)

thand = [];
p = [];

% skip nans
nans = isnan(x) | isnan(y);
x(nans) = [];
y(nans) = [];
t(nans) = [];
n = numel(x);

if ischar(t)
  t = {t};
end

if numel(t) == 1
  % support plotting the same text label multiple times
  t = repmat(t,[1,numel(x)]);
end

if ieNotDefined('colors')
  colors = [0 0 0];
elseif size(colors,1)>1
  colors(nans,:) = [];
end

if ieNotDefined('plotmarker')
  plotmarker = false;
end

changedhold = false;
if ~ishold
  hold on;
  changedhold = true;
end

if plotmarker
  halign = 'right';
  valign = 'bottom';
else
  % invisible plot to get axis limits set properly
  p = plot(x,y,'marker','none','linestyle','none');
  halign = 'center';
  valign = 'middle';
end

thand = text(x,y,t,'horizontalalignment',halign,'verticalalignment',valign);
if size(colors,1)==1
  set(thand,'color',colors);
  if plotmarker
    p = plot(x,y,'.','color',colors);
  end
else
  for ind = 1:n
    set(thand(ind),'color',colors(ind,:));
    if plotmarker
      p(ind) = plot(x(ind),y(ind),'.','color',colors(ind,:));
    end
  end
end

if changedhold
  hold off;
end

