% Parameters for signal and quantization
N = 3; % bits
StartS = [0 0];
EndS = [];
fs = 44100;

% Load mono audio file
[x, fz] = audioread('sin-25dB.wav');
x = x / max(abs(x)); %normalize
amplitude = abs(x);
%A = max(amplitude);
A = 1;
q = (2 * A) / (2^N); % Quantization step size
T = 5;
numsamples = fs * T;

% # of alpha values

  % RPDF 
 d_rpdf = 0 * q * (rand(1, T * fs) - 0.5);  % Rectangular PDF dither

   % TPDF
   
d_rpdf = d_rpdf(:);

 [d_tpdf] = TPDF(d_rpdf);

x = x(:);


x_dithered = x + d_tpdf;
test_tpdf = d_tpdf;
   

  % Noise shaping feedback loop 
    ybef = quantizer(x_dithered, q);
    y = ybef - d_tpdf;
   x_quantized =  quantizer(x, q);

 
    % measures
    sd_entropy_values = AudioEntropy(y)
    mse_sd_raw = MSE(x, y)
    mse_sd = mse_sd_raw/(q^2)
    sd_visqol_values = visqol(x, y, fs)
    sd_stoi_values = stoi(x, y, fs)


