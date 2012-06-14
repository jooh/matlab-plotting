% Scale an axis whilst preserving its position in the figure.
function axscale(sf,ax)

if ieNotDefined('ax')
    ax = gca;
end

apos = get(ax,'position');
newsize = apos(3:4) * sf;
set(ax,'position',[apos(1:2)+(apos(3:4)/2)-(newsize/2) newsize]);
