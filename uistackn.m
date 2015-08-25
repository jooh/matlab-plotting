% uistack wrapper with support for nans and arbitrary shaped inputs.
%
% uistackn(h,varargin)
function uistackn(h,varargin)

uistack(ascol(h(~isnan(h))),varargin{:});
