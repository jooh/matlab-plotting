% Return a nicely formatted string of time s in n days, HH:MM:SS.FFF format
% out = seconds2str(s)
function out = seconds2str(s)

days = floor(s/86400);
others = rem(s,86400);
time = datestr(datenum(0,0,0,0,0,others),'HH:MM:SS.FFF');
out = sprintf('%d days, %s',days,time);
