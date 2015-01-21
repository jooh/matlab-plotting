% shade the area between low and high at each x in color c, using 
% blend factor alpha.
%
% The key point of this function is to use hard alpha blending so that we
% can still print the figure with the painters renderer. For simple
% visualisation setting the facealpha property is likely to be much easier.
%
% INPUTS:
% x: row vector
% low: lower bound of y for each x (multiple shades stack in columns)
% high: upper bound of y for each x
% c: color values (size(low,2) by 3 matrix)
% alpha: scalar
%
% shadehand = errorshade(x,low,high,c,alpha)
function shadehand = errorshade(x,low,high,c,alpha)

ax = gca;
washold = ishold(ax);
if ~washold
    hold(ax,'on');
end

if ieNotDefined('alpha')
    alpha = .8;
end

assert(iscolumn(x),'x must be column vector');

if size(c,1) ~= size(low,2)
    c = repmat(c,[size(low,2) 1]);
end
assert(isequal(size(low),size(high)),...
    'low and high must be equal size');
assert(isequal(size(c,1),size(low,2)),...
    'must specify same n colours as number of shades');

nanfeat = isnan(low);
assert(isequal(nanfeat,isnan(high)),...
    'nans must match across low and high');

rowind = 1;
n = size(low,1);
shadehand = [];
niter = 0;

% iterate over rows (x coordinates)
while rowind < n
    % make sure we haven't broken the while loop
    niter = niter + 1;
    assert(niter<1e3,'iteration limit exceeded');
    % find the nan configuration belonging to this group (ie, overlap
    % pattern)
    thisnan = nanfeat(rowind,:);
    % matching rows
    nanhit = bsxfun(@eq,nanfeat,thisnan);
    % numerical indices that match or exceed the current row
    nanind = find(all(nanhit,2) & [1:n]'>=rowind);
    % find skips in X values - cases where a different configuration starts
    endindind = find(diff(nanind)>1)+1;
    thisind = nanind(1:min([numel(nanind) endindind]));
    if numel(thisind)==1
        % need at least 2 values to patch
        rowind = thisind(end)+1;
        continue;
    end

    thisx = x(thisind);
    thislow = low(thisind,~thisnan);
    thishigh = high(thisind,~thisnan);
    thisc = c(~thisnan,:);
    rowind = thisind(end);

    % So what defines pairwise overlap? lowa<highb | higha < lowb
    bgcolor = get(ax,'color');
    contours = sort([thislow thishigh],2);
    for cc = 2:size(contours,2)
        cclow = contours(:,cc-1);
        cchigh = contours(:,cc);
        % x values where the peak of the shade exceeds the low point of the
        % current contour
        frombelow = bsxfun(@gt,thishigh,cclow);
        % x values where the trough of the shade is lower than the high
        % point of the current contour
        fromabove = bsxfun(@lt,thislow,cchigh);
        % so there is only really overlap when both these tests are true
        overlap = frombelow & fromabove;
        % deal with all the overlap combos that appear here
        ucombs = unique(overlap,'rows');
        for u = 1:size(ucombs,1)
            if all(ucombs(u,:)==0)
                % empty space
                continue;
            end
            ind = bsxfun(@eq,overlap,ucombs(u,:));
            ulow = cclow(ind(:,1));
            uhigh = cchigh(ind(:,1));
            ux = thisx(ind(:,1));
            % alpha blend away (add axis background as final color since we
            % want to blend towards this)
            ucolor = [thisc(ucombs(u,:)',:);bgcolor];
            thiscolor = alphablend(ucolor,alpha);
            shadehand(end+1) = patcher(ux,ulow,uhigh,thiscolor);
        end
    end
end

if ~washold
    hold(ax,'off');
end

function cout = alphablend(colors,alpha)

% work back to front
colors = colors(end:-1:1,:);

cout = colors(1,:);
% then iteratively add layers
for c = 2:size(colors,1)
    cout = cout*alpha + colors(c,:)*(1-alpha);
end

function shadehand = patcher(thisx,thislow,thishigh,thisc)

% the trick here is to make one big polygon by first going left to
% right on the low side, then right to left on the high side.
xx = [thisx; thisx(end:-1:1)];
yy = [thislow; thishigh(end:-1:1)];
shadehand = patch(xx,yy,thisc,'edgecolor','none');
