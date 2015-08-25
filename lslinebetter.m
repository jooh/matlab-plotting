% Matlab's builtin lsline is strangely inflexible. This variant adds a few
% useful options.
%
% INPUTS:
% phand: plot handle (the data that gets fitted)
% collapse (default false): If true we compute a fit for all points
%   regardless of plot handle.
% xvalues (default xlim): If defined the fit is evaluated for this range.
%   You can also set xvalues to 'adaptive', in which case the line is
%   defined by the minimal and maximal x values.
% [lineargs]: any additional varargin get passed to line
%
% lhand = lslinebetter(phand,[collapse],[xvalues],[lineargs])
function lhand = lslinebetter(phand,collapse,xvalues,varargin)

if nargin<1
  % revert to default lsline behaviour
  lhand = lsline;
end

if ieNotDefined('collapse')
  collapse = false;
end

if ieNotDefined('xvalues')
    xvalues = get(get(phand(1),'parent'),'xlim');
end

lhand = [];
n = length(phand);
if collapse && n>1
  xdat = cell2mat(getn(phand,'xdata'));
  ydat = cell2mat(getn(phand,'ydata'));
  if strcmp(xvalues,'adaptive')
      xvalues = [min(xdat) max(xdat)];
  end
  lhand = reflinereplace(xdat,ydat,xvalues,varargin{:});
else
  for p = 1:n
    xdat = getn(phand(p),'XData');
    ydat = getn(phand(p),'YData');
    thisx = xvalues;
    if strcmp(thisx,'adaptive')
        thisx = [min(xdat) max(xdat)];
    end
    lhand(end+1) = reflinereplace(xdat,ydat,thisx,varargin{:});
    try
        % bit ugly but this can fail if putting a slope on e.g. bar data.
        set(lhand(end),'color',getn(phand(p),'color'));
    end
  end
end

function lh = reflinereplace(xdat,ydat,xvalues,varargin)
nanind = isnan(ydat);
xdat(nanind) = [];
ydat(nanind) = [];
% linear fit
fit = polyfit(xdat,ydat,1);
% predicted values
yhat = fit(2) + fit(1) .* xvalues;
lh = line(xvalues,yhat,varargin{:});
