% Shift the position of all the text handles to position y in dim. This is
% often useful e.g. when shifting all labels to the edge of a plot area.
% This is similar to the align funtionality in e.g. Illustrator.
%
% th: text handles (we ignore nans)
% y: new position (must be scalar or vector matching numel(dim)
% dim: some combination of 'xyz'. Unspecified dims are left alone.
%
% settextpos(th,y,dim)
function settextpos(th,y,dim)

[test,numdim] = intersect('xyz',dim,'stable');
assert(isequal(test,dim),'must specify only x y z, in alphabetical order');

for h = 1:numel(th)
    if isnan(th(h))
        continue;
    end
    p = get(th(h),'position');
    p(numdim) = y;
    setn(th(h),'position',p);
end
