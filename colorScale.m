% Create a linear gradient of nCols length between any number of anchors in
% anchorCols.
% From niko's code.
% cols=colorScale(anchorCols,nCols)
function cols=colorScale(anchorCols,nCols)

nAnchors=size(anchorCols,1);
cols = interp1((1:nAnchors)',anchorCols,linspace(1,nAnchors,nCols));

%% visualise
% figure(123); clf;
% imagesc(reshape(cols,[nCols 1 3]));



