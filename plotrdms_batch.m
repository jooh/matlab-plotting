% Plot and save RDMs and/or MDS for each RDM in data. If there's more than
% one RDM in data, we also construct and save second-order RSM (spearman
% rho).
%
% NAMED INPUTS:
% data: something that can be converted to RDM with asrdmvec
% labels: struct array with image field (also alpha for image MDS)
% ylabels:
% xlabels: for custom labels on each axis
% figdir: (default pwd)
% cmap: (default cmap_bwr)
% nrows: (default 2)
% roinames: (default 'rdm %02d' OR extracted from data.name)
% domds: (default true)
% dordm: (default true)
% gridlines: (default [])
% gridcolor: (default [1 1 1] if gridlines are defined)
% ranktransform: (default false)
% cblabel: (default 'dissimilarity')
% cbticklabel: (default [], which produces numeric output. If ranktransform,
%   {'low','high'})
% cbtick: (default [])
% lims: (default []) limits for colormap. Not supported if ranktransform
% issimilarity: (default false) used to appropriately flip similarity into
%   dissimilarity before MDS
% greythresh: (default []) threshold for colormap grayscale conversion
% ticklines: imageticks input
%
% plotrdms_batch(varargin)
function plotrdms_batch(varargin)

getArgs(varargin,{'figdir',pwd,'cmap',cmap_bwr,'nrows',2,...
    'roinames',[],'data',[],'labels',struct('image',{}),'domds',true,...
    'dordm',true,'gridcolor',[],'ranktransform',false,'cblabel',...
    'dissimilarity','cbticklabel',[],'cbtick',[],'lims',[],...
    'gridlines',[],'issimilarity',false,'greythresh',[],...
    'ylabels',[],'xlabels',[],'ticklines',0});

mkdirifneeded(figdir);

% try to read ROI names from RDM struct field
if isstruct(data) && isempty(roinames)
    roinames = {data.name};
end

% insure data is vector
data = asrdmvec(data);
if all(isnan(data(:)))
    % no point
    return;
end
nroi = size(data,2);
if isempty(roinames)
    roinames = mat2strcell(1:nroi,'rdm %02d');
end

if ranktransform && strcmp(cblabel,'dissimilarity')
    cblabel = ['rank-transformed ' cblabel];
end

if ranktransform && isempty(cbticklabel)
    cbticklabel = {'low','high'};
end

if isempty(ylabels)
    ylabels = labels;
end
if isempty(xlabels)
    xlabels = labels;
end

imagelabels = true;
if ~isempty(ylabels) && ischar(ylabels(1).image)
    imagelabels = false;
end

assert(~ranktransform || isempty(lims),...
    'manual lims and ranktransform will lead to unexpected output');


% make plots for each ROI
for roi = 1:nroi
    if all(isnan(data(:,roi)))
        % skip all NaN ROIs
        fprintf('roi %s is all NaN, skipping.\n',roinames{roi});
        continue;
    end
    thisdata = data(:,roi);
    if ranktransform
        thisdata = ranktrans(thisdata);
    end
    thisrdm = vec2rdm(thisdata);
    printname = stripbadcharacters(roinames{roi});

    % save the raw RDM image
    im = intensity2rgb(thisrdm,cmap,lims,greythresh);
    imwrite(im,fullfile(figdir,sprintf('rdm_raw_%s.png',...
        printname)),'PNG');

    if dordm
        F = figure;
        % save the RDM without labels (but with other customisations)
        mainax = gca;
        [mainax,intmap,thiscmap] = rdmplot(mainax,thisrdm,...
            'cmap',cmap,'limits',lims,...
            'gridcolor',gridcolor,'gridlines',gridlines,'greythresh',...
            greythresh,'ticklines',ticklines);
        printstandard(fullfile(figdir,sprintf('rdm_nolabel_%s',...
            printname)));
        clf(F);

        % save the RDM with labels
        mainax = subplot(2,6,[1:4 7:10]);
        [mainax,intmap,thiscmap] = rdmplot(mainax,thisrdm,'xlabels',...
            {xlabels.image},'ylabels',{ylabels.image},...
            'nrows',nrows,'cmap',cmap,'limits',lims,...
            'gridcolor',gridcolor,'gridlines',gridlines,'greythresh',...
            greythresh,'ticklines',ticklines);
        printstandard(fullfile(figdir,sprintf('rdm_wlabel_%s',...
            printname)));

        % same but with added colorbar
        subax = subplot(2,6,[6 12]);
        c = colorbarbetter(subax,intmap,thiscmap,'label',cblabel,'ticklabel',...
            cbticklabel,'orientation','vertical','scale',.33,'tick',cbtick);
        printstandard(fullfile(figdir,sprintf('rdm_wcb_%s',...
            printname)));
        close(F);
    end

    if domds
        if any(isnan(thisrdm(:)))
            fprintf('NaNs in RDM - skipping mds for %s\n',...
                roinames{roi});
            continue;
        end
        F = figure;
        if issimilarity
            % flip scores
            thisrdm = vec2rdm(1-rdm2vec(thisrdm));
        end
        try
            [xy,stress,disparities] = mdscale_robust(thisrdm,2,...
                'criterion','metricstress');
        catch exception
            if strcmp(exception.identifier,...
                    'stats:mdscale:ColocatedPoints')
                fprintf('co-located points - skipping mds for %s\n',...
                    roinames{roi});
                close(F);
                continue;
            else
                rethrow(exception);
            end
        end
        if imagelabels
            outh = imageaxes(gca,xy,{xlabels.image},{xlabels.alpha});
        else
            % text labels
            set(gca,'dataaspectratio',[1 1 1]);
            thand = textscatter(xy,{xlabels.image});
            axis(axis*1.2);
        end
        axis(gca,'off');
        if imagelabels
            % mds plot really doesn't need to be eps
            printstandard(fullfile(figdir,sprintf('mds_%s',printname)),...
                'formats','png','r',900,'F',F);
        else
            % we do want EPS output
            printstandard(fullfile(figdir,sprintf('mds_%s',printname)));
        end
        close(F);

        % and diagnostic Shepard plot
        F = figure;
        ax = gca(F);
        plotshepard(ax,thisrdm,disparities,pdist(xy)');
        printstandard(fullfile(figdir,sprintf(...
            'diagnostic_mds_shepard_%s',printname)),'F',F);
        close(F);
    end
end

if nroi > 1
    rdmstim = struct('image',stripbadcharacters(roinames,' '),'alpha',[]);
    % analyse second-order dissimilarity RDM across ROIs
    rsm = corr(asrdmvec(data),'rows','pairwise','type','spearman');
    % this is pretty shocking, but when run in this mode, corr doesn't
    % necessarily output a symmetrical correlation matrix (divergences will
    % be small but consistent)!
    rsm = (rsm + permute(rsm,[2 1])) ./ 2;
    % recurse!
    plotrdms_batch('data',rsm,'labels',rdmstim,'figdir',figdir,...
        'cmap',cmap_bwr,'roinames',{'secondorder rsm'},...
        'dordm',true,'ranktransform',false,'gridcolor',gridcolor,...
        'lims',[-1 1],'cblabel','similarity (Spearman''s rho)',...
        'issimilarity',true,'domds',domds);
end
