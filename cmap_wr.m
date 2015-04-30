% white-red colormap. From colorbrewer2.org.
%
% m = cmap_wr(n)
function m = cmap_wr(n)

if ieNotDefined('n')
    n = 1024;
end

basecolors= [103,0,31;
    178,24,43;
    214,96,77;
    244,165,130;
    253,219,199;
    247,247,247];
    
% ops
basecolors = basecolors(end:-1:1,:);

% normalise 
basecolors = basecolors ./ 255;

m = colorScale(basecolors,n);
