% set the Z coordinate for the plot hands in phand to some scalar z. This
% is sometimes useful when uistack fails to make Matlab respect layer
% order.
%
% setplotz(phand,z)
function setplotz(phand,z)

px = get(phand,'xdata');
if ~iscell(px)
    px = {px};
end

for p = 1:length(phand)
    set(phand(p),'zdata',repmat(z,[1,numel(px{p})]));
end
