% Params
Fs = 1000; 
T = 0.25; 
f = 5; 

% Time
t = 0:1/Fs:T; % Time vector for 1 second

%sine wave
A = 0.15;
sine_wave = A * sin(2 * pi * f * t);

% Quantization
n_bits = 3;
levels = 2^n_bits; 
q_step = (2 * 1) / levels; 

quantized_wave = round(sine_wave / q_step) * q_step;

quantization_levels = (-1:q_step:1); % Quantization levels

% Plot
figure;
plot(t, sine_wave, 'b-', 'LineWidth', 1.5); 
hold on;
plot(t, quantized_wave, 'r--', 'LineWidth', 1.5); 

for level = quantization_levels
    yline(level, 'k--', 'LineWidth', 0.8, 'Alpha', 0.5);
end

title('Sine Wave Quantized');
ylim([-1,1]);
xlabel('Time (s)');
ylabel('Amplitude');

