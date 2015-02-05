% Pad the limits ([y],x,z) of the axis ax by some proportion of the limits
% in lims. Note that to preserve this scaling it is advisable to apply this
% late as some matlab plot functions change the axis limits even when these
% have previously been set manually.
%
% NAMED INPUTS  DEFAULT                 DESCRIPTION
% ax            gca                     axis to target
% axdir         y                       direction (x,y,z or xy)
% padprop       .05                     padding - proportion of range(lims)
% lims          get(ax,[axdir 'lim'])   data limits [min,max]
%
% paxaxislims(varargin)
function paxaxislims(varargin)

getArgs(varargin,{'ax',gca,'axdir','y','padprop',.05,'lims',[]});

if strcmp(axdir,'xy')
    if ieNotDefined('lims')
        lims = axis(ax);
    end
    if isvector(lims)
        lims = reshape(lims,[2 2]);
    end
else
    if ieNotDefined('lims')
        lims = get(ax,[axdir 'lim'])';
    end
end

axrange = range(lims);
padval = axrange*padprop/2;

% so now it's just
newlims = lims + [-padval; padval];

if strcmp(axdir,'xy')
    axis(ax,newlims(:));
else
    set(ax,[axdir 'lim'],newlims);
end
