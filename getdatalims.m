% find the limits of the data (using e.g. get(h,'ydata')) along dim, which
% can be a vector for multiple returns (e.g. 'xy' returns a [1 4] vector
% that can be entered into axis). Recurses into children of each handle and
% ignores NaNs, invisible objects, and objects with the tag
% 'getdatalims=0'.
%
% lims = getdatalims(h,dim)
function lims = getdatalims(h,dim)

lims = [];
for d = dim(:)'
    validh = h(~isnan(h));
    % keep track of handle types - we can only play this game with some
    % types
    datah = validh;
    htype = get(validh,'type');
    hvis = get(validh,'visible');
    htag = get(validh,'tag');
    badind = ismember(htype,{'axes','figure','text'}) ~= 0 | ...
        strcmp(hvis,'off') | strcmp(htag,'getdatalims=0');
    datah(badind) = [];
    dimdata = get(datah,[d 'data']);
    if ~iscell(dimdata) && ~isempty(dimdata)
        dimdata = {dimdata};
    end
    currentmin = Inf;
    currentmax = -Inf;
    for dat = dimdata(:)'
        thismin = min(dat{1}(:));
        thismax = max(dat{1}(:));
        currentmin(thismin<currentmin) = thismin;
        currentmax(thismax>currentmax) = thismax;
    end
    % recurse into children - nb here we do use any axes of figure inputs
    children = get(validh,'children');
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
