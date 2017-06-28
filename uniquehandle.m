% Returns n currently unused figure handles by adding 1 to the last one
% found. n defaults to 1
% h = uniquehandle(n);
function h = uniquehandle(n);

if ieNotDefined('n')
    n = 1;
end

hands = get(0,'children');
if isempty(hands)
    hands = 0;
end
if ~isnumeric(hands)
    % support new-style handles
    hands = [hands.Number];
end
h = round(max(hands)+(1:n)*10);

