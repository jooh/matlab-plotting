% Force a given print size in centimeters
% F = setprintsize(F,wh)
% 15/2/2012 J Carlin
function F = setprintsize(F,wh)

if ieNotDefined('F')
	F = gcf;
end

set(F,'paperunits','centimeters','units','centimeters');
set(F,'papersize',wh);
set(F,'paperposition',[0 0 wh(1) wh(2)]);
