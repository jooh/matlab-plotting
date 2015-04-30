% Print a figure as PNG and EPS, trim whitespace post-print. We use -depsc2
% which provides nice cropped white space outputs by default, and use
% ImageMagick's convert function to trim PNGs similarly.
%
% INPUT:
% fnbase - path and filename (with or without extension - we strip)
%
% NAMED INPUTS:
% F         gcf         figure handle 
% r         600         resolution (dpi)
% formats   {'eps'}     print outputs - can be 'eps', 'png' or both in cell
% forcepainters 0       always print with painters regardless of renderer
% loose     0           add the -loose flag go depsc2 print
%
% printstandard(fnbase,varargin)
function printstandard(fnbase,varargin);

getArgs(varargin,{'F',gcf,'formats',{'eps'},...
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
    assert(isfield(formstruct,fstr),'format: %s is not supported',fstr);
    args{2} = formstruct.(fstr);
    print([fnbase '.' fstr],args{:});
end

% Trim whitespace
if any(strcmp(formats,'png'))
    system(sprintf('convert -density %d %s -trim %s',r,[fnbase '.png'],...
      [fnbase '.png']));
end
