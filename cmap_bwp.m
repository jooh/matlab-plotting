% blue-white-purple diverging colormap. From colorbrewer2.org (slightly
% modified)
%
% m = cmap_bwp(n)
function m = cmap_bwp(n)

if ieNotDefined('n')
    n = 1024;
end

basecolors = [158,1,66;
    213,62,79;
    244,109,67;
    253,174,97;
    254,224,139;
    247,247,247;
    230,245,152;
    171,221,164;
    102,194,165;
    50,136,189;
    94,79,162];
    
% ops
basecolors = basecolors(end:-1:1,:);

% increase contrast
% basecolors = basecolors - min(basecolors(:));

% normalise 
%basecolors = basecolors - min(basecolors(:));
basecolors = basecolors ./ 255;

m = colorScale(basecolors,n);
