% Basic figure with subplot of images in cell array
% call either with cell arrays images and optionally alpha, or with a
% struct array with image and alpha fields. dims gives rows and columns if
% you have a specific shape in mind
% f = showimages(images,[alpha],[dims]);
function f = showimages(images,alphadata,dims,plotfun);

% Support calling with a struct array (fields image, alpha)
if (isstruct(images) || isobject(images))
    try 
        alphadata = {images.alpha};
    catch
        alphadata = [];
    end
    images = {images.image};
end

nimages = length(images);

if ieNotDefined('dims')
    dims = repmat(ceil(sqrt(nimages)),[1 2]);
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

for n = 1:nimages
    subplot(dims(1),dims(2),n);
    ih = feval(plotfun,images{n});
    if hasalpha
        set(ih,'alphadata',alphadata{n});
    end
    title(num2str(n));
end
