% given a disvol of ROI RDMs and a stimulus struct, plot RDMs and MDS for
% each ROI, and plot a second-order MDS of distances between ROIs. All
% plotrdms_batch(disvol,stimuli,varargin)
function plotrdms_batch(disvol,stimuli,varargin)

getArgs(varargin,{'figdir',pwd,'cmap',jet(1e3),'nrows',2,...
    'alphacolor',[],'mdstimsize',[]});

ts = struct('cmap',cmap,'nrows',nrows,'alphacolor',alphacolor,...
    'mdstimsize',mdstimsize);

mkdirifneeded(figdir);

roinames = disvol.meta.features.names;
nroi = disvol.nfeatures;

% make plots for each ROI
for roi = 1:nroi
    % plot rank transformed data
    rankrdm = asrdmmat(tiedrank(disvol.data(:,roi)));
    runplots(rankrdm,stimuli,ts,roinames{roi},figdir,...
        'rank-transformed dissimilarity',{'low','high'});
end

% analyse second-order dissimilarity RDM across ROIs
rdmstim = struct('image',stripbadcharacters(roinames,''),'alpha',[]);
rdmat_so = squareform(pdist(disvol.data','spearman'));
% run plots on that
runplots(rdmat_so,rdmstim,ts,'second-order rdm',figdir,...
    {'dissimilarity','(Spearman rho)'},[]);

end

function runplots(rankrdm,stimuli,ts,name,figdir,cblabel,ticklabel)

    printname = strrep(name,' ','');

    % save the raw RDM image
    im = intensity2rgb(rankrdm,ts.cmap);
    imwrite(im,fullfile(figdir,sprintf('rdm_raw_%s.png',...
        printname)),'PNG');
    % save the RDM with stimuli
    F = plotrdms(rankrdm,'labels',{stimuli.image},...
        'nrows',ts.nrows,'titles',name,'cmap',ts.cmap,'visible','off');
    printstandard(fullfile(figdir,sprintf('rdm_wlabel_%s',...
        printname)));
    close(F);
    % same but with colorbar
    F = plotrdms(rankrdm,'labels',{stimuli.image},...
        'nrows',ts.nrows,'colorbarargs',{'label',cblabel,'tick',...
        'minmax','ticklabel',ticklabel},'titles',...
        name,'cmap',ts.cmap,'docb',true,'visible','off');
    printstandard(fullfile(figdir,sprintf('rdm_wcb_%s',...
        printname)));
    close(F);
    % show MDS with stimulus labels, make Shepard plot
    [F,Fshep] = plotrdms(rankrdm,'labels',{stimuli.image},...
        'imagealpha',{stimuli.alpha},'nrows',ts.nrows,'domds',true,...
        'mdsshepard',true,'alphacolor',ts.alphacolor,'mdstimsize',...
        ts.mdstimsize,'titles',name,'dordm',false,'visible','off');
    % mds plot really doesn't need to be eps
    print(fullfile(figdir,sprintf('mds_%s.png',printname)),'-dpng',...
        '-r300',['-f' num2str(F)]);
    printstandard(fullfile(figdir,sprintf(...
        'diagnostic_mds_shepard_%s',printname)),'F',Fshep);
    close(F);
    close(Fshep);
end
