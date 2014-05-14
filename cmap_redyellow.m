function m = cmap_redyellow(n)

if ieNotDefined('n')
    n = 1024;
end
basecolors = [255,255,178;
    254,217,118;
    254,178,76;
    253,141,60;
    252,78,42;
    227,26,28;
    177,0,38];
% ops
basecolors = basecolors(end:-1:1,:);

% increase contrast
% basecolors = basecolors - min(basecolors(:));

% normalise 
basecolors = basecolors - min(basecolors(:));
basecolors = basecolors ./ max(basecolors(:));

% scale and mute slightly
m = colorScale(basecolors,n) * .95;
