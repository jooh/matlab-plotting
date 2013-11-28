% Print a figure as PNG and EPS, trim whitespace post-print
% fnbase - path and filename (with or without extension - we strip)
% F - figure handle. Optional.
% r - resolution (dpi). Defaults to 300.
% forcepainters - always print with painters. Default 0.
% Dependencies: convert (from ImageMagick)
% printstandard(fnbase,varargin)
function printstandard(fnbase,varargin);

getArgs(varargin,{'F',gcf,'r',600,'forcepainters',0,'loose',false});

% Make sure no extension
fnbase = stripext(fnbase);

res = sprintf('-r%d',r);
hand = sprintf('-f%d',F);

% Ideally 'none' but this is broken as of 2011a
set(gcf,'color',[1 1 1]);

args = {hand,[],res,'-noui'};

if forcepainters
    args(end+1) = {'-painters'};
end

if loose
    args(end+1) = {'-loose'};
end

args{2} = '-dpng';
print([fnbase '.png'],args{:});
args{2} = '-depsc2';
print([fnbase '.eps'],args{:});
%args{2} = '-dpdf';
%print([fnbase '.pdf'],args{:});

% Trim whitespace
%system(sprintf('convert -density %d %s -trim %s',r,[fnbase '.png'],...
%  [fnbase '.png']));
