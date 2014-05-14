% alpha = im_isolatebiggest(im,varargin)
function alpha = im_isolatebiggest(im,varargin)

getArgs(varargin,{'alpha',ones(size(im)),'medfiltsize',[10 10]});

% the median filter is good for cleaning up the binarised images
CC = bwconncomp(medfilt2(im,medfiltsize));
numpix = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numpix);
alpha(CC.PixelIdxList{idx}) = 0;
