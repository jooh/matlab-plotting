% Print a figure as PNG and EPS, trim whitespace post-print
% fnbase - path and filename (with or without extension - we strip)
% F - figure handle. Optional.
% r - resolution (dpi). Defaults to 300.
% Dependencies: convert (from ImageMagick)
% printstandard(fnbase,[F],[r])
function printstandard(fnbase,F,r);

if ieNotDefined('F')
  F = gcf;
end

if ieNotDefined('r')
    r = 300;
end

% Make sure no extension
fnbase = stripext(fnbase);

res = sprintf('-r%d',r);
hand = sprintf('-f%d',F);

% Ideally 'none' but this is broken as of 2011a
set(gcf,'color',[1 1 1]);

% Forcing painters means that alpha blending won't work but the output is
% generally nicer otherwise
print([fnbase '.png'],hand,'-dpng',res,'-noui','-painters');
print([fnbase '.eps'],hand,'-depsc','-noui','-painters');

% Trim whitespace
system(sprintf('convert -density %d %s -trim %s',r,[fnbase '.png'],...
  [fnbase '.png']));
