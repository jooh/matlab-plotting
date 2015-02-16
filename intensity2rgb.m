% convert a 2D intensity image to RGB values according to colormap cmap.
%
% imshow(im) produces identical graphical output to imagesc(mat) if the
% colormap contains the same number of entries as the number of unique
% intensities in mat. If this is not the case there will be minor
% divergences due to different interpolation, but for any sensible
% colormap these divergences will be very small. To minimise any confusion
% it is always safest to use this function with colorbarbetter when
% plotting.
%
% INPUT     DEFAULT     DEFINITION
% mat       -           some 2d numerical matrix
% cmap      cmap_bwr    color map
% limits    []          clipping limits for map (2 element vector). If
%                           undefined we use the data limits. If set to
%                           'symmetrical', we balance the positive and
%                           negative color range by setting the limits to
%                           [-absmax +absmax]
% greythresh -Inf      values below this threshold are converted to
%                           greyscale
%
% [im,intmap,cmap] = intensity2rgb(mat,[cmap],[limits],[greythresh])
function [im,intmap,cmap] = intensity2rgb(mat,cmap,limits,greythresh)

assert(ndims(mat)==2,'input mat must be 2d, got %dd',ndims(mat))

if ieNotDefined('greythresh')
    % no gray scale
    greythresh = -Inf;
end

% get all unique intensities
umat = unique(mat(:));
% (stripping nans)
umat(isnan(umat)) = [];
nu = length(umat);

if ieNotDefined('cmap')
    cmap = cmap_bwr;
end

if ieNotDefined('limits')
    limits = [min(mat(:)) max(mat(:))];
elseif strcmp(limits,'symmetrical')
    m = max(abs(mat(:)));
    limits = [-m m];
elseif strcmp(limits,'zerobounded')
    m = max(mat(:));
    assert(m>0,...
        'zerobounded is only possible if there are positive values');
    limits = [0 m];
end

if ieNotDefined('nancolor')
    nancolor = [1 1 1];
end

ncolor = size(cmap,1);

% these are the intensities in the colour map. We want whatever is closest
intmap = linspace(limits(1),limits(2),ncolor);

% greyscale and muted colormap
gmap = repmat(mean(cmap,2),[1 3]) * .9;
cmap(intmap<greythresh,:) = gmap(intmap<greythresh,:);

% put in final, white entry to represent NaNs
cmap(end+1,:) = [1 1 1];

% convert the image intensities to the range of the color map indices
% matscaled = round(normalizerange(mat,1,ncolor));
% index final, white color for NaNs
% nanmask = isnan(mat);
% matscaled(nanmask) = ncolor+1;
im = zeros([size(mat) 3]);
nanmat = isnan(mat);
for r = 1:size(mat,1)
    for c = 1:size(mat,2)
        % closest colour
        if nanmat(r,c)
            ind = ncolor+1;
        else
            [~,ind] = min(abs(mat(r,c)-intmap));
        end
        im(r,c,:) = cmap(ind,:);
    end
end

if nargout > 2
    % also return the colormap, but without the NaN entry
    cmap(end,:) = [];
end
