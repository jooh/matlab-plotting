% Make a cell array of nicely formatted strings from a vector of
% integers/floats. Essentially a proper cell array return version of
% sprintf.
% v - row or column vector
% strtemp - a sprintf str with a % flag that determines format for v
% strtemp - '%d'
% c = vec2str(v,str)
function c = vec2str(v,strtemp)

if ieNotDefined('strtemp')
    strtemp = '%d';
end

mat2nicestr = @(x) sprintf(strtemp,x);

v = v(:);
vlen = length(v);
vcell = mat2cell(v,ones(vlen,1),1);
c = cellfun(mat2nicestr,vcell,'uniformoutput',false);
