% replace the current ticks for ax with images arranged nrows deep.
% Operates along dims - 1 for x, 2 for y, [1 2] for both (default). No
% support for 3D plots at present. To keep the image in place relative to
% ax it is necessary to change the ax position to an absolute (cm). It is
% thus a good idea to make sure that calling this function is the last
% change you make to the figure before saving/printing. Returns a vector of
% handles to the images (to easily make invisible, do
% set(outh,'visible','off').
% outh = imageticks([ax],images,[nrows],[dims],[alpha])
% TODO: tick lines to each image
function outh = imageticks(ax,images,nrows,dims,alpha)

if ieNotDefined('ax')
    ax = gca;
end

if ieNotDefined('nrows')
    nrows = 1;
end

if ieNotDefined('dims')
    dims = [1 2];
end

if ieNotDefined('alpha')
    alpha = [];
end

pref = 'xy';
for d = dims
    set(ax,[pref(d) 'tickmode'],'manual');
end

% If axis size is normalise the whole thing breaks as soon as you resize
% the figure
set(gcf,'defaultaxesunits','centimeters','units','centimeters');
set(ax,'units','centimeters')

% Ensure manual ticks
set(ax,'xtickmode','manual');

nimages = length(images);
%imsizes = cell2mat(cellfun(@size,images,'uniformoutput',false)');
% Work out roughly how big images will need to be in each axis
%maxsize = max(imsizes,[],1);

apos = get(ax,'position');
% Now get the REAL plot position (which is not 'position' in many cases,
% e.g. when axis equal).
actualpos = plotboxpos(ax);
outerpos = get(ax,'position');

imsize = actualpos(3:4) / (nimages/nrows);
% NB! height by width, so for d==1, we want imsize(notd)

% matlab positions are
% [l b w h]
% so for x, pos = apos(1), len = apos(3)

% The key challenge here is that we want to respect the OUTER position, but
% this cannot be set directly
newpos = apos;

done = 0;
oldimsize = 0;
% Iterative search for axis scal / imsize combination that fits
while ~done
    actualpos = plotboxpos(ax);
    imsize = actualpos(3:4) / (nimages/nrows);
    if all(abs(imsize-oldimsize) < .01)
        done = 1;
    end
    for d = dims
        notd = 3-d;
        % Move a bit to make room
        pad = imsize(notd)/10;
        %space = outerpos(notd) + pad + nrows*imsize(d);
        space = apos(notd) + pad + nrows*imsize(d);
        newpos(notd) = space;
        % subtract pad again to allow a bit of air for images at the end of
        % axis
        newpos(notd+2) = apos(notd+2)+(apos(notd)-(space+2*pad));
    end
    assert(all(newpos>0),'not enough space for images, consider smaller axes')
    set(ax,'position',newpos);
    oldimsize = imsize;
end

% Conversion function for plotting lines in cm rather than axis units
% TODO
%ax2cm = @(x) actualpos(d)+x*range(get(ax,[pref(d) 'tick'])) / actualpos(2+d);
%keyboard;

% Update actual
actualpos = plotboxpos(ax);
imsize = actualpos(3:4) / (nimages/nrows);

outh = NaN([1 nimages*length(dims)]);
oc = 0;
for d = dims
    notd = 3-d;
    dstr = pref(d);
    ticks = get(ax,[dstr 'tick']);
    ntick = length(ticks);
    if ntick ~= nimages
        error('tick and length(images) do not match!')
    end
    lims = get(ax,[dstr 'lim']);
    % normalise by lim
    t_norm = (ticks-lims(1)) / range(lims);
    % normalise by axis position in figure
    t_normf = actualpos(d) + (t_norm.*actualpos(d+2));
    %imsize = t_normf(2)-t_normf(1);
    % center on tick
    t_normf = t_normf - imsize(d)/2;
    % offset here for rows!
    flatlocs = repmat(actualpos(notd)-(pad+imsize(d)),[1 ntick]);
    for n = 1:nrows
        flatlocs(n:nrows:nimages) = flatlocs(n:nrows:nimages)-(n-1)*imsize(d);
    end
    if d ==1
        xlocs = t_normf;
        if strcmp(get(ax,'xdir'),'reverse')
            xlocs = xlocs(end:-1:1);
        end
        ylocs = flatlocs;
    else
        xlocs = flatlocs;
        ylocs = t_normf;
        if strcmp(get(ax,'ydir'),'reverse')
            ylocs = ylocs(end:-1:1);
        end
    end
    for im = 1:length(images)
        oc = oc+1;
        a = axes('position',[xlocs(im) ylocs(im) imsize(d) imsize(d)],...
            'plotboxaspectratiomode','auto');
        outh(oc) = imshow(images{im});
        if ~isempty(alpha)
            set(outh(oc),'alphadata',alpha{im});
        end
    end
    set(ax,[dstr 'ticklabel'],[]);
end

% outer ticks
set(ax,'tickdir','out')
% Return focus to original axis
axes(ax);
box off;
