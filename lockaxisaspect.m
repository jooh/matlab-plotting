% use manual axis positioning to achieve an identical (or similar) aspect
% ratio as was previously achieved by setting dataaspectratio or
% plotboxaspectratio. Matlab figure position tends to get very complicated
% when these are in manual mode so the typical use case for this function
% is to first set them to manual and then use this function to achieve a
% position-based setting that achieves a similar result.
%
% lockaxisaspect(ax)
function lockaxisaspect(ax)

for a = ax(:)'
    orgbox = plotboxpos(a);
    orgax = axis(a);
    orgpos = get(a,'position');
    set(a,'dataaspectratiomode','auto','plotboxaspectratiomode','auto');
    set(a,'looseinset',get(a,'tightinset'));
    axis(a,orgax);
    set(a,'position',orgbox);
end
