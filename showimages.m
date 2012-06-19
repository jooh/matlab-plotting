% Basic figure with subplot of images in cell array
% call either with cell arrays images and optionally alpha, or with a
% struct array with image and alpha fields.
% f = showimages(images,[alpha]);
function f = showimages(images,alphadata);

% Support calling with a struct array (fields image, alpha)
if nargin==1 && (isstruct(images) || isobject(images))
    try 
        alphadata = {images.alpha};
    catch
        alphadata = [];
    end
    images = {images.image};
end

nimages = length(images);
hw = ceil(sqrt(nimages));

if ieNotDefined('alphadata')
    hasalpha = 0;
else
    hasalpha = 1;
    assert(length(alphadata)==nimages,'n images does not match n alpha');
end

f = figurebetter([15 15]);

for n = 1:nimages
    subplot(hw,hw,n);
    ih = imshow(images{n});
    if hasalpha
        set(ih,'alphadata',alphadata{n});
    end
    title(num2str(n));
end
