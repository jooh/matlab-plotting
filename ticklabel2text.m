% convert the x and/or yticklabel for an axis to text objects. This is
% useful when the axis is not visible or when more complex text formatting
% is required than what ticklabel supports (e.g. multiple lines, tex
% interpreter). This function does not keep up with subsequent changes to
% the axis so it is best used after limits and ticks have been finalised.
%
% INPUT     DEFAULT     DESCRIPTION
% ax        gca         axis handle
% axdir     'x'         direction to convert - 'x', 'y' or 'xy'
% pad       .01         padding away from axis as proportion of its range
% varargin  -           any further varargin are piped to text
%
% OUTPUT                DESCRIPTION
% h                     text handle
%
% h = ticklabel2text(ax,axdir,pad,varargin)
function h = ticklabel2text(ax,axdir,pad,varargin)

if ieNotDefined('ax')
    ax = gca;
end

if ieNotDefined('axdir')
    axdir = 'x';
end

if ieNotDefined('pad')
    pad = .01;
end

d = 'xy';
assert(~any(setdiff(axdir,d)),'axdir must be x, y or xy');

h = [];
for thisd = axdir(:)'
    notd = d(d~=thisd);
    varpos = get(ax,[thisd 'tick']);
    otherlim = get(ax,[notd 'lim']);
    % work out where the labels are - this depends on axislocation AND
    % direction
    isnormal = strcmp(get(ax,[notd 'dir']),'normal');
    isleftbottom = any(strcmp(get(ax,[notd 'axisLocation']),{'left',...
        'bottom'}));
    if isnormal
        fixpos = otherlim(1);
        thispad = -pad;
    else
        fixpos = otherlim(2);
        thispad = pad;
    end
    if isleftbottom
        halign = 'right';
        valign = 'top';
    else
        halign = 'left';
        valign = 'bottom';
    end
    % pad the fixed dimension
    fixpos = fixpos + range(otherlim)*thispad;
    fixpos = repmat(fixpos,size(varpos));
    if thisd=='x'
        pos.x = varpos;
        pos.y = fixpos;
        halign = 'center';
    else
        pos.x = fixpos;
        pos.y = varpos;
        valign = 'middle';
    end
    labels = get(ax,[thisd 'ticklabel']);
    h = [h; text(pos.x,pos.y,labels,...
        'horizontalalignment',halign,...
        'verticalalignment',valign,varargin{:})];
    set(ax,[thisd 'ticklabel'],[]);
end
