% given a long string, split at appropriate points (spaces) into rows of
% equal-ish length
% cellrows = str2cellrows(instr,nrows)
function cellrows = str2cellrows(instr,nrows)

if ieNotDefined('nrows')
    nrows = 2;
end

if nrows==1
    cellrows = {instr};
    return
end

n = length(instr) / nrows;
spaces = strfind(instr,' ');
lastind = 1;
for r = 1:(nrows-1)
    nn = n * r;
    [mindist,ind] = min(abs(spaces-nn));
    cellrows{r} = instr(lastind:spaces(ind)-1);
    lastind = spaces(ind)+1;
end
cellrows{r+1} = instr(lastind:end);
