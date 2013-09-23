% By default Matlab scales the length of the axis ticks by the longest
% dimension in the plot. This can produce obviously mismatched tick lengths
% across plots. This function attempts to match the ticklength by
% the data, so that e.g. two bar plots with bars on 1:x or 1:y end up with
% identical tick lengths.
%
% [ax,refdata] = matchticklength(ax,refdata)
function [ax,refdata] = matchticklength(ax,refdata)

% make sure correct dimensionality
ax = ax(:)';

% make sure all axes have the same (relative) scaling before we start)
scaledlength = get(ax(1),'ticklength');
set(ax,'ticklength',scaledlength);

if ieNotDefined('refdata')
  refdata = gettickdatalength(ax(1),scaledlength);
end

for a = ax(1:end)
  thisdata = gettickdatalength(a,scaledlength);
  scalef = refdata ./ thisdata;
  set(a,'ticklength',scalef .* scaledlength);
end

function tickdata = gettickdatalength(a,scaledlength)
% length of the longest axis in normalised units
apos = get(a,'position');
apos = apos(3:4);
[maxaxlen,maxdim] = max(apos);

% length of the tick in normalised units
%tickax = scaledlength ./ maxaxlen;

% data range in the long axis
alims = axis(a);
arange = [range(alims(1:2)) range(alims(3:4))];
datarange = arange(maxdim);

% length of the tick in data units
tickdata = scaledlength .* datarange;
