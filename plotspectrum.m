% Plot amplitude spectrum for a 1D signal into current axes.
% Fs is the sample rate (e.g. 1/TR)
% P = plotspectrum(Y,Fs)
function P = plotspectrum(Y,Fs)

L = length(Y);
NFFT = 2^nextpow2(L);
fY = fft(Y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
P = plot(f,2*abs(fY(1:NFFT/2+1)))
xlabel('frequency (Hz)')
ylabel('amplitude')
