% plot lines between points in xy according to the dissimilarities in rdm.
% The intensity of dissimilarity is colour coded according to cmap. any
% additional varargin are passed to line.
%
% ax: (default gca) axis for plot
% xy: n by 2 set of coordinates for each condition in the RDM
% rdm: vector, struct or matrix form
% cmap: (default autumn) color map for line colours
% dopolar (default false) plot polar curves between points instead
% varargin: any valid arguments for Matlab's line function - if cell array,
%   pass one cell entry for each color.
%
% phand = plotmdslines([ax],xy,rdm,[cmap],[dopolar=false],[varargin])
function phand = plotmdslines(ax,xy,rdm,cmap,dopolar,varargin)

rdvec = asrdmvec(rdm);
ndis = numel(rdvec);
udis = unique(rdvec);
% skip non-modelled dissimilarities
udis(isnan(udis)) = [];
nudis = length(udis);
if ieNotDefined('cmap');
    cmap = autumn(nudis);
end
if size(cmap,1) ~= nudis
    assert(size(cmap,1)==1,['cmap must have one entry or same as '...
        'number of unique dissimilarities. Got %d'],size(cmap,1));
    % upcast to nudis
    cmap = cmap(ones(nudis,1),:);
end

if isempty(varargin)
    plotarg = cell(nudis,1);
elseif ~iscell(varargin{1})
    plotarg = repmat({varargin},[nudis,1]);
else
    plotarg = varargin;
end

% flip order so shorter dissimilarities get plotted over longer ones (this
% tends to look better). As a bonus, you also get sensible legend behaviour
% (descending order of dissimilarity).
udis = udis(end:-1:1);
cmap = cmap(end:-1:1,:);
nd = size(xy,2);
pos = repmat({[]},[1 nd]);
for dis = 1:nudis
    dpos{dis} = pos;
end
xpos = repmat({[]},[1 nudis]);
ypos = repmat({[]},[1 nudis]);
zpos = repmat({[]},[1 nudis]);
ncon = size(xy,1);
assert(ncon==npairs2n(ndis),'xy and rdm do not match');

if ieNotDefined('ax')
    ax = gca;
end

switch nd
    case 2
        plotter = @(p,co,varargin)plot(ax,p{1},p{2},'color',co,...
            varargin{:});
    case 3
        plotter = @(p,co,varargin)plot3(ax,p{1},p{2},p{3},'color',co,...
            varargin{:});
        assert(~dopolar,'cannot dopolar if plotting 3d');
    otherwise
        error('unsupported input dimensionality: %d',nd);
end

for d = 1:ndis
    thispos = [];
    dis = rdvec(d);
    if isnan(dis)
        continue
    end
    % find the conditions to which this dissimilarity belongs
    logvec = false([ndis 1]);
    logvec(d) = true;
    logmat = squareform(logvec);
    [r,c] = ind2sub([ncon ncon],find(logmat(:)));
    % polar?
    if dopolar
        [thispos(:,1),thispos(:,2)] = polarpoints(xy(r,1),xy(r,2),5000);
    else
        thispos = xy(r,:);
    end
    for dim = 1:nd
        dpos{udis==dis}{dim}= [dpos{udis==dis}{dim}; NaN; thispos(:,dim)];
    end
end

washold = ishold(ax);
hold(ax,'on');
for u = 1:nudis
    color = cmap(u,:);
    phand(u) = plotter(dpos{u},color,plotarg{u}{:});
end
if ~washold
    hold(ax,'off');
end
