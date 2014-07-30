% phase scramble by inserting random phase components (rather than adding a
% random phase image).
%
% scr = im_phasescramble(im,w)
function scr = im_phasescramble(im,w)

[r,c,z] = size(im);
assert(z<5,'input image must be at most 4D');
assert(isodd(c) && isodd(r),'half Fourier requires odd-sized images');

% this preserves input class
scr = im;

% number of entries in half-Fourier representation
np = floor(r*c/2);

ns = floor((1-w)*np);
if ns<1
  scr = im;
  return;
end

% generate a random phase structure while preserving conjugate symmetry
% randphase = angle(fft2(rand([r c])));
randphase = rand(1,np) * 2 * pi - pi;

% faster than a full randperm and selecting a subset
inds = randsample(1:np,ns);

% implicitly skip 4th channel if present to preserve alpha
for d = 1:z-(z==4)
  %[mag,phase] = im_magphase(im(:,:,d),false);
  hf = getHalfFourier(im(:,:,d));
  % replace with random phase
  hf.phase(inds) = randphase(inds);
  scr(:,:,d) = reconstructFromHalfFourier(hf);
  % scr(:,:,d) = im_reconstruct(mag,phase);
end
