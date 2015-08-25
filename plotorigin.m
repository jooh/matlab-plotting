% Add origin lines to the axis ax (default gca). Scales with x/ylim so set
% these first. Any varargin are passed as inputs to line. The defaults are
% {'linestyle',':','color',[0 0 0],'linewidth',.5}.
%
% p = plotorigin([ax],[varargin])
function p = plotorigin(ax,varargin)

if ieNotDefined('ax')
    ax = gca;
end

args = varargin;
if isempty(args)
    args = {'linestyle',':','color',[0 0 0],'linewidth',.5};
end

dims = {'x','y'};
toplot.x = [];
toplot.y = [];
for thisdim = {'x','y'}
    notd = setdiff(dims,thisdim);
    lim = get(ax,[thisdim{1} 'lim']);
    if min(lim) < 0 && max(lim) > 0
        % need to plot this dim
        toplot.(thisdim{1}) = [toplot.(thisdim{1}) zeros(2,1)];
        toplot.(notd{1}) = [toplot.(notd{1}) get(ax,[notd{1} 'lim'])'];
    end
end

p = line(toplot.x,toplot.y,args{:});
uistack(p(:),'bottom');
