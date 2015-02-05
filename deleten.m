% delete with NaN support. See also isequaln, uniquen, setn.
%
% deletn(hand)
function deleten(hand)

nanmask = isnan(hand);
% vectorise because delete isn't entirely robust to unusually-sized inputs
delete(ascol(hand(~nanmask)));
