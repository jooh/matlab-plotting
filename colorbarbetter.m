% create a colorbar in the axis ax. Unlike Matlab colorbar, we don't try to
% be fancy and create a new axis - axis ax is literally a colorbar. Also we
% provide better control over color scale, and since we don't use the
% global colormap it becomes possible to have plots with multiple maps in
% the same figure.
%
% For reference intmap / cmap, see intensity2rgb.
%
% in general, intmap should either have the same number of entries as rows
% in cmap, or should have precisely 2, in which case we assume you want a
% linear mapping between these 2.
%
% named, optional inputs:
% orientation: {'vertical'} 'horizontal'
% label: ''
% tick: {'minimal'} or vector
% ticklabel: {}
% aspectratio: {5} gets converted to [aspectratio 1 1] or [1 aspectratio 1]
% scale: {.25} argument to axscale
%
% c = colorbarbetter(ax,intmap,cmap,[varargin])
function c = colorbarbetter(ax,intmap,cmap,varargin)

if ieNotDefined('ax')
    ax = gca;
end

getArgs(varargin,{'orientation','horizontal','label','','tick','minimal',...
    'ticklabel',{},'aspectratio',5,'scale',.25});
nc = size(cmap,1);

if numel(intmap)==2
        % assume you mean a linear mapping
        intmap = linspace(intmap(1),intmap(2),nc); 
else 
    assert(nc == numel(intmap),'intmap does not match cmap!');
end

axis(ax);
switch lower(orientation)
    case 'vertical'
        x = ones(nc,1);
        y = intmap;
        ar = [1 aspectratio 1];
        cmap = reshape(cmap,[nc 1 3]);
        o = 'y';
        noto = 'x';
    case 'horizontal'
        x = intmap;
        y = ones(nc,1);
        ar = [aspectratio 1 1];
        cmap = reshape(cmap,[1 nc 3]);
        o = 'x';
        noto = 'y';
    otherwise
        error('unknown orientation: %s',orientation)
end
c = image(x,y,cmap);
set(ax,'ydir','normal','plotboxaspectratio',ar,'dataaspectratiomode',...
    'auto');
if ~isempty(tick)
    if any(strfind(lower(tick),'min'))
        tickval = [min(intmap) max(intmap)];
        % insert 0 if we pass through it
        if strcmp(lower(tick),'minimal') && (tickval(1) * tickval(2)) < 0
            tickval = [tickval(1) 0 tickval(2)];
        end
    else
        tickval = tick;
    end
    set(ax,[o 'tick'],tickval);
end
if ~isempty(ticklabel)
    set(ax,[o 'ticklabel'],ticklabel);
end
set(ax,[noto 'tick'],[],'ticklength',[0 0]);
feval([o 'label'],ax,label);
axscale(scale,ax);
