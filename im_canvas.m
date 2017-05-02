% Set the size of the background canvas by padding or cropping equally on
% all sides. Replaces expandbackground.
%
% im: 2d or 3d array
% orgsize: desired canvas size
% bgcolor: color to use for padding. If undefined, we infer from top left
%   pixel.
%
% final = im_canvas(im,orgsize,bgcolor)
function final = im_canvas(im,orgsize,bgcolor)

if ieNotDefined('bgcolor')
    bgcolor = im(1,1,:);
end
% ensure stacked in third dim
bgcolor = reshape(bgcolor,[1 1 numel(bgcolor)]);

newsize = size(im);
if numel(newsize)==2
    newsize(3) = 1;
end
nd = numel(newsize);
od = numel(orgsize);
if od < nd
    orgsize(od+1:nd) = newsize(od+1:nd);
end

expd = orgsize-newsize;
% if the new canvas is smaller, we need to expand the canvas before
% circshifting (otherwise, these arrays are all empty and nothing happens)
% coloured fills
right = bsxfun(@times,ones([newsize(1),expd(2),newsize(3)],'like',bgcolor),...
    bgcolor);
bottom = bsxfun(@times,ones([expd(1),newsize(2),newsize(3)],'like',bgcolor),...
    bgcolor);
bottomright = bsxfun(@times,ones([expd(1),expd(2),newsize(3)],'like',bgcolor),...
    bgcolor);
expanded = [im right; ...
    bottom bottomright];

shifted = circshift(expanded,floor(expd/2));
final = shifted(1:orgsize(1),1:orgsize(2),:);
