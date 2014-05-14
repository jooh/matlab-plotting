function [xpall,ypall] = polarpoints(x,y,nseg)

assert(~ismat(x),'x must be vector');
assert(~ismat(y),'y must be vector');
x = x(:);
y = y(:);

n = numel(x);
assert(numel(y)==n,'x and y must be same length');

% go polar
[th,r] = cart2pol(x,y);

xpall = [];
ypall = [];
for l = 2:n
    % interpolate in both angle and radius space
    th_interp = linspace(th(l-1),th(l),nseg)';
    r_interp = linspace(r(l-1),r(l),nseg)';
    % convert back to cartesian
    [xp,yp] = pol2cart(th_interp,r_interp);
    xpall = [xpall; xp];
    ypall = [ypall; yp];
end
