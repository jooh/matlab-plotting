% plot and return a handle to every plotted point in the original shape of
% the input y.
%
% INPUTS:
% x: vector or matrix of size(y)
% y: vector or matrix
% varargin: additional arguments to pass to plot. If left empty we set to
%   '.'
%
% OUTPUTS:
% outh: plot handles of size(y)
%
% outh = plotarray(x,y,varargin)
function outh = plotarray(x,y,varargin)

washold = ishold(gca);
hold(gca,'on');

plotarg = varargin;
if isempty(plotarg)
    plotarg = {'.'};
end

sy = size(y);
sx = size(x);
if ~isequal(sx,sy)
    % attempt to deal with x value vector case
    x = repmat(x(:),[1 sy(2:end)]);
    assert(isequal(size(x),sy),'x and y must have the same size');
end

outh = NaN(sy);
for h = find(~isnan(y))'
    outh(h) = plot(x(h),y(h),plotarg{:});
end
if ~washold
    hold(gca,'off');
end
