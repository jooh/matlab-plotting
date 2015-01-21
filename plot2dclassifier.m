% visualise the classifier boundary for the 2d weights vector w.
%
% INPUT     DEFAULT     DESCRIPTION
% axhand    gca         axis handle to plot into
% w         -           2d [x y] weights vector 
% w0        -           2d [x y] bias point
% npoint    256         number of points to interpolate over
% cmap      cmap_bwr    color map for distance visualisation
% color     [1 1 1]     color for discriminant line
%
% OUTPUT
% b     handle to discriminant boundary line
% h     handle to image of discriminant distance
%
% [b,h] = plot2dclassifier(axhand,w,w0,npoint,cmap,color);
function [b,h] = plot2dclassifier(axhand,w,w0,npoint,cmap,linecolor);

if ieNotDefined('axhand')
    axhand = gca;
end

if ieNotDefined('npoint')
    npoint = 256;
end

if ieNotDefined('cmap')
    cmap = cmap_bwr;
end

if ieNotDefined('linecolor')
    linecolor = [0 0 0];
end

washold = ishold(axhand);
hold(axhand,'on');
ax = axis(axhand);
% cook up test values that tile the current axis
xvals = linspace(ax(1),ax(2),npoint);
yvals = linspace(ax(3),ax(4),npoint);
[xx,yy] = meshgrid(xvals,yvals);
gridX = [xx(:) yy(:)];
% get the classifier's prediction for these values
% (not 100% sure why subtracting w0 works here - should be the other way
% around).
discval = gridX * w' - w0;
discmat = reshape(discval,[npoint,npoint]);
maxint = max(abs(discval));
discim = intensity2rgb(discmat,cmap,[-maxint maxint]);
% make sure boundary is halfway through the colour map
h = image(xvals,yvals,discim,'parent',axhand);
[~,b] = contour(xvals,yvals,discmat,[0 0],...
    'color',linecolor,'linewidth',1,'parent',axhand);
uistack(b,'bottom');
uistack(h,'bottom');
if ~washold
    hold(axhand,'off');
end
axis(axhand,ax);
