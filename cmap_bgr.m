function m = cmap_bgr(n)

if ieNotDefined('n')
    n = 1024;
end

basecolors= [213,62,79;
    244,109,67;
    253,174,97;
    254,224,139;
    255,255,191;
    230,245,152;
    171,221,164;
    102,194,165;
    50,136,189];
    
% ops
basecolors = basecolors(end:-1:1,:);

% increase contrast
basecolors = basecolors - min(basecolors(:));
basecolors = basecolors ./ max(basecolors(:));
% mute slightly to kill off brightest yellows
basecolors = basecolors .* .95;

m = colorScale(basecolors,n);
