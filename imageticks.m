% replace the current ticks for ax with images arranged nrows deep. 
%
% INPUT         DEFAULT DESCRIPTION
% ax            gca     axis to add ticks to
% images        -       cell array of images. this input can be
%                           skipped if both yimages and ximages are defined
%                           below.
% NAMED INPUT
% yimages       {}      cell array of custom images for vertical axis
% ximages       {}      cell array of custom images for horizontal axis
% dim           'xy'    dimensions to process 
% nrows         2       number of rows to stack images in
% padding       0.1     proportion of padding between images (and axis)
% ticklines     0       tick length (proportion of image-axis distance, 0 
%                           to disable, which is the default)
% autopos       true    shift and scale the axis to contain the images
%                           inside the original axis position
% offset        NaN     manually set the start of the plot in data units.
%                           Same for xy if scalar, otherwise use [x y]
%                           vector. Useful for plotting multiple sets of
%                           image labels.
% OUTPUTS
% outh: handles to each image
% lineh: handles to the tick lines (if ticklines>0)
%
% [outh,lineh] = imageticks([ax],images,[varargin])
function [outh,lineh] = imageticks(ax,images,varargin);

if ieNotDefined('ax')
    ax = gca;
end

getArgs(varargin,{'dim','xy','nrows',2,'padding',.1,...
    'ticklines',0,'autopos',1,'yimages',images,'ximages',images,...
    'offset',NaN});

if strcmp(lower(dim),'both')
    dim = 'xy';
end
alldim = 'xy';

if isscalar(offset)
    offset = [offset offset];
end

images = struct('x',{ximages},'y',{yimages});
nimages = length(images.x);

% correct for data aspect
if strcmp(get(ax,'dataaspectratiomode'),'auto')
    set(ax,'dataaspectratio',[1 1 1]);
end
dataaspect = get(ax,'dataaspectratio');

% when the data aspect ratio is not equal, this basically means that even
% spacing requires some transformation of one of the dimensions.
ar = dataaspect(2) / dataaspect(1);

% work out the spacing of the images in data units
pixsize = [size(images.x{1},1) size(images.x{1},2)];
scalef = pixsize ./ max(pixsize);
datalims = reshape(axis(ax),[2 2]);
datarange = range(datalims,1);
imsz = (datarange ./ ceil(nimages/nrows)) .* scalef;
% correct for data aspect ratio
imsz(1) = imsz(1) * ar;
gridsize.x = imsz(2);
gridsize.y = imsz(1);
% scale images by pad
imsz = imsz .* (1-padding);

