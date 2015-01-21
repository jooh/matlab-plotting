% plot a polar grid. Useful when the limitations of Matlab's polar
% become frustrating.
%
% NB, sets dataaspectratio to [1 1 1].
%
% INPUTS:
% ax: (default gca)
% phi: direction of spokes in radians
% rad: eccentricity of rings
% maskphi: optional 2 element vector of radians to mask out from rings
% [varargin]: any additional inputs get passed to plot for grid styling.
%
% OUTPUTS:
% spokes: one plot handle per spoke
% rings: one plot handle per ring
%
% [spokes,rings] = polargrid(ax,phi,rad,maskphi,[varargin])
function [spokes,rings] = polargrid(ax,phi,rad,maskphi,varargin)

if ieNotDefined('ax')
    ax = gca;
end

set(ax,'dataaspectratio',[1 1 1]);
washold = ishold(ax);
hold(ax,'on');

if isempty(varargin)
    args = {'linewidth',.5,'color',[0 0 0]};
else
    args = varargin;
end

% first do the spokes
maxrad = max(rad);
phi = phi(:);
np = numel(phi);
px = NaN([2,np]);
py = NaN([2,np]);
% all lines begin at origin
px(1,:) = 0;
py(1,:) = 0;
% position where lines end
[px(2,:),py(2,:)] = pol2cart(phi,maxrad);
for p = 1:np
    spokes(p) = plot(px(:,p),py(:,p),args{:});
end

% then the rings
standardv = linspace(0,2*pi,500);
if ~ieNotDefined('maskphi')
    if maskphi(2)<maskphi(1)
        % need to handle wraparound
        badind = standardv>maskphi(2) | standardv<maskphi(1);
    else
        badind = standardv>maskphi(1) & standardv<maskphi(2);
    end
    standardv(badind) = NaN;
end
standardx = cos(standardv);
standardy = sin(standardv);

for r = 1:length(rad)
    xp = standardx * rad(r);
    yp = standardy * rad(r);
    rings(r) = plot(xp,yp,args{:});
end

if ~washold
    hold(ax,'off');
end
uistack(spokes,'bottom');
uistack(rings,'bottom');
