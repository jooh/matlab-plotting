% Make a new figure without some of the usual Mathworks insanity.
% figsize is in cm and determines also the size of the 'paper'
% we also support a few shortcuts for sensible standard sizes:
% tiny: 4 should sideways on A4
% small: 3 fit
% medium: 2 fit
% large: 1 fits
% F is a handle number (defaults to uniquehandle output)
% F = figure([F],figsize,[axisar],[visible])
function F = figure(F,figsize,axisar,visible)

% This is a bit awkward but often we only want to enter a size argument
if nargin==1
  figsize=F;
  clear F
end

if ieNotDefined('F')
  F = uniquehandle;
end

if ieNotDefined('figsize')
  figsize = 'small';
end

if ieNotDefined('visible')
  visible = get(0,'defaultfigurevisible');
end

% Hack to allow 1/0 true/false options
if ~isstr(visible)
  if visible
    visible = 'on';
  else
    visible = 'off';
  end
end

a4 = [21 29.7];
% With a default figure aspect ratio 
if isstr(figsize)
  figar = 3/4;
  switch lower(figsize)
    case {'tiny'}
      modifier = 1/4;
    case {'small'}
      modifier = 1/3;
    case {'medium'}
      modifier = 1/2;
    case {'large'}
      modifier = 1;
    otherwise
      error('unknown figsize: %s',figsize)
  end
  figsize = a4(1) .* [modifier modifier*figar];
end

if ieNotDefined('axisar')
  axisar = figsize(2)/figsize(1);
end

% scale figure presentation on the screen with print size (this actually
% makes no difference for print size but is helpful for visual inspection).
cm2pix = 30;

iptsetpref('ImshowBorder','tight');

sysfonts = lower(listfonts);
if findStrInArray(sysfonts,'helvetica',1);
    fon = 'helvetica';
elseif findStrInArray(sysfonts,'arial',1);
    fon = 'arial';
else
    error('Cannot find helvetica or arial on system')
end

F = figure(F);
set(F,'color',[1 1 1],... % white BG
  'inverthardcopy','off',... % don't flip colours when printing
  'paperunits','centimeters',... % size in CM
  'papersize',figsize,... % paper=figsize
  'paperposition',[0 0 figsize],... % figure insize paper
  'units','centimeters',...
  'position',[0 0 figsize],... % use same units for figure and paper
  'defaultaxescolor',[1 1 1],... % white axes bg
  'defaultlinelinewidth',2,... % thicker lines
  'defaultaxesfontname',fon,... 
  'defaultaxesfontsize',8,... 
  'defaultuicontrolfontname',fon,...
  'defaultuicontrolfontsize',9,...
  'defaulttextfontname',fon,...
  'defaulttextfontsize',9,...
  'defaultaxeslooseinset',[0 0 0 0],... % kill whitespace!
  'colormap',jet(1000)*.9,... %slightly muted jet with many gradients
  'visible',visible,...
  'defaultaxesplotboxaspectratio',[1 axisar 1]);
% Last argument sets aspect ratio of each plot box to match figure aspect
% ratio. This makes for less whitespace and tends to be visually appealing
% for subplots
