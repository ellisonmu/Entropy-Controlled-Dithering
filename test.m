% Define parameters
A = 3;              % Amplitude
f = 5;              % Frequency in Hz
t_duration = 0.2;   % Duration of the signal in seconds
fs = 500;         % Sampling frequency in Hz
q = 3;              % Quantization levels
phi = 0;            % Phase shift in radians

% Time vector
t = 0:1/fs:t_duration; % Time vector from 0 to t_duration with 1/fs resolution

% Generate the sine wave
x = A * sin(2 * pi * f * t + phi);

% Add random noise (rectangular PDF)
d_rpdf = q * (rand(1, length(t)) - 0.5);
d = x + d_rpdf;

% Quantize the noisy signal
step_size = 2 * max(abs(d)) / (2^q - 1); % Quantization step size
y = round(d/ step_size) * step_size;    % Quantized signal

% Plot the sine wave
figure;
plot(t, y, 'b-', 'LineWidth', 1.5);
grid on;
title('Sine Wave without Dithering');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-1.5 * q, 1.5 * q]);