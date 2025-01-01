% Parameters for signal and quantization
N = 3; % bits
StartS = [0 0];
EndS = [];
fs = 44100;

% Load mono audio file
[x, fz] = audioread('sinC4.wav');
amplitude = abs(x);
A = max(amplitude);
disp(A)
keyboard;

q = (2 * A) / (2^N); % Quantization step size
T = 5;
numsamples = fs * T;
%sound(x, fs);

num_iterations = 100; % # iterations for feedback loop

% RPDF dither 
  d_rpdf = q * (rand(1, T * fs) - 0.5); % Rectangular PDF dither

  % TPDF dither
  d_tpdf = TPDF(d_rpdf);

 % design filter
    a = 1;
    [b] = EQShaping(fs);

 x = x(:);
 d_tpdf = d_tpdf(:);
 size(x);
 dize(d_tpdf);
 keyboard;

 alpha = 1;
  test_tpdf = alpha * d_tpdf;

    % Noise shaping feedback loop 
    [x_dither_quantized, y] = feedbackNoiseShaping(num_iterations, x, q, b, a, test_tpdf);   
    
    % Subtractive dither 
    shaped_tpdf = filter(b, a, test_tpdf);

    ysd = y - shaped_tpdf; 

    audiowrite('testsingal', ysd);