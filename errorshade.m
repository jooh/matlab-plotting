% shade the area between low and high at each x in color c.
%
% shadehand = errorshade(x,low,high,c)
function shadehand = errorshade(x,low,high,c)

hold on;

% the trick here is to make one big polygon by first going left to right on
% the low side, then right to left on the high side.
x = x(:);
low = low(:);
high = high(:);
xx = [x; x(end:-1:1)];
yy = [low; high(end:-1:1)];
shadehand = patch(xx,yy,c,'edgecolor','none');
