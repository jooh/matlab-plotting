% visualise orthogonal sections of the ND input array X at coordinates ind.
%
% INPUTS:
% x     ND array
% ind   N indices
% dimlabels     cell array with labels for each dimension of x
% dimcoords     cell array with coordinates for each x dimension
% varargin      any additional args are passed to imagesc (at minimum, we
%                   set the limits to be consistent across panels)
%
% handles = imagend(x,ind,dimlabels,dimcoords,varargin)
function handles = imagend(x,ind,dimlabels,dimcoords,varargin)

nd = ndims(x);
dims = 1:nd;

% we're going to need to slice the array this many ways to represent all
% dims.
panels = nchoosek(1:nd,2);
if nd==3
    % swap order of panels to make nicely aligned crosshairs for 3D plots
    panels = panels([2 1 3:nd],:);
end
npanel = size(panels,1);
nrc = ceil(sqrt(npanel+1));

% we will index by combining allindc and ind - indices to the chosen
% value's position, and a 1:n kind of operator for the 2 visualised dims.
% NB, this is YXZ, not XYZ (ie, row, column)
sz = size(x);
allindc = arrayfun(@(x)1:x,sz,'uniformoutput',0);
indc = num2cell(ind);

if ieNotDefined('dimlabels')
    dimlabels = mat2strcell(dims);
end

if ieNotDefined('dimcoords')
    dimcoords = allindc;
end

args = varargin;
if isempty(args)
    % you probably want the same scaling across panels at the very least
    args{1} = [min(x(:)) max(x(:))];
end

for p = 1:npanel
    % find the dimensions we are slicing
    notd = dims;
    notd(panels(p,:)) = [];
    % build up the indexing argument list
    indarg = cell(1,nd);
    [indarg{notd}] = deal(indc{notd});
    indarg(panels(p,:)) = allindc(panels(p,:));
    thisx = x(indarg{:});
    % make 2D (drop leading singletons but without risky squeeze collapse
    % behaviour)
    thisx = reshape(thisx,sz(panels(p,:)));
    % plot
    handles(p).ax = subplot(nrc,nrc,p);
    % swap here because the Y coordinates go with the rows of thisx and the
    % X coordinates go with the columns
    handles(p).im = imagesc(dimcoords{panels(p,2)},...
        dimcoords{panels(p,1)},thisx,args{:});
    handles(p).xlabel = xlabel(handles(p).ax,dimlabels{panels(p,2)});
    handles(p).ylabel = ylabel(handles(p).ax,dimlabels{panels(p,1)});
    set(handles(p).ax,'tickdir','out','ydir','normal');
    box(handles(p).ax,'off');
    hold(handles(p).ax,'on');
    px = dimcoords{panels(p,2)}(ind(panels(p,2)));
    py = dimcoords{panels(p,1)}(ind(panels(p,1)));
    handles(p).marker = plot(px,py,'+','color',[1 1 1],'markersize',10);
end
handles(npanel+1).cb = colorbar('location','north');
handles(npanel+1).ax = subplot(nrc,nrc,npanel+1);
centerinaxis(handles(npanel+1).cb,handles(npanel+1).ax);
axscale(.5,handles(npanel+1).cb);
