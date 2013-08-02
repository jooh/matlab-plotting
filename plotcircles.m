% plot one circle for each entry in x,y with width/height defined by w,h.
%
% If h is ommitted w is the radius.
% plotargs are style arguments that get passed on to plot
%
% lhand = plotcircles(x,y,w,[h],[varargin])
function lhand = plotcircles(x,y,w,h,varargin)

nx = numel(x);
if ieNotDefined('h')
    h = w;
end
assert(isequal(nx,numel(y),numel(w),numel(h)),['all entries must have ' ...
    'same number of elements']);

circrange = linspace(0,2*pi,1e4);
xp = cos(circrange);
yp = sin(circrange);
hold on
lhand = arrayfun(@(ind)plot(x(ind)+xp*w(ind),y(ind)+yp*h(ind),...
    varargin{:}),1:nx,'uniformoutput',true);
