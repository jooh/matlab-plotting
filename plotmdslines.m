% varargin are passed to line
% phand = plotmdslines(ax,xy,rdm,cmap,varargin)
function phand = plotmdslines(ax,xy,rdm,cmap,varargin)

rdvec = asrdmvec(rdm);
ndis = numel(rdvec);
udis = unique(rdvec);
% skip non-modelled dissimilarities
udis(isnan(udis)) = [];
nudis = length(udis);
xpos = repmat({[]},[1 nudis]);
ypos = repmat({[]},[1 nudis]);
ncon = size(xy,1);
assert(ncon==npairs2n(ndis),'xy and rdm do not match');

if ieNotDefined('ax')
    ax = gca;
end

if ieNotDefined('cmap');
    cmap = autumn(nudis);
end

% there are fancy ways to do this but for now, the dumb solution is to just
% iterate over all dissimilarities
for d = 1:ndis
    dis = rdvec(d);
    if isnan(dis)
        continue
    end
    % find the conditions to which this dissimilarity belongs (is this
    % right?)
    logvec = false([ndis 1]);
    logvec(d) = true;
    logmat = squareform(logvec);
    [r,c] = ind2sub([ncon ncon],find(logmat(:)));
    xpos{udis==dis} = [xpos{udis==dis}; NaN; xy(r,1)];
    ypos{udis==dis} = [ypos{udis==dis}; NaN; xy(r,2)];
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
