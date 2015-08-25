% Add nicely formatted p values to the current axes.
%
% INPUTS
% x,y: coordinates
% p: p values
% precision: number of digits precision (default 3)
% prefix: optional prefix to add to each (e.g., 'p=' - default '')
% [varargin]: any additional varargin are passed to text
%
% T = addptext(x,y,p,[precision],[doprefix],[textargs])
function T = addptext(x,y,p,precision,doprefix,varargin)

if ieNotDefined('precision')
    precision = 3;
end
if ~ieNotDefined('doprefix')
    doprefix = true;
end

pstr = p2str(p,precision,doprefix);

sy = size(y);
sx = size(x);
if ~isequal(sx,sy)
    % attempt to deal with y scalar case
    assert(isscalar(y),'y must be same size as x or scalar');
    y = repmat(y,sx);
end

T = NaN(sx);
notnan = ~isnan(x);

% weird bug - text fails with single class inputs
T(notnan) = text(double(x(notnan)),double(y(notnan)),pstr(notnan),...
    varargin{:});

set(T(p(notnan)<0.05),'fontangle','normal','fontweight','bold');
set(T(p(notnan)>0.05),'fontangle','italic','fontweight','normal');
