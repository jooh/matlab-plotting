function out = getn(h,varargin)

out = NaN;
if ~all(isnan(h(:)))
    out = get(h(~isnan(h)),varargin{:});
end
