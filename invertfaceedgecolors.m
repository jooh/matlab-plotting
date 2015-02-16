% switch the face and edge colors in the handles h. This is often useful to
% visualise related conditions (e.g. one is solid red, one is white with a
% red outline). 
%
% If the edgecolor is none, we assume you want a solid white facecolor. If
% the facecolor is white, we assume you want no edge.
%
% invertfaceedgecolors(h)
function invertfaceedgecolors(h)

for thish = h(:)'
    f = get(thish,'facecolor');
    e = get(thish,'edgecolor');
    if strcmp(e,'none')
        % if there is no edge we want white fill
        e = [1 1 1];
    end
    if isequal(f,[1 1 1])
        % if the fill is white, we want no edge
        f = 'none';
    end
    set(thish,'facecolor',e,'edgecolor',f);
end
