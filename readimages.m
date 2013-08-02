% convenience function for reading all images found by the output of some
% dir command into a cell array. Optionally returns the alpha layers as a
% second output
% [images,alphas] = readimages(dircmd)
function [images,alphas] = readimages(dircmd)

files = dir(dircmd);
[root,fn,ext] = fileparts(dircmd);
nfiles = length(files);
assert(nfiles>0,'no files found for command %s',dircmd);
for f = 1:length(files)
    [images{f},junk,alphas{f}] = imread(fullfile(root,files(f).name));
end
