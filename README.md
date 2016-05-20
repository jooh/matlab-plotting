This repo is a collection of utility functions for figures in Matlab. Below is a
quick demo illustrating how the code can be used to visualise distance matrices.

```
function plotdemo
% control variables
ncon = 24;
imdim = 30;
% cook ncon noise patches with a colour gradient 
colours = [ones(1,ncon); ((1:ncon)/ncon); ((ncon:-1:1)/ncon)]';
images = arrayfun(@(x)bsxfun(@times,rand(imdim,imdim,3),...
    reshape(colours(x,:),[1 1 3])),1:ncon,'uniformoutput',false);
% generate a distance matrix according to the colours and some (independent)
% noise
rdm = squareform(pdist(colours+rand(ncon,3)*.4));
fh = figure;
set(fh,'name','distance matrix');
% visualise distance matrix with image labels
rdmplot(gca,rdm,'labels',images,'nrows',4,'gridlines',4:4:ncon);
% visualise in 2D with multidimensional scaling
xy = mdscale(rdm,2,'criterion','metricstress');
fh = figure;
set(fh,'name','multidimensional scaling')
imageaxes(gca,xy,images);
```
