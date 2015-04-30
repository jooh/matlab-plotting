% expand the current plot limits to the nearest value with a given
% precision (default 1 decimal point).
%
% ax            gca     axis handle
% axdir         'y'     axis to process ('xy' is also supported)
% specialvalue  NaN     if present and the limits are outside this range we
%                           rescale to include it
% precision     1       number of decimal points
% 
% outlim = roundplotlimits(ax,axdir,specialvalue,precision)
function outlim = roundplotlimits(ax,axdir,specialvalue,precision)

if ieNotDefined('ax')
    ax = gca;
end

if ieNotDefined('axdir')
    axdir = 'y';
end

if ieNotDefined('precision')
    precision = 1;
end

if ieNotDefined('specialvalue')
    specialvalue = NaN;
end

outlim = [];
for thisax = ax(:)'
    for thisdir = axdir(:)'
        lim = get(thisax,[thisdir 'lim']);
        lim = [reduceprecision(lim(1),precision,@fix) ...
            reduceprecision(lim(2),precision,@ceil)];
        if lim(2)<specialvalue
            lim(2) = specialvalue;
        end
        if lim(1)>specialvalue
            lim(1) = specialvalue;
        end
        set(thisax,[thisdir 'lim'],lim);
    end
    outlim = [outlim lim];
end
