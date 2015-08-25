% estimate the threshold for above-chance performance of the data in matrix
% y and plot into the axis as a shaded area using errorshade. We estimate
% the threshold based on T statistics with inference using parametric
% statistics or a sign flip permutation test.
%
% INPUT         DEFAULT         DESCRIPTION
% x             -               x coordinates in same shape as y
% y             -               data in observations x features format
%
% NAMED INPUT   DEFAULT         DESCRIPTION
% inftype       'parametric'    alternatively 'perm' for sign flip test
% baseline      0               null hypothesis performance level
% correction    'fwe'           alternatively 'uncorrected'
% shadecolor    [.7 .7 .7]      input for errorshade
% nperm         1000            only relevant if inftype='perm'
% axhand        gca             axis handle
% textx         max(x(:)+range(x(:))*.05    horizontal position for text 
% xvalues       'vary'          allow threshold to vary across x
%                                   coordinates (features in y).
%                                   Alternatively, 'max' sets a constant
%                                   (potentially conservative) threshold at
%                                   all x coordinates.
%
% [h,t] = chanceshade(x,y,[varargin])
function [h,t] = chanceshade(x,y,varargin)
    
getArgs(varargin,{'inftype','parametric','baseline',0,'correction',...
    'fwe','shadecolor',[.7 .7 .7],'nperm',1000,'axhand',gca,...
    'xvalues','vary','textx',max(x(:))+range(x(:))*.05});

assert(ismatrix(y),'input data must be 2D (samples by features)');
assert(isequal(size(x),size(y)),'x and y must be the same size');
badfeat = all(isnan(y),1);
x(:,badfeat) = [];
y(:,badfeat) = [];
badsub = all(isnan(y),2);
x(badsub,:) = [];
y(badsub,:) = [];
tempmodel = GLM(ones(size(y,1),1),y-baseline);

errs = standarderror(tempmodel,1);
switch inftype
    case 'perm'
        nulldist = permflipsamples(tempmodel,nperm,'tmap',...
            [1 tempmodel.nfeatures],1);
        if strcmp(correction,'fwe')
            % get T statistic threshold for p<0.05 (FWE)
            [pfweperm,tthresh] = permpfwe(squeeze(nulldist),'right');
            criticalr = errs * tthresh + baseline;
        else
            % assume uncorrected
            assert(strcmp(correction,'uncorrected'),...
                'unknown correction: %s',correction);
            criticalr = prctile(nulldist,95,3) .* errs + baseline;
        end
    case 'parametric'
        % find the parametric p<0.05 threshold (one-tailed)
        pthresh = .05;
        if strcmp(correction,'fwe')
            pthresh = pthresh/tempmodel.nfeatures;
        end
        tthresh = tinv(1-pthresh,tempmodel.nsamples);
        criticalr = errs * tthresh + baseline;
    otherwise
        error('unknown inftype: %s',inftype);
end

pstr = 'p<0.05';
if strcmp(correction,'fwe')
    pstr = 'p(FWE)<0.05';
end

[~,sortind] = sort(x(:));

criticalr = repmat(criticalr,[tempmodel.nsamples,1]);

switch xvalues
    case 'vary'
        % we're good
    case 'max'
        % use the max - this is conservative but produces a tidy straight
        % line.
        criticalr(:) = max(criticalr(:));
    otherwise
        error('unknown xvalues input: %s',xvalues);
end

h = errorshade(ascol(x(sortind)),...
    baseline*ones(numel(x),1),...
    ascol(criticalr(sortind)),shadecolor);

t = text(textx,criticalr(sortind(end)),pstr,...
    'horizontalalignment','left','verticalalignment','middle');

% there are not many cases where you wouldn't want these set.
uistack(h,'bottom');
uistack(t,'top');
