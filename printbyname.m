% print figures by reading file names from the 'name' field (which must be
% set before calling this). bad characters get replaced by underscores in
% file names.
%
% INPUT
% fighand: handles to figures
% outdir: directory to print to
% varargin: any additional arguments for printstandard
%
% printbyname(fighand,outdir,varargin)
function printbyname(fighand,outdir,varargin)

mkdirifneeded(outdir);

for f = fighand(:)'
  name = get(f,'name');
  assert(~isempty(name),'figure %d has no name',f);
  printstandard(fullfile(outdir,stripbadcharacters(name,'_')),'F',f,...
    varargin{:});
end
