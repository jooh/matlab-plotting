function printbyname(fighand,outdir,varargin)

mkdirifneeded(outdir);

for f = fighand(:)'
  name = get(f,'name');
  assert(~isempty(name),'figure %d has no name',f);
  printstandard(fullfile(outdir,stripbadcharacters(name,'_')),'F',f,...
    varargin{:});
end
