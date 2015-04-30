% white-blue colormap. From colorbrewer2.org. Two-tone version of cmap_bwr.
%
% m = cmap_wb(n)
function m = cmap_wb(n)

if ieNotDefined('n')
    n = 1024;
end

basecolors= [247,247,247;
    209,229,240;
    146,197,222;
    67,147,195;
    33,102,172;
    5,48,97];
    
% normalise 
%basecolors = basecolors - min(basecolors(:));
basecolors = basecolors ./ 255;

m = colorScale(basecolors,n);
