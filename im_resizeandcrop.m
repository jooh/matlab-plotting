% resize image but crop back to original dimensions. So if the size is
% reduced the background will be expanded, relatively speaking, and if the
% size is increased edges will get cropped away. This is useful for
% changing the relative size of an isolated object without changing the
% overall image outline.
%
% im: image (3d)
% bgcolor: background intensity (inferred from top left corner if
%   undefined)
% varargin: input arguments for imresize
%
% final = im_resizeandcrop(im,bgcolor,varargin)
function final = im_resizeandcrop(im,bgcolor,varargin)

if ieNotDefined('bgcolor')
    bgcolor = im(1,1,:);
end
% ensure stacked in third dim
bgcolor = reshape(bgcolor,[1 1 numel(bgcolor)]);


orgsize = size(im);
resized = imresize(im,varargin{:});

final = im_canvas(resized,orgsize,bgcolor);
