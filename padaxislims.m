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
% specialvalue  0                       when one of the lims is this, we
%                                           don't pad
%
% newlims = padaxislims(varargin)
function newlims = padaxislims(varargin)

getArgs(varargin,{'ax',gca,'axdir','y','padprop',.05,'lims',[],...
    'specialvalue',0});

if strcmp(axdir,'xy')
    if ieNotDefined('lims')
        lims = axis(ax);
    end
    if isvector(lims)
        lims = reshape(lims,[2 2]);
    end
else
    if ieNotDefined('lims')
        lims = get(ax,[axdir 'lim']);
    end
    lims = lims(:);
end

axrange = range(lims);
padval = axrange*padprop/2;

padneg = -padval;
padpos = padval;
padneg(lims==specialvalue) = 0;
padpos(lims==specialvalue) = 0;

% so now it's just
newlims = lims + [padneg; padpos];

if strcmp(axdir,'xy')
    axis(ax,newlims(:));
else
    set(ax,[axdir 'lim'],newlims);
end
