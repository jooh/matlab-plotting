% find the limits of the data (using e.g. get(h,'ydata')) along dim, which
% can be a vector for multiple returns (e.g. 'xy' returns a [1 4] vector
% that can be entered into axis). Recurses into children of each handle and
% ignores NaNs.
%
% lims = getdatalims(h,dim)
function lims = getdatalims(h,dim)

lims = [];
for d = dim(:)'
    dimdata = get(h(~isnan(h)),[d 'data']);
    currentmin = Inf;
    currentmax = -Inf;
    for dat = dimdata(:)'
        thismin = min(dat{1}(:));
        thismax = max(dat{1}(:));
        currentmin(thismin<currentmin) = thismin;
        currentmax(thismax>currentmax) = thismax;
    end
    % recurse into children
    children = get(h(~isnan(h)),'children');
    if iscell(children)
        children = cat(1,children{:});
    end
    if ~isempty(children)
        % protect from infinite recursion
        childlims = getdatalims(children,d);
        currentmin(childlims(1)<currentmin) = childlims(1);
        currentmax(childlims(2)>currentmax) = childlims(2);
    end
    lims = [lims currentmin currentmax];
end
