% apply some logical mask to image(s). 
%
% INPUTS: 
% inim: image or cell array of images
% mask: 2D logical array that returns sensible indices (ie, rectangular)
%
% OUTPUT:
% outim: image or cell array of images
%
% outim = im_mask(inim,mask)
function outim = im_mask(inim,mask)

wascell = true;
if ~iscell(inim)
    inim = {inim};
    wascell = false;
end

% [grouprowind,groupcolind] = ind2sub(size(mask),find(mask~=0));
% this uses far less memory
maskrows = find(any(mask,2));
maskcols = find(any(mask,1));

for im = 1:length(inim)
    outim{im} = inim{im}(maskrows,maskcols,:);
end

if ~wascell
    outim = outim{1};
end
