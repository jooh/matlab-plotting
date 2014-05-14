% plot lines between points in xy according to the dissimilarities in rdm.
% The intensity of dissimilarity is colour coded according to cmap. any
% additional varargin are passed to line.
%
% ax: (default gca) axis for plot
% xy: n by 2 set of coordinates for each condition in the RDM
% rdm: vector, struct or matrix form
% cmap: (default autumn) color map for line colours
% dopolar (default false) plot polar curves between points instead
% varargin: any valid arguments for Matlab's line function
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
if size(cmat,1) ~= nudis
    assert(size(cmat,1)==1,['cmap must have one entry or same as '...
        'number of unique dissimilarities. Got %d''],size(cmat,1));
    % upcast to nudis
    cmat = cmat(ones(nudis,1),:);
end

% flip order so shorter dissimilarities get plotted over longer ones (this
% tends to look better). As a bonus, you also get sensible legend behaviour
% (descending order of dissimilarity).
udis = udis(end:-1:1);
cmap = cmap(end:-1:1,:);
xpos = repmat({[]},[1 nudis]);
ypos = repmat({[]},[1 nudis]);
ncon = size(xy,1);
assert(ncon==npairs2n(ndis),'xy and rdm do not match');

if ieNotDefined('ax')
    ax = gca;
end


for d = 1:ndis
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
        [xp,yp] = polarpoints(xy(r,1),xy(r,2),5000);
    else
        xp = xy(r,1);
        yp = xy(r,2);
    end
    xpos{udis==dis} = [xpos{udis==dis}; NaN; xp];
    ypos{udis==dis} = [ypos{udis==dis}; NaN; yp];
end

washold = ishold(ax);
hold(ax,'on');
for u = 1:nudis
    color = cmap(u,:);
    phand(u) = plot(ax,xpos{u},ypos{u},'color',color,varargin{:});
end
if ~washold
    hold(ax,'off');
end
