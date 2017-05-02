% convenience function for reading all images found by the output of some
% dir command into a cell array. Optionally returns the alpha layers as a
% second output, and the names (file names without extension) as a third
% [images,alphas,names] = readimages(dircmd)
function [images,alphas,names] = readimages(dircmd)

files = dir(dircmd);
[root,fn,ext] = fileparts(dircmd);
nfiles = length(files);
assert(nfiles>0,'no files found for command %s',dircmd);
for f = 1:length(files)
    [~,names{f},~] = fileparts(files(f).name);
    [images{f},~,alphas{f}] = imread(fullfile(root,files(f).name));
    % fill in an all-on alpha channel
    if isempty(alphas{f})
        alphas{f} = ones(asrow(size(images{f}),2));
    end
end
