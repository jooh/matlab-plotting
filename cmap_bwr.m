function m = cmap_bwr(n)

if ieNotDefined('n')
    n = 1024;
end

basecolors= [178,24,43;
    214,96,77;
    244,165,130;
    253,219,199;
    247,247,247;
    209,229,240;
    146,197,222;
    67,147,195;
    33,102,172];
    
% ops
basecolors = basecolors(end:-1:1,:);

% increase contrast
% basecolors = basecolors - min(basecolors(:));

% normalise 
basecolors = basecolors - min(basecolors(:));
basecolors = basecolors ./ max(basecolors(:));


% scale and mute slightly
m = colorScale(basecolors,n) * .95;
