% Returns a currently unused figure handle by adding 1 to the last one
% found
% h = uniquehandle;
function h = uniquehandle;

hands = get(0,'children');
h = 1;
if ~isempty(hands)
    h = round(max(hands)) + 1;
end
