% scale the height and/or width of axis ax by some scale factor multiplied
% by the range of the data in x and/or y. This normalisation ensures that
% plot objects are the same size across panels that may vary in
% data range. 
%
% The typical application is to ensure that bars appear the same width
% across axes that vary in the number of bars that are plotted (here you
% would use dim='x').
%
% To obtain a scalef from a reference axis, try e.g.
% p = get(ax,'position');
% % for scaling in both X and Y.
% scalef = p(3:4) ./ range(reshape(axis(ax),[2 2]));
%
% INPUTS
% ax        axis handle
% dim       dim to process ('x','y' or 'xy')
% scalef    scale factor (1 unit data in figure units).
%
% scaleaxbydata(ax,dim,scalef)
function scaleaxbydata(ax,dim,scalef)

p = get(ax,'position');
dimnum = [3 4];
% deal with 'yx' inputs
dim = sort(dim);
% convert 'xy' inputs to indices into p
loginds = dim == 'xy';

% get data limits
ranges = range(reshape(axis(ax),[2 2]));
% scale up according to data limits
newp = scalef .* ranges(loginds);

inds = dimnum(loginds);
p(inds) = newp;
set(ax,'position',p);
