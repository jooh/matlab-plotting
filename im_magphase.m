% convenience function for quickly returning the magnitude and phase of an
% image through 2d fft. RGB images are first converted to grayscale with
% mat2gray.
%
% scalemag defaults to false, which means that the magnitude is log
% transformed for visualisation purposes.
%
% [mag,phase] = im_magphase(im,[scalemag])
function [mag,phase] = im_magphase(im,scalemag)

if ieNotDefined('scalemag')
    scalemag = false;
end
if ndims(im)==3
    % make grayscale. Could also imagine applying fft2 separately to each
    % color channel but I guess the user can index the input to achieve
    % such behaviour
    im = mat2gray(im);
end

% center to put low frequencies in middle of plot
f = fftshift(fft2(im));

% +1 to avoid log(0)
mag = abs(f);
if scalemag
    mag = log(mag+1);
end
phase = angle(f);
