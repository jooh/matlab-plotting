% reconstruct an image from its 2d fft magnitude and phase representation
%
% im = im_reconstruct(mag,phase)
function im = im_reconstruct(mag,phase)

im = abs(ifft2(mag .* exp(i*phase)));
