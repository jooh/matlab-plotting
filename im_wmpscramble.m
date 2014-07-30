% phase scramble using the weighted mean phase method.
%
% scr = im_wmpscramble(im,w)
function scr = im_wmpscramble(im,w)

[r,c,z] = size(im);
assert(z<5,'input image must be at most 4D');
assert(isodd(c) && isodd(r),'half Fourier requires odd-sized images');

% this preserves input class
scr = im;

% number of entries in half-Fourier representation
np = floor(r*c/2);

randphase = rand(1,np) * 2 * pi - pi;

% implicitly skip 4th channel if present to preserve alpha
for d = 1:z-(z==4)
  hf = getHalfFourier(im(:,:,d));
  hf.phase = weightedmeanphase(hf.phase,randphase,w);
  scr(:,:,d) = reconstructFromHalfFourier(hf);
end
