% expand the current plot limits to the nearest value with a given
% precision (default 1 decimal point).
%
% ax            gca     axis handle
% axdir         'y'     axis to process ('xy' is also supported)
% specialval    NaN     if present and the limits and any specialval are
%                           outside range we rescale to include it. Can be
%                           scalar or vector.
% precision     1       number of decimal points
% 
% outlim = roundplotlimits(ax,axdir,specialval,precision)
function outlim = roundplotlimits(ax,axdir,specialval,precision)

if ieNotDefined('ax')
    ax = gca;
end

if ieNotDefined('axdir')
    axdir = 'y';
end

if ieNotDefined('precision')
    precision = 1;
end

if ieNotDefined('specialval')
    specialval = NaN;
end

outlim = [];
for thisax = ax(:)'
    axlim = [];
    for thisdir = axdir(:)'
        lim = get(thisax,[thisdir 'lim']);
        lim = [reduceprecision(lim(1),precision,@floor) ...
            reduceprecision(lim(2),precision,@ceil)];
        if lim(2) < max(specialval(:))
            lim(2) = max(specialval(:));
        end
        if lim(1) > min(specialval(:))
            lim(1) = min(specialval(:));
        end
        set(thisax,[thisdir 'lim'],lim);
        axlim = [axlim lim];
    end
    outlim = [outlim; axlim];
end
