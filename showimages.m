% Basic figure with subplot of images in cell array / struct / matrix
%
% INPUT     DEFAULT     DEFINITION
% images        -                       cell array, struct arrage (with image
%                                           and possibly alpha fields), matrix
%                                           (3D or 4D with image index along
%                                           final dim)
% alpha         []                      alpha layer (cell array)
% dims          ceil(sqrt(nimages))     subplot dimensions
% plotfun       @image                  function to call to make plots. @imagesc
%                                           is a good alternative.
% donumbers     true                    show image number in title field
%
% [f,ax] = showimages(images,[alpha],[dims],[plotfun],[donumbers]);
function [f,ax]= showimages(images,alphadata,dims,plotfun,donumbers);

% Support calling with a struct array (fields image, alpha)
if (isstruct(images) || isobject(images))
    if isfield(images,'alpha')
        alphadata = {images.alpha};
    end
    images = {images.image};
elseif isnumeric(images)
    imsize = size(images);
    switch ndims(images)
        case {2,3}
            % assume you stacked images in third dim
            images = mat2cell(images,imsize(1),imsize(2),ones(1,imsize(3)));
        case 4
            % assume 4th dim
            assert(imsize(3)==3,...
                'input matrix images must have 3 entries along third dim (RGB)');
            images = mat2cell(images,imsize(1),imsize(2),imsize(3),ones(1,imsize(4)));
        otherwise
            error('unknown dimensionality for input images: %d',ndims(images));
    end
end

nimages = length(images);

if ieNotDefined('dims')
    dims = repmat(ceil(sqrt(nimages)),[1 2]);
end

if ieNotDefined('donumbers')
    donumbers = true;
end

if ieNotDefined('alphadata')
    hasalpha = 0;
else
    hasalpha = 1;
    assert(length(alphadata)==nimages,'n images does not match n alpha');
end

if ieNotDefined('plotfun')
    plotfun = 'imshow';
end

f = figurebetter([15 15]);

ax = NaN([1,nimages]);
for n = 1:nimages
    ax(n) = subplot(dims(1),dims(2),n);
    ih = feval(plotfun,images{n});
    if hasalpha
        set(ih,'alphadata',alphadata{n});
    end
    if donumbers
        title(num2str(n));
    end
end
