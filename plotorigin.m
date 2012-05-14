% Add origin lines to the current axis. Scales with x/ylim so set these
% first.
% p = plotOrigin([ax])
function p = plotOrigin(ax)

if ieNotDefined('ax')
  ax = gca;
end

washold = ishold(ax);

if ~washold
  hold on
end

xl = get(ax,'xlim');
yl = get(ax,'ylim');

xlp = xl;
ylp = yl;

% We use multiplicative scaling so ensure these are something sensible
xlp(2) = max([xl(2) 1]);
ylp(2) = max([yl(2) 1]);
xlp(1) = min([xl(1) -1]);
ylp(1) = min([yl(1) -1]);

% Ensure well outside xlim/ylim
xlp = xlp*100;
ylp = ylp*100;

p = plot([xlp(1) 0; xlp(2) 0],[0 ylp(1); 0 ylp(2)],'k:','linewidth',1);

set(ax,'xlim',xl,'ylim',yl);

% Return with same hold state
if ~washold
  hold off
end
