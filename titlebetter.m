% Place a 'title' as an axis object centered above the axis/axes in input.
% Primarily useful for cases where you want a title that spans multiple
% subplots.
% t = titlebetter(titlestr,[ax]);
function t = titlebetter(titlestr,ax);

if ieNotDefined('ax')
    ax = gca;
end

nax = length(ax);
if nax > 1
    pos = cell2mat(arrayfun(@plotboxpos,ax,'uniformoutput',false)');
else
    pos = plotboxpos(ax);
end

% top position is the tallest available ax
top = max(pos(:,2)+pos(:,4));

% Get midpoint of each ax
middles = pos(:,1) + (pos(:,3)/2);
% Assume you want the width of the title ax to be about the same as the axes
% you're plotting
%width = median(pos(:,3));
width = 0.001;
% while the height should be very modest
%height = median(pos(:,4))/5;
height = 0.001;
% So now the desired left/bottom position is...
left = median(middles) - (width/2);
bottom = top - (height/2);

tax = axes('position',[left bottom width height],...
    'plotboxaspectratiomode','auto');
% May have to also disable background but nervous about Matlab and transparency
% Hm, actually text never clips outside ax so we could even make ax very very small indeed
axis off
oldu = get(tax,'units');
set(tax,'units','normalized');
t = text(.5,.5,titlestr,'horizontalalignment','center','verticalalignment',...
    'bottom');
% Return to original units to prevent print weirdness
set(tax,'units',oldu);
