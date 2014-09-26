% set the ticks along a given axdir (default y) to a minimal set in axis ax
% (default gxa). We will set ticks for the values at the min/max and a
% scalar specialvalue if present (default 0).
%
% minimalticks(ax,axdir,specialvalue)
function minimalticks(ax,axdir,specialvalue)

if ieNotDefined('ax')
    ax = gca;
end

if ieNotDefined('axdir')
    axdir = 'y';
end

if ieNotDefined('specialvalue')
    specialvalue = 0;
end

lim = get(ax,[axdir 'lim']);
v = lim;

if specialvalue>lim(1) && specialvalue<lim(2)
    v = [v(1) specialvalue v(2)];
end

set(ax,[axdir 'lim'],lim,[axdir 'tick'],v);
