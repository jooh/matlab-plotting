function F = barchart(y,varargin)

getArgs(varargin,{'labels',[],'edgecolor','none','facecolor',[.6 .6 .6],...
    'errorcolor',[0 0 0],'width',.6,'errors',[],'rotatelabels',45});

F = figure;
x = 1:length(y);
B = bar(x,y,width,'edgecolor',edgecolor,'facecolor',facecolor);
hold on
if ~isempty(errors)
    E = errorbar(x,y,errors,'linestyle','none','color',errorcolor);
end
xlim([x(1)-1 1+x(end)]);
set(gca,'xtick',x,'xticklabel',labels,'tickdir','out','ticklength',...
    get(gca,'ticklength')*.5);
rotateXLabels(gca,45);
box off
