% Basic figure with subplot of images in cell array
% f = showimages(images);
function f = showimages(images);

nimages = length(images);
hw = ceil(sqrt(nimages));

f = figurebetter([15 15]);

for n = 1:nimages
    subplot(hw,hw,n);
    imshow(images{n});
end
