% Pad the limits ([y],x,z) of the axis ax by some proportion of the limits
% in lims. Note that to preserve this scaling it is advisable to apply this
% late as some matlab plot functions change the axis limits even when these
% have previously been set manually.
%
% NAMED INPUTS  DEFAULT                 DESCRIPTION
% ax            gca                     axis to target
% axdir         y                       direction (x,y,z)
% padprop       .05                     padding - proportion of range(lims)
% lims          get(ax,[axdir 'lim'])   data limits [min,max]
% precision     1                       number of digits precision
%
% paxaxislims(varargin)
function paxaxislims(varargin)

getArgs(varargin,{'ax',gca,'axdir','y','padprop',.05,'lims',[],...
    'precision',1});

if ieNotDefined('lims')
    lims = get(ax,[axdir 'lim']);
end

axrange = range(lims);

% for the min, it's down
newlims(1) = reduceprecision((2*(lims(1)>0)-1) .* (abs(lims(1)) - ...
    (axrange*padprop/2)),precision,@floor);
% and for the max, it's up
newlims(2) = reduceprecision((2*(lims(2)>0)-1) .* (abs(lims(2)) + ...
    (axrange*padprop/2)),precision,@ceil);

set(ax,[axdir 'lim'],newlims);
