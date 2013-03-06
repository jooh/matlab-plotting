% Plot amplitude spectrum for into current axes.
% Y is nobservations by nfeatures (fft along rows, one line plotted per
% feature).
% Fs is the sample rate (e.g. 1/TR). Scalar, same for all features.
% P = plotspectrum(Y,Fs)
function P = plotspectrum(Y,Fs)

L = size(Y,1);
NFFT = 2^nextpow2(L);
fY = fft(Y,NFFT,1)./L;
f = Fs/2*linspace(0,1,NFFT/2+1);
P = plot(f,2.*abs(fY(1:NFFT/2+1,:)));
xlabel('frequency (Hz)');
ylabel('amplitude');
xlim([0 max(f)]);
