% weighted mean phase of two phase matrices (signalph, noiseph). the scalar
% w gives the weighting (1=all signalph, 0=all noiseph).
%
% See Dakin et al., 2002, Current Biology for an overall account of why
% this is preferable to simply blending the phase values.
%
% meanph = weightedmeanphase(signalph,noiseph,w)
function meanph = weightedmeanphase(signalph,noiseph,w)

% weighted average of the sines and cosines of the phase values
s = w .* sin(signalph) + (1-w) .* sin(noiseph);
c = w .* cos(signalph) + (1-w) .* cos(noiseph);

% NB NOT this - the formula in Dakin seems to have a typo
% meanph = atan(c./s);
meanph = atan(s./c);

% correct phase wraparound
% NB had to reverse the logic here to get this to work with phase values
% from halfFourier code
negc = c > 0;
poss = s>0 & c<0;
meanph(negc) = meanph(negc) + pi;
meanph(poss) = meanph(poss) + 2*pi;

% usually not necessary but it's nice to preserve the range 
meanph = meanph-pi;
