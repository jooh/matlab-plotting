% Generate a set of mesh objects at [xyz] locations in axis ax.  
%
% INPUTS        DEFAULT     DESCRIPTION
% ax            gca         axes to plot into
% xyz                       n by 3 set of coordinates
% meshst                    struct array with numel(n) and these fields:
%                               shape
%                               tex
%                               tl
% NAMED INPUTS
% markerscale   [1 1 1]     multiplicative scale factor
% markeroffset  [0 0 0]     spatial offset relative to xyz
% markercolor   [.7 .7 .7]  color (1 by 3 OR n by 3)
%
% TODO:
% baseline option - draw a gray rectangle at min(y) showing the xz limits.
% Draw lines from each marker down to the baseline and put a marker at the
% end. Should make it easier to see the depth arrangement.
%
% [outh,markerh] = meshaxes(ax,xyz,meshst,varargin)
function [outh,markerh] = meshaxes(ax,xyz,meshst,varargin)

getArgs(varargin,{'meshheight',[],'autolim',true,'plotmarker',false,...
    'markeroffset',[0 0 0],'markerscale',[1 1 1],...
    'markercolor',[.7 .7 .7],'nmarkerfaces',100,'plotbaseline',false});

markerh = [];

% good parameters for facedistid:
% scale [1.15 2 1.2]
% offset [0 -.75 .2],...

% input checks and setup
if ieNotDefined('ax')
    ax = gca;
end
% essential to avoid distortions
set(ax,'dataaspectratio',[1 1 1]);

[nmesh,ndim] = size(xyz);
assert(nmesh==numel(meshst),'meshst and xyz are different lengths');

if size(markercolor,1)==1
    markercolor = repmat(markercolor,[nmesh 1]);
end

washold = ishold(ax);
hold(ax,'on');

maxax = max(range(xyz));
if isempty(meshheight)
    meshheight = maxax*.05;
end

for n = 1:nmesh
    % mean 0 and scale mesh by meshheight
    meshst(n).shape = bsxfun(@minus,meshst(n).shape,...
        mean(meshst(n).shape));
    meshst(n).shape = meshst(n).shape / max(meshst(n).shape(:)) * ...
        meshheight;
    % offset to translate into position
    meshst(n).shape = bsxfun(@plus,meshst(n).shape,xyz(n,:));
    outh(n) = trimesh(meshst(n).tl,meshst(n).shape(:,1),...
        meshst(n).shape(:,2),meshst(n).shape(:,3),...
        'EdgeColor','none','FaceVertexCData',meshst(n).tex,...
        'facecolor','interp','facelighting','phong');
    if plotmarker
        markerh(n) = addellipsoid(markerscale,markeroffset*meshheight + ...
            xyz(n,:),range(meshst(n).shape),markercolor(n,:),nmarkerfaces);
    end
end

set(outh,'clipping','off','tag','meshaxes');
set(markerh,'clipping','off','tag','meshaxes_ellipse');
set(ax,'projection','perspective','view',[210 20]);
axis(ax,'off');

if autolim
    % scale up axis to accommodate points on periphery (and add a fudge
    % factor since Matlab doesn't consistently render close to axis
    % limits, even with clipping off.
    % go back to height scale from axis
    imhs = meshheight / maxax;
    axis(ax,[min(xyz(:,1)) max(xyz(:,1)) min(xyz(:,2)) max(xyz(:,2)) ...
        min(xyz(:,3)) max(xyz(:,3))] .* (1+imhs+.3));
end

if plotbaseline
    axlim = axis(ax);
    x = axlim(1:2);
    y = axlim(3:4);
    z = axlim(5:6);
    % hand coding vertices is fun
    vert = [x(1) y(1) z(1); x(2) y(1) z(1); x(2) y(2) z(1); ...
        x(1) y(2) z(1)];
    baseh = fill3(vert(:,1),vert(:,2),vert(:,3),1,'edgecolor','none',...
        'cdatamapping','direct','facecolor','flat',...
        'facevertexcdata',[.9 .9 .9]);
    if plotmarker
        % draw lines
        for n = 1:nmesh
            lineh(n) = plot3(xyz([n n],1),xyz([n n],2),[xyz(n,3) z(1)],...
                '.-','color',markercolor(n,:),'linewidth',1,...
                'markersize',15);
        end
        uistack(lineh,'bottom');
    end
    uistack(baseh,'bottom');
end

if ~washold
    hold(ax,'off');
end

function hs = addellipsoid(scalef,offset,dataranges,color,nfaces)
[x,y,z] = ellipsoid(offset(1),offset(2),offset(3),...
    scalef(1)*dataranges(1)/2,...
    scalef(2)*dataranges(2)/2,...
    scalef(3)*dataranges(3)/2,...
    nfaces);
hold on
% solid colour surface (NB need to change color map here to change
% color of surf which is unattractive. need to set CData later.
hs = surf(x,y,z,ones(size(x)),'cdatamapping','direct','cdata',...
    repmat(reshape(color,[1 1 3]),[size(x) 1]),...
    'EdgeColor','none','facecolor','interp','facelighting','phong');
