% given a scalar or vector of p values, return a cell array of strings with
% n decimal places (default 3), where p values less than n are rounded to
% 10^-n.
% pstr = p2str(p,n)
function pstr = p2str(pvec,n)

if ieNotDefined('n')
    n = 3;
end

pstr = arrayfun(@(p)sprintf(['%.' int2str(n) 'f'],max([p 10^-n])),pvec,...
    'uniformoutput',false);
% hilarious Matlab behaviour - enter NaN, get .001...
pstr(isnan(pvec)) = {''};
