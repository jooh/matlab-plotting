% Center a plot object with handle H in the axis A. Turn off display of axis A.
% Primarily useful for ensuring that a colorbar/legend is placed in a nice
% location in its own subplot. The optional offset is [x] or [x y] in proportion of
% axis (useful for placing 2 colorbars in the same axis by calling wfirst with
% offset -.2 and second with .2).
% H = centerinaxis(H,[A],[offset])
function H = centerinaxis(H,A,offset)

if ieNotDefined('A')
  A = gca;
end

if ieNotDefined('offset')
    offset = [0 0];
elseif length(offset)==1
    % Assume you just want to set x
    offset = [offset 0];
end

% Need to make sure we're dealing with the same numbers here
set(H,'units',get(A,'units'))
apos = get(A,'position');
hpos = get(H,'position');

% figure out offset
offnorm = offset .* apos(3:4);

% move to center of axis, then move back to center of h.
% preserve H size all along
xy = (offnorm+apos(1:2)+(apos(3:4)./2))-(hpos(3:4)./2);
set(H,'position',[xy hpos(3:4)]);
axis(A,'off')
