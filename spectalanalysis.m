% Parameters
fs = 44100;              % Sampling frequency
t_duration = 5;          % Duration 
N = 3;                   % Bit-depth

% Load Signal
[signal, fs_signal] = audioread('sinC4.wav'); 
signal = signal / max(abs(signal)); %normalize
len_signal = length(signal); 
if fs_signal ~= fs
    signal = resample(signal, fs, fs_signal);
end

amplitude_signal = max(abs(signal));  
q = (2 * 1) / (2^N);  

% RPDF dither
d_rpdf = 0.26 * q * (rand(1, T * fs) - 0.5);  

% TPDF
dither = TPDF(d_rpdf);
dither = dither(:); 

dither = dither(1:len_signal);
%apply
signal_with_dither = signal + dither;

% FFT
nfft = 2^nextpow2(len_signal);  
frequencies = (0:nfft/2-1)*(fs/nfft);  

% FFT for each signal
fft_signal = abs(fft(signal, nfft)/len_signal);
fft_dither = abs(fft(dither, nfft)/len_signal);
fft_combined = abs(fft(signal_with_dither, nfft)/len_signal);

fft_signal = fft_signal(1:nfft/2);
fft_dither = fft_dither(1:nfft/2);
fft_combined = fft_combined(1:nfft/2);

% Convert FFT Amplitudes to dBFS
fft_signal_dBFS = 20 * log10(fft_signal / amplitude_signal);
fft_dither_dBFS = 20 * log10(fft_dither / amplitude_signal);
fft_combined_dBFS = 20 * log10(fft_combined / amplitude_signal);

fft_signal_dBFS(fft_signal_dBFS == -Inf) = -100; % Set to -100 dBFS
fft_dither_dBFS(fft_dither_dBFS == -Inf) = -100;
fft_combined_dBFS(fft_combined_dBFS == -Inf) = -100;

% Plot
figure;

%Original Signal Spectrum
subplot(3,1,1);
plot(frequencies, fft_signal_dBFS, 'b');
title('Frequency Spectrum of Original Signal (dBFS)');
xlabel('Frequency (Hz)');
ylabel('Amplitude (dBFS)');
ylim([-100, 0]);
xlim([0,2000]);
grid on;

% Dither Spectrum
subplot(3,1,2);
plot(frequencies, fft_dither_dBFS, 'r');
title('Frequency Spectrum of TPDF Dither (dBFS)');
xlabel('Frequency (Hz)');
ylabel('Amplitude (dBFS)');
ylim([-100, 0]);
xlim([0,2000]);
grid on;

% Combined Spectrum
subplot(3,1,3);
plot(frequencies, fft_combined_dBFS, 'g');
title('Frequency Spectrum of Dithered Signal (dBFS)');
xlabel('Frequency (Hz)');
ylabel('Amplitude (dBFS)');
ylim([-100, 0]);
xlim([0,2000]);
grid on;

% info
fprintf('Key Information:\n');
fprintf('Original Signal Peak Amplitude: %.2f (Linear Scale)\n', amplitude_signal);
fprintf('Plots show amplitudes in dBFS with a range from -100 dBFS to 0 dBFS.\n');
