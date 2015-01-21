% Make a cell array of nicely formatted strings from a numeric array.
% Essentially a proper cell array return version of sprintf.
%
% v - numeric array
% strtemp - a sprintf str with a % flag that determines format for v
% (default '%d')
% c = mat2strcell(v,str)
function c = mat2strcell(v,strtemp)

if ieNotDefined('strtemp')
    strtemp = '%d';
end

c = strsplit(sprintf(['-*-' strtemp],v),'-*-');
% first entry is the initial blank
c(1) = [];
c = reshape(c,size(v));
