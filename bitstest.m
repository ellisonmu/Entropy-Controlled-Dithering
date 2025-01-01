% Read the audio file
[x, fs] = audioread('sin-0dB.wav');
x = x / max(abs(x));  % normalize

% Parameters
A = 1;               
T = 5;             
NumSamples = fs * T; 
x = x(1:NumSamples);  

%initialize results
N_values = 1:8;        
visqol_scores = zeros(size(N_values));  

% loop for quantization and VISQOL 
for i = 1:length(N_values)
    N = N_values(i);  % Current quantization level
    Q = (2 * A) / (2^N);  % Step size for quantization

    % quantize
    y = round(x / Q) * Q;

    visqol_scores(i) = visqol(x, y, fs); 
end

% Plot 
figure;
bar(N_values, visqol_scores, 'FaceColor', [0.2, 0.6, 0.8]); 
title('VISQOL Scores for Different Quantization Levels');
xlabel('Quantization Levels (N)');
ylabel('VISQOL Score');
grid on;