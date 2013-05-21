% line plot histogram. Uses histc and some indexing to produce square wave
% style plot into the current axes. Any extra plotargs are passed on to
% plot. Usage is otherwise like histc.
%
% P = histline(y,bins,[plotargs])
function P = histline(y,bins,varargin)

% assume you want to transpose 1D row vector inputs
if isrow(y)
    y = y';
end

bins = bins(:);
% each entry in c contains the count of y from bins(b):bins(b)+1.
c = histc(y,bins);
% so all c values should be repeated once 
reps = repinds(1,size(c,1),2);
yy = [zeros(1,size(c,2)); c(reps,:)];

% bins should also repeat but do not start/end at 0.
bb = [bins(reps); bins(end)];

P = plot(bb,yy,varargin{:});
