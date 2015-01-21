% [lhand,newy] = contrastlines(ax,pmat,ypos,xpos)
function [lhand,newy] = contrastlines(ax,pmat,ypos,xpos)

assert(isrdm(pmat),'input must be a valid RDM');

if ieNotDefined('ax')
    ax = gca;
end

if ieNotDefined('ypos')
    ypos = max(ylim(ax));
end

ncon = size(pmat,1);
if ieNotDefined('xpos')
    xpos = 1:ncon;
end

newy = ypos;
yshift = range(ylim(ax)) * .05;
cap = yshift/2;

% get the unique dissimilarities
pmat = tril(pmat,-1);
% indices to reasonable lines
[xstart,xend] = find(~isnan(pmat) & pmat~=0);
% we want to draw the longest lines first (I think)
[~,ind] = sort(abs(xstart-xend),1,'ascend');
xs = xpos(xstart(ind));
xe = xpos(xend(ind));

lhand = [];
for x = 1:numel(ind)
    % increment y
    newy = newy + yshift;
    lhand(end+1) = line([xs([x x]) xe([x x])],...
        [newy-cap newy newy newy-cap],...
        'color',[0 0 0],'linewidth',.5);
end
