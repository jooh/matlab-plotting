% Returns n currently unused figure handles by adding 1 to the last one
% found. n defaults to 1
% h = uniquehandle(n);
function h = uniquehandle(n);

if ieNotDefined('n')
    n = 1;
end

% 0 is useful for the case of no open figs
hands = [0; get(0,'children')];
h = max(hands)+(1:n);
