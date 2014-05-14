% plot a polar grid. Useful when the limitations of Matlab's polar
% become frustrating.
%
% NB, sets dataaspectratio to [1 1 1].
%
% INPUTS:
% ax: (default gca)
% phi: direction of spokes in radians
% rad: eccentricity of rings
% [varargin]: any additional inputs get passed to plot for grid styling.
%
% OUTPUTS:
% spokes: one plot handle per spoke
% rings: one plot handle per ring
%
% [spokes,rings] = polargrid(ax,phi,rad,[varargin])
function [spokes,rings] = polargrid(ax,phi,rad,varargin)

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
np = length(phi);
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
minphi = min(phi);
maxphi = max(phi);
standardv = linspace(minphi,maxphi,100);
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
