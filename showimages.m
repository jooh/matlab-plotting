% Basic figure with subplot of images in cell array
% f = showimages(images,[alpha]);
function f = showimages(images,alphadata);

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
end
