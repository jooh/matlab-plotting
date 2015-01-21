% set with NaN support - convenient shorthand for constructions like
% set(hand(~isnan(hand)),... See also isequaln, uniquen.
%
% setn(hand,varargin)
function setn(hand,varargin)

nanmask = isnan(hand);
set(hand(~nanmask),varargin{:});
