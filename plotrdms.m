% fighand = plotrdms(rdm,varargin)
function [fighand,figshep] = plotrdms(rdm,varargin)

getArgs(varargin,{'labels',[],'imagealpha',[],'nrows',2,'cmap',jet(1e3),...
    'titles',[],'colorbarargs',{},'rotatelabels',45,'docb',false,...
    'fighand',[],'plotcol',4,'dordm',true,'domds',false,'mdstimsize',[],...
    'ranktransform',false,'mdsshepard',false,'alphacolor',[]});

if isempty(fighand)
    fighand = figure;
    set(fighand,'units','pixels','position',[1 1 1024 768]);
end
set(fighand,'color',[1 1 1],'defaultaxesdataaspectratio',[1 1 1]);

if ~isempty(alphacolor)
    if isempty(imagealpha)
        imagealpha = cellfun(@(im)ones(size(im)),labels,'uniformoutput',...
            false);
    end
    for s = 1:length(labels)
        [imx,imy,imz] = size(labels{s});
        alphamat = repmat(alphacolor,[imx imy numel(alphacolor)]);
        hits = all(labels{s} == alphamat,3);
        imagealpha{s}(repmat(hits,[1 1 imz])) = 0;
    end
end

if ~dordm
    docb = false;
end

figshep = [];

rdmmat = asrdmmat(rdm);
[ncon,ncon,nrdm] = size(rdmmat);
nplot = dordm*nrdm + domds*nrdm + docb;

if isstruct(rdm) && isempty(titles)
    titles = {rdm.name};
end

if isempty(titles)
    titles = repmat({''},[1 nrdm]);
end

if ~iscell(titles)
    titles = {titles};
end

titles = stripbadcharacters(titles,' ');

if isempty(labels)
    labelmode = 0;
elseif isnumeric(labels) || ischar(labels) || (iscell(labels) && ischar(labels{1}))
   labelmode = 1;
elseif iscell(labels) && ~isempty(labels{1})
    labelmode = 2;
else
    error('could not parse input: labels')
end

if nplot < plotcol
    plotcol = nplot;
end
nrow = ceil(nplot / plotcol);

pc = 0;
for r = 1:nrdm
    rd = rdmmat(:,:,r);
    if ranktransform
        rd = asrdmmat(tiedrank(asrdmvec(rd))); 
    end
    if dordm
        pc = pc+1;
        ax(pc) = subplot(nrow,plotcol,pc);
        [im,intmap,cmap] = intensity2rgb(rd,cmap);
        image(im);
        switch labelmode
            case 1
                % text labels
                set(ax(pc),'xtick',1:ncon,'ytick',1:ncon,'xticklabel',labels,...
                    'yticklabel',labels);
                if ~isempty(rotatelabels) && rotatelabels~=0
                    rotateXLabels(ax(pc),rotatelabels);
                end
                box(ax(pc),'off');
            case 2
                % image labels
                h = imageticks(ax(pc),labels,nrows,[1 2],imagealpha);
                box(ax(pc),'off');
            otherwise
                axis(ax(pc),'off');
        end
    end
    if domds
        pc = pc+1;
        ax(pc) = subplot(nrow,plotcol,pc);
        if any(isnan(rd(:)))
            warning('skipping MDS due to nans in RDM')
            axis(ax(pc),'off');
            if domds && dordm
                t = titlebetter(titles{r},ax(pc-1:pc));
            elseif domds || dordm
                t = titlebetter(titles{r},ax(pc));
            end
            continue
        end
        try
            [xy,stress,disparities] = mdscale_robust(rd,2,'criterion',...
                'metricstress');
        catch err
            if strcmp(err.identifier,'stats:mdscale:ColocatedPoints')
                warning('skipping MDS plot due to colocated points')
                axis(ax(pc),'off');
                if domds && dordm
                    t = titlebetter(titles{r},ax(pc-1:pc));
                elseif domds || dordm
                    t = titlebetter(titles{r},ax(pc));
                end
                continue;
            else
                rethrow(err);
            end
        end
        switch labelmode
            case 1
                % text labels
                mm = [min(xy(:)) max(xy(:))];
                axis(ax(pc),[mm mm]);
                t = text(xy(:,1),xy(:,2),stripbadcharacters(labels,''),...
                    'verticalalignment','middle',...
                    'horizontalalignment','center','clipping','off');
                axis(ax(pc),'off');
            case 2
                % image labels
                imageaxes(ax(pc),xy,labels,imagealpha,mdstimsize);
        end
        if mdsshepard
            figshep(end+1) = figure;
            shepardPlot(rd,disparities,pdist(xy),figshep(end),titles{r});
            set(figshep(end),'name',titles{r});
            % return focus to main figure
            figure(fighand);
        end
    end
    if domds && dordm
        t = titlebetter(titles{r},ax(pc-1:pc));
    elseif domds || dordm
        t = titlebetter(titles{r},ax(pc));
    end
end

if docb
    ax(nplot) = subplot(nrow,plotcol,nplot);
    c = colorbarbetter(ax(nplot),intmap,cmap,colorbarargs{:});
end

% fix pathological behaviour due to unit change in imageticks
if labelmode==2
    fpos = get(fighand,'position');
    if any(fpos(3:4)>get(fighand,'papersize'));
        set(fighand,'papersize',fpos(3:4),'paperposition',[0 0 fpos(3:4)]);
    end
end
