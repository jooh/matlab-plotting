% draw outlines around each blob in the binary 2D image im. All varargin
% are passed to line.
%
% h = imoutline(im,varargin)
function h = imoutline(im,varargin)
    
if ~any(im(:))
    h = NaN;
    return;
end

imageDims = size(im);
% get coordinates of hits and rescore to custom grid
[y,x] = find(im);
y = y';
x = x';

doPerimeter = 1;

% code from mrtools - refreshMLRDisplay

% first get positions of all vertical lines
% this includes one on either side of each voxel
% and then make that into a linear coordinate
% and sort them. Note the +1 on imageDims
% is to allow for voxels that are at the edge of the image
% also notice the flip of the imageDims and switching
% of y and x. This is so that we can get consecutive line
% segments (see below).
vlines = sort(sub2ind(fliplr(imageDims)+1,[y y],[x x+1]));
% now we look for any lines that are duplicates
% that means they belong to two voxels, so that
% they should not be drawn. we look for duplicates
% as ones in which the voxel number is the same
% as the next one in the list.
duplicates = diff(vlines)==0;
% and add the last one in.
duplicates = [duplicates 0];
if doPerimeter
  % make sure to score both copies as duplicates
  % only necessary for perimeter drawing, for
  % drawing all boundaries, we need to keep
  % at least one
  duplicates(find(duplicates)+1) = 1;
end
% now get everything that is not a duplicate
vlines = vlines(~duplicates);
% now we look for consecutive line segments
% so that we can just draw a single line. This
% speeds things up because each line segment
% that matlab draws is an independent child
% and reducing the number of things it has
% to keep track of helps things out a lot.
% so, first we look for the start of a line.
% this is any index which the difference from
% its neighbor is greater than one (i.e.
% the next vertical line being drawn does not
% happen in the next voxel).
vlinesBottom = vlines(diff([vlines inf])~=1);
% now we flip everything and look for the other
% end of the line in the same way.
vlinesflip = fliplr(vlines);
vlinesTop = fliplr(vlinesflip(diff([vlinesflip inf])~=-1));
% now convert the top and bottom coordinates back
% to image coordinates
[vty vtx] = ind2sub(fliplr(imageDims)+1,vlinesTop);
[vby vbx] = ind2sub(fliplr(imageDims)+1,vlinesBottom);
% now do the same for the horizontal lines
hlines = sort(sub2ind(imageDims+1,[x x],[y y+1]));
duplicates = diff(hlines)==0;
duplicates = [duplicates 0];
if doPerimeter
  duplicates(find(duplicates)+1) = 1;
end
hlines = hlines(~duplicates);
hlinesRight = hlines(diff([hlines inf])~=1);
hlinesflip = fliplr(hlines);
hlinesLeft = fliplr(hlinesflip(diff([hlinesflip inf])~=-1));
[hlx hly] = ind2sub(imageDims+1,hlinesLeft);
[hrx hry] = ind2sub(imageDims+1,hlinesRight);
% and make them into lines (draw -0.5 and +0.5 so
% that we draw around the pixel not through the center
% and note that x/y are flipped
lines.x = [vty-0.5 hly-0.5;vby+0.5 hry-0.5];
lines.y = [vtx-0.5 hlx-0.5;vbx-0.5 hrx+0.5];

% / mrtools code

% now just plot
h = line(lines.x,lines.y,varargin{:});
