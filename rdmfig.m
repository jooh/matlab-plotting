% Wrapper for plotrdms to create a panel figure.
%
% INPUTS    DEF DESCRIPTION
% rdm           some pilab-compatible mat, vec or struct array
% names     {}  cell array of titles for subplots. If undefined we attempt
%                   to infer from names in input rdm (if struct)
% dims      []  dimensions of subplot (we infer if undefined)
% fighand   []  existing figure handle (we make a new figure if undefined)
%
% all additional [varargin] are passed on to plotrdms.
%
% [fighand,ax,intmap,cmap] = rdmfig(rdm,names,dims,fighand,varargin)
function [fighand,ax,intmap,cmap] = rdmfig(rdm,names,dims,fighand,varargin)

rdmat = asrdmmat(rdm);
nrdm = size(rdmat,3);
if ieNotDefined('names')
    if isstruct(rdm)
        names = {rdm.name};
    else
        names = mat2strcell(1:nrdm,'rdm %02d');
    end
end

if ieNotDefined('dims')
    dims = ceil(sqrt(nrdm)) .* [1 1];
end

if ieNotDefined('fighand')
    fighand = figurebetter('large');
else
    figure(fighand);
end

for n = 1:nrdm
    ax(n) = subplot(dims(1),dims(2),n);
    [ax(n),intmap{n},cmap{n}] = rdmplot(ax(n),rdmat(:,:,n),varargin{:});
    title(ax(n),stripbadcharacters(names{n},' '));
end
