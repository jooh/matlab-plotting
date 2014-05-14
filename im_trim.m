% trim background from image. Supports RGB or intensity, any class.
%
% INPUTS:
% inim: 2D or 2D image or cell array of images. If it's a cell array, we
%   trim all images with the union of the individual masks.
%
% OUTPUTS:
% outim: trimmed image or cell array of images
% mask: 2D logical mask in shape of original image
%
% [outim,mask] = im_trim(inim,trimcolor,[medfiltsize])
function [outim,groupmask] = im_trim(inim,trimcolor,medfiltsize)

wascell = true;
if ~iscell(inim)
    inim = {inim};
    wascell = false;
end

nim = numel(inim);
for im = 1:nim
    thisim = inim{im};
    assert(ndims(thisim)<4,'inim must me at most 3D');

    if ieNotDefined('trimcolor')
        trimcolor = thisim(1,1,:);
    end

    % insure all matrices are same type (probably uint8)
    if ~isequal(class(thisim),class(trimcolor))
        trimcolor = feval(class(thisim),trimcolor);
    end

    insize = size(thisim);

    % create an image for matching
    if numel(trimcolor)>1
        trimcolor = reshape(trimcolor,[1 1 numel(trimcolor)]);
    end
    trimim = repmat(trimcolor,insize(1:2));
    % places where the image diverges from the trimcolor
    sumim = all(thisim~=trimim,3);

    % rows
    rowsumimg = sum(sumim,2);
    rowind = find(rowsumimg>0);
    rowmask = false(insize(1:2));
    rowmask(rowind(1):rowind(end),:) = true;

    % columns
    colsumimg = sum(sumim,1);
    colind = find(colsumimg);
    colmask = false(insize(1:2));
    colmask(:,colind(1):colind(end),:) = true;

    mask{im} = rowmask & colmask;
end

% create group mask
groupmask = any(cat(3,mask{:}),3);

% and mask
outim = im_mask(inim,groupmask);

if ~wascell
    outim = outim{1};
end
