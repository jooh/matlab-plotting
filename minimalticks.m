% set the ticks along a given axdir (default y) to a minimal set in axis ax
% (default gxa). We will set ticks for the values at the min/max and a
% scalar specialvalue if present (default 0). Supports multiple axis
% inputs and multiple directions (i.e., axdir='xy'). If precision is
% defined we round the tick marks to this number of decimal points.
%
% minimalticks(ax,axdir,specialvalue,precision)
function minimalticks(ax,axdir,specialvalue,precision)

if ieNotDefined('ax')
    ax = gca;
end

if ieNotDefined('axdir')
    axdir = 'y';
end

if ieNotDefined('specialvalue')
    specialvalue = 0;
end

if ieNotDefined('precision')
    precision = Inf;
end

for thisax = ax(:)'
    for thisdir = axdir(:)'
        lim = get(thisax,[thisdir 'lim']);
        v = lim;

        if specialvalue>lim(1) && specialvalue<lim(2)
            v = [v(1) specialvalue v(2)];
        end


        set(thisax,[thisdir 'lim'],lim,[thisdir 'tick'],v);

        if ~isinf(precision)
            vstr = mat2strcell(v,['%.' num2str(precision,'%.0f') 'f']);
            set(thisax,[thisdir 'ticklabel'],vstr);
        end
    end
end
