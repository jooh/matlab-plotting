% given an array of axis handles, set the data limits and the plot boxes to
% match.
% matchaxis(ax)
function matchaxis(ax)

% match data limits
axmat = cell2mat(axis(ax));
nd = size(axmat,2);
newmins = min(axmat(:,[1:2:nd]),[],1);
newmaxs = max(axmat(:,[2:2:nd]),[],1);
newax = [newmins; newmaxs];
axis(ax,newax(:)');

% match axis height/width 
apos = cell2mat(get(ax,'position'));
newsize = min(apos(:,3:4),[],1);
newpos = [apos(:,1:2) repmat(newsize,[length(ax),1])];
arrayfun(@(x)set(ax(x),'position',newpos(x,:)),1:length(ax));
