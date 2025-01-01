% Params
fs = 44100; 

%coeffients filter
a = 1;
b = EQShaping(fs);  

% Freq response
[H, f] = freqz(b, a, 1024, fs); 

% Plot
figure;
plot(f, 20*log10(abs(H))); 
grid on;
title('Frequency Response of the Filter');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
xlim([0 fs/2]); 