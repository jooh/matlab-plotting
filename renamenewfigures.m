% find new figures (ie members of get(0,'children') that do not appear in
% the oldfigs input, and add some prefix and/or suffix to the name of each.
%
% Useful for renaming new figures as they come in as part of e.g. a loop.
%
% oldfigs = renamenewfigures(oldfigs,[newprefix],[newsuffix])
function oldfigs = renamenewfigures(oldfigs,newprefix,newsuffix)

figs = get(0,'children');
newfig = setdiff(figs,oldfigs);
if isempty(newfig)
  % nothing to do here
  return
end

if ieNotDefined('newprefix')
  newprefix = '';
else
  newprefix = [newprefix ' '];
end

if ieNotDefined('newsuffix')
  newsuffix = '';
else
  newsuffix = [' ' newsuffix];
end

for f = newfig(:)'
  set(f,'name',sprintf('%s%s%s',newprefix,get(f,'name'),newsuffix));
end

oldfigs = [oldfigs; newfig];