set(ax,'xticklabel',[],'yticklabel',[]);
xy = [];
basexy = [];
plotimages = {};
for d = 1:numel(dim)
    dstr = dim(d);
    % non-selected dimension
    notd = alldim(alldim~=dstr);

    % make sure we have the ticks set up
    set(ax,[dstr 'tickmode'],'manual');
    ticks = get(ax,[dstr 'tick']);
    ntick = length(ticks);
    if ntick ~= nimages
        if datarange(d) ~= nimages
            error('tick and length(images) do not match!')
        else
            % probably an image - try to infer where ticks should be
            set(ax,[dstr 'tick'],...
                ceil(datalims(1,d)):floor(datalims(2,d)));
            ticks = get(ax,[dstr 'tick']);
            ntick = length(ticks);
        end
    end

    % positions in selected dim - fairly easy since we just want to follow
    % the position of the ticks
    varlocs = ticks;
    if strcmp(get(ax,[dstr 'tick']),'reverse')
        varlocs = varlocs(end:-1:1);
    end

    % positions in the other (unchanging) dimension. A bit more difficult.
    % we want these points to vary with nrows
    % so here are the varying offsets
    constoffset = repmat([0:nrows-1],[1 ceil(nimages/nrows)]) .* gridsize.(notd);
    % constoffset = offset(d) + repmat([0:nrows-1],[1 ceil(nimages/nrows)]) .* gridsize.(notd);
    % now we just need a baseline, which depends on the axis direction
    if strcmp(get(ax,[notd 'dir']),'normal')
        % points are offset below (less than min lim)
        if isnan(offset(d))
            offset(d) = min(get(ax,[notd 'lim']));
        end
        baseline = offset(d) - [1+padding] * gridsize.(notd)/2;
        constlocs = baseline - constoffset;
    else
        % reversed - points are offset above (more than max lim)
        if isnan(offset(d))
            offset(d) = max(get(ax,[notd,'lim']));
        end
        baseline = offset(d) + [1+padding] * (gridsize.(notd))/2;
        constlocs = baseline + constoffset;
    end

    % map back to xy
    if strcmp(dstr,'x')
        xy = [xy; varlocs' constlocs(1:nimages)'];
        basexy = [basexy; varlocs' repmat(offset(d),[nimages 1])];
    else
        xy = [xy; constlocs(1:nimages)' varlocs'];
        basexy = [basexy; repmat(offset(d),[nimages 1]) varlocs'];
    end
    plotimages = [plotimages; images.(dstr)(:)];
end

% note that we reverse the aspect ratio correction here - I think this is
% necessary because imageaxes basically does this again
outh = imageaxes(ax,xy,plotimages,[],imsz(1)/ar,false);

% sort out tick lines
lineh = [];
axis(ax,'off');
if ticklines>0
    % turn off built-in ticks
    set(ax,'ticklength',[0 0]);
    axis(ax,'on');
    box(ax,'off');
    tickxy = morph(xy,basexy,ticklines);
    linex = [tickxy(:,1)'; basexy(:,1)'; NaN(1,size(basexy,1))];
    liney = [tickxy(:,2)'; basexy(:,2)'; NaN(1,size(basexy,1))];
    lineh = line(linex(:),liney(:),'color',[0 0 0],'linewidth',.5,...
        'clipping','off','tag','imageticks');
    uistack(lineh,'bottom');
end

if autopos
    assert(all(datarange(1)==datarange),['autopos mode is only ' ...
        'supported for axes with equal x and y lim']);
    % find the linear conversion
    % so the predictors are the data values (here the x axis in first
    % column, y axis in second).
    x = reshape(axis(ax),[2 2]);
    % so the goal is basically for the absolute limits of the full plot,
    % _including_ the images, to fall in roughly this position.

    % so I think we need a 2-pass procedure like so...
    for pass = 1:2
        passxy = xy;
        passx = x;
        ppos = plotboxpos(ax);
        oldpos = get(ax,'position');
        % and the predicted value is the normalised axis position
        y = [ppos(1:2); ppos(1:2)+ppos(3:4)];
        % get the current axis position and size in axis units
        % find the current image size in data units
        imsz = [range(get(outh(1),'xdata')) range(get(outh(1),'ydata'))];
        thispad = imsz .* padding;
        % flip the x depending on axis dir
        if strcmp(get(ax,'ydir'),'reverse')
            passx(:,2) = passx([2 1],2);
            passxy(:,2) = passxy(:,2)+(imsz(2)-thispad(2))/2;
        else
            passxy(:,2) = passxy(:,2)-(imsz(2)-thispad(2))/2;
        end
        if strcmp(get(ax,'xdir'),'reverse')
            passx(:,1) = passx([2 1],1);
            passxy(:,1) = passxy(:,1)+(imsz(1)-thispad(1))/2;
        else
            passxy(:,1) = passxy(:,1)-(imsz(1)-thispad(1))/2;
        end
        slope = (y(2,:)-y(1,:)) ./ (passx(2,:)-passx(1,:));
        intercept = y(1,:) - slope .* passx(1,:);
        % so now we can work out where the image edges were in axis units
        xynorm = [passxy(:,1) * slope(1) + intercept(1) ...
            passxy(:,2) * slope(2) + intercept(2)];
        xymin = min([xynorm; oldpos(1:2)]);
        xymax = max([xynorm; oldpos(1:2)+oldpos(3:4)]);
        % we need a 2 pass procedure since each transform changes the
        % behaviour of the other transform (e.g., after scaling, the images
        % are no longer in the locations indicated by xynorm, so we need to
        % re-calculate this transform before we can scale accurately).
        if pass == 1
            % scale
            currentsize = oldpos(3:4);
            actualsize = range([xymin;xymax],1);
            scalefactor = currentsize ./ actualsize;
            set(ax,'position',[oldpos(1:2) currentsize .* scalefactor]);
            drawnow;
        else
            % translate
            currentpos = oldpos(1:2);
            actualpos = xymin;
            set(ax,'position',[oldpos(1:2)+(currentpos-actualpos) ...
                oldpos(3:4)]);
        end
    end
end
