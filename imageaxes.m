% Generate a set of images at [x,y] locations in current axis.
% images and alphas are cell arrays. Changes figure units to cm to prevent
% figure window resizing from breaking the code.
% imageaxes(ax,xy,images,[alphas],[imsize])
function outh = imageaxes(ax,xy,images,alphas,imsize)

if ieNotDefined('ax')
    ax = gca;
end
axes(ax);
f = gcf;
oldfigunits = get(f,'units');
set(f,'units','centimeters','defaultaxesunits','centimeters');
set(ax,'units','centimeters','plotboxaspectratio',[1 1 1],...
    'dataaspectratio',[1 1 1]);
actualpos = plotboxpos(ax);

% flag for alpha channel
noalpha = ieNotDefined('alphas');

[n,ndim] = size(xy);

% adaptive scaling by n
if ieNotDefined('imsize')
    imsize = 1/(n/3);
end

% input checks
assert(ndim==2,'only 2 dimensions are supported!')
assert(n==length(images),'images and xy are different lengths!')

% imsize as proportion of longest axis
maxdim = max(actualpos(3:4));
imsize_sc = imsize * maxdim;
pad_sc = imsize_sc/5;

% scale XY coordinates into normalised positions
xyvec = reshape(xy,1,[]);
xyvec_sc = rescale(xyvec,[pad_sc maxdim*(1-pad_sc/2)]);
xy_sc = reshape(xyvec_sc,size(xy));
% add intercept
xy_final = xy_sc + repmat(actualpos(1:2)-[imsize_sc imsize_sc]/2,[n 1]);

outh = NaN([1 n]);
for im = 1:n
    a = axes('position',[xy_final(im,1) xy_final(im,2) imsize_sc imsize_sc],...
        'plotboxaspectratiomode','auto');
    outh(im) = imshow(images{im});
    if ~noalpha
        set(outh(im),'alphadata',alphas{im});
    end
end
% Return focus to master axis
axes(ax);
axis off;
