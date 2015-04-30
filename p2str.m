% given a scalar or vector of p values, return a cell array of strings with
% n decimal places (default 3), where p values less than n are rounded to
% 10^-n.
%
% if doprefix is true, we prepend 'p=' for each string, except for values
% beyond the display range (p<10^-n) which get 'p<'.
%
% pstr = p2str(p,n,doprefix)
function pstr = p2str(pvec,n,doprefix)

if ieNotDefined('n')
    n = 3;
end

if ieNotDefined('doprefix')
    doprefix = false;
end

if doprefix
    prefix = 'p=';
else
    prefix = '';
end

pstr = arrayfun(@(p)sprintf(['%s%.' int2str(n) 'f'],prefix,max([p 10^-n])),pvec,...
    'uniformoutput',false);
% hilarious Matlab behaviour - enter NaN, get .001...
pstr(isnan(pvec)) = {''};

if doprefix
    smallind = pvec < 10^-n;
    for n = find(smallind(:))'
        pstr{n}(2) = '<';
    end
end
