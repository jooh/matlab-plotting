% standard slice figure
% data - 3D volume
% datarange - thresholding of colormap
% dv - string of dependent variable for colorbar Ylabel
% cm (optional) - colormap (default hot(1024))
% F = slicefigure(data,datarange,dv,cm)
function F = slicefigure(data,datarange,dv,cm)

if ieNotDefined('cm')
    cm = hot(1024);
end

F = figure;
imagesc(makeimagestack(data,datarange,1),[0 1]);
colormap(cm);
set(gca,'dataaspectratio',[1 1 1]);
C = colorbar;
ylabel(C,dv);
set(C,'ytick',[0 1],'ylim',[0 1],'yticklabel',datarange);
axis off
