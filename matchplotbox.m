% Match the plotboxpos in ax to the first entry's height, width, vertical
% and/or horizontal position. The dimensions you wish to match are char
% input arguments and any number is possible. You generally want to enter
% scaling requirements (height/width) before shift parameters
% (vertical/horizontal). 
%
% This is useful e.g. when matching subplot sizes while also constraining
% dataaspectratio (e.g.  e.g., to achieve identical bar widths across
% subplots with a different number of bars). Or for any situation where you
% want to prevent matlab from changing the size or position of plot boxes
% to accommodate labels.
%
% This function respects existing data/plotbox aspect ratios but will
% convert these to a 'soft' position-based variant using lockaxisaspect.
%
% matchplotbox(ax,[varargin])
function matchplotbox(ax,varargin)
    
% insure column v.ector
ax = ax(:);
if length(ax)<2
    % can't match with itself
    return;
end

% lock down the axis aspect ratio
lockaxisaspect(ax);

targetboxpos = plotboxpos(ax(1));

% tolerance parameter
tol = 1e-3;
iterlim = 1e3;

for arg = varargin
    % find the dimension to tune
    switch lower(arg{1})
        case 'height'
            targdim = 4;
            moddim = [3 4];
        case 'width'
            targdim = 3;
            moddim = [3 4];
        case 'vertical'
            targdim = 2;
            moddim = 2;
        case 'horizontal'
            targdim = 1;
            moddim = 1;
        otherwise
            error('unknown input: %s',arg{1});
    end
    % box parameter to which we strive
    targvalue = targetboxpos(targdim);
    % iterate over axes to be matched to first
    for targax = ax(2:end)';
        niter = 0;
        done = false;
        % initialise with current state
        currentbox = plotboxpos(targax);
        currentvalue = currentbox(targdim);
        % keep tuning the axis position until it's close
        % DEBUG
        oldvalues = [];
        while abs(targvalue-currentvalue) > tol
            niter = niter+1;
            % maybe subtract instead
            scaler = targvalue ./ currentvalue;
            scalevec = ones([1 4]);
            % scale both dims if changing size to preserve aspect ratio
            scalevec(moddim) = scaler;
            set(targax,'position',get(targax,'position') .* scalevec);
            % think we need to draw to let Matlab jig things around a bit
            drawnow;
            % then get the updated box position
            currentbox = plotboxpos(targax);
            currentvalue = currentbox(targdim);
            assert(niter < iterlim,'iteration limit exceeded');
            % DEBUG
            oldvalues = [oldvalues scaler];
        end
    end
end
