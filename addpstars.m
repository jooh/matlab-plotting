% plot colored symbols (by default asterisks) into the axis. This is useful
% for illustrating significant effects in overlapping plots (e.g. line
% graphs).
%
% INPUTS:
% ax - default gca
% xs - x positions (we ignore NaN entries)
% pmat - condition by nx matrix of p stats
% cmat - condition by rgb matrix of colours
% ypos - position in y 
%
% NAMED INPUTS:
% sigthresh - default .05
% sigsym - default '*'
% 
% t = addpstars(ax,xs,pmat,cmat,varargin)
function t = addpstars(ax,xs,pmat,cmat,varargin)

getArgs(varargin,{'sigthresh',.05,'sigsym','*','fontsize',10,...
  'ypos',max(get(ax,'ylim'))});

nx = size(pmat,2);
np = size(pmat,1);
if numel(ypos)==1
  ypos = repmat(ypos,[1 nx]);
end
pstr = repmat({''},[1 nx]);
for x = 1:size(pmat,2)
  pv = pmat(:,x);
  for y = 1:np
    if pmat(y,x)<sigthresh
      pstr{x} = [pstr{x} sprintf('{\\color[rgb]{%f %f %f}%s}',cmat(y,1),...
        cmat(y,2),cmat(y,3),sigsym)];
    end
  end
end
t = text(xs(~isnan(xs)),ypos(~isnan(ypos)),pstr,'verticalalignment',...
  'bottom','horizontalalignment','center');
