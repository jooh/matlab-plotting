% convert a 2D intensity image to RGB values according to colormap cmap.
%
% cmap defaults to jet(nunique) where nunique is the number of unique
% entries in mat or 1e3, whichever is less. This colormap is optionally
% returned for making colorbars and such.
%
% imshow(im) produces identical graphical output to imagesc(mat) if the
% colormap contains the same number of entries as the number of unique
% intensities in mat. If this is not the case there will be minor
% divergences due to different interpolation, but for any sensible
% colormap these divergences will be very small. To minimise any confusion
% it is always safest to make your own colorbar.
%
% [im,intmap,cmap] = intensity2rgb(mat,[cmap])
function [im,intmap,cmap] = intensity2rgb(mat,cmap)

assert(ndims(mat)==2,'input mat must be 2d, got %dd',ndims(mat))

umat = unique(mat(:));
nu = length(umat);
if ieNotDefined('cmap')
    cmap = jet(min([nu 1e3]));
end

ncolor = size(cmap,1);
% put in final, white entry to represent NaNs
cmap(end+1,:) = [1 1 1];

matscaled = round(normalizerange(mat,1,ncolor));
% index final, white color for NaNs
nanmask = isnan(mat);
matscaled(nanmask) = ncolor+1;
im = zeros([size(mat) 3]);
for r = 1:size(mat,1)
    for c = 1:size(mat,2)
        im(r,c,:) = cmap(matscaled(r,c),:);
    end
end

if nargout > 1
    % return the intensities for each level
    intmap = umat(round(linspace(1,nu,ncolor)));
end

if nargout > 2
    % also return the colormap, but without the NaN entry
    cmap(end,:) = [];
end
