% Print a figure as PNG and EPS, trim whitespace post-print
% fnbase - path and filename (with or without extension - we strip)
% F - figure handle. Optional.
% r - resolution (dpi). Defaults to 600.
% formats - print outputs. Defaults to {'png','eps'}.
% forcepainters - always print with painters. Default 0.
% Dependencies: convert (from ImageMagick)
% printstandard(fnbase,varargin)
function printstandard(fnbase,varargin);

getArgs(varargin,{'F',gcf,'formats',{'png','eps'},...
    'r',600,'forcepainters',0,'loose',false});

formstruct = struct('png','-dpng','eps','-depsc2');

% Make sure no extension
fnbase = stripext(fnbase);

res = sprintf('-r%d',r);
hand = sprintf('-f%d',F);

% Ideally 'none' but this doesn't work with painters
set(gcf,'color',[1 1 1]);

args = {hand,[],res,'-noui'};

if forcepainters
    args(end+1) = {'-painters'};
end

if loose
    args(end+1) = {'-loose'};
end

if ~iscell(formats)
    formats = {formats};
end
for f = formats(:)'
    fstr = f{1};
    args{2} = formstruct.(fstr);
    print([fnbase '.' fstr],args{:});
end

% Trim whitespace
if any(strcmp(formats,'png'))
    system(sprintf('convert -density %d %s -trim %s',r,[fnbase '.png'],...
      [fnbase '.png']));
end
