% T = addptext(x,y,p,[ax],[precision])
function T = addptext(x,y,p,ax,precision)

if ieNotDefined('ax')
    ax = gca;
end

if ieNotDefined('precision')
    precision = 3;
end

pstr = p2str(p,precision);
% weird bug - text fails with single class inputs
T = text(double(x),double(y),pstr,'rotation',90);
