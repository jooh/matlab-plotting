% Matlab's builtin lsline is strangely inflexible. This variant takes a
% plothandle input so you can control which plots get lsline'd. Also, if
% the collapse flag is true we compute a fit for all points regardless of
% plot handle.
%
% lhand = lslinebetter(phand,collapse)
function lhand = lslinebetter(phand,collapse)

if nargin<1
  % revert to default lsline behaviour
  lhand = lsline;
end


if ieNotDefined('collapse')
  collapse = false;
end

lhand = [];
n = length(phand);
if collapse && n>1
  xdat = [];
  ydat = [];
  for p = 1:n
    xdat = [xdat get(phand(p),'XData')];
    ydat = [ydat get(phand(p),'YData')];
  end
  fit = polyfit(xdat,ydat,1);
  lhand = refline(fit);
  set(lhand,'color','k');
else
  for p = 1:n
    xdat = get(phand(p),'XData');
    ydat = get(phand(p),'YData');
    fit = polyfit(xdat,ydat,1);
    lhand(end+1) = refline(fit);
    try
        % bit ugly but this can fail if puttin a slope on e.g. bar data.
        set(lhand(end),'color',get(phand(p),'color'));
    end
  end
end
