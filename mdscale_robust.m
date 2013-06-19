% call mdscale as usual, but handle ColocatedPoints error by adding fake
% dissimilarities to data.Same inputs/outputs as mdscale.
% [y,stress,disparities] = mdscale_robust(rdm,varargin);
function [y,stress,disparities] = mdscale_robust(rdm,varargin);

try
     [y,stress,disparities] = mdscale(rdm,varargin{:});
catch err
    if strcmp(err.identifier,'stats:mdscale:ColocatedPoints')
        warning('shifting min dissimilarities to avoid colocated points');
        offd = ~logical(eye(size(rdm,1)));
        m = min(rdm(offd));
        % first try constant offset
        target = (rdm==m) & offd;
        rdm(target) = m + .2;
        try
            [y,stress,disparities] = mdscale(rdm,varargin{:});
        catch err2
            if strcmp(err2.identifier,'stats:mdscale:ColocatedPoints')
                % next try half-way to next dissimilarity
                % next smallest dissimilarity
                nextm = min(rdm(~target & rdm>m));
                rdm(target) = (m+nextm) / 2;
                [y,stress,disparities] = mdscale(rdm,varargin{:});
            else
                rethrow(err2);
            end
        end
    else
        rethrow(err);
    end
end
