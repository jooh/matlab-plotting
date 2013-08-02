% replace the input image im's magnitude information with mag.
% im = im_imposemag(im,mag)
function im = im_imposemag(im,mag)

inclass = class(im);

phase = angle(fft2(im));
im = abs(ifft2(mag .* exp(i*phase)));

% restore to input class
im = feval(inclass,im);
