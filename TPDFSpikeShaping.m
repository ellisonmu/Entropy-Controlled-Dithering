% Parameters
N = 3; % bits
StartS = [0 0];
EndS = [];
fs = 44100;

% Load mono audio file
[x, fz] = audioread('sinD4.wav');
x = x / max(abs(x)); %normalize
amplitude = abs(x);
A = max(amplitude);
%A = 1;
q = (2 * A) / (2^N); % Quantization step size
T = 5;
numsamples = fs * T;
%sound(x, fs);

num_iterations = 100; 

% # alpha for loop
num_alpha = 20;
alpha_values = linspace(0, 1, num_alpha);

% preallocation
sd_entropy_values = zeros(1, num_alpha);
nsd_entropy_values = zeros(1, num_alpha);
mse_sd_raw = zeros(1, num_alpha);
mse_nsd_raw = zeros(1, num_alpha);
mse_sd = zeros(1, num_alpha);
mse_nsd = zeros(1, num_alpha);
sd_visqol_values = zeros(1, num_alpha);
nsd_visqol_values = zeros(1, num_alpha);
sd_stoi_values = zeros(1, num_alpha);
nsd_stoi_values = zeros(1, num_alpha);
nsd_visqol_values = zeros(1, num_alpha);

 % design filter
 a = 1;
 [b] = EQShaping(fs); %EQ filter

 % RPDF dither
 d_rpdf = q * (rand(1, T * fs) - 0.5); 

   % TPDF
  d_tpdf = TPDF(d_rpdf);

 x = x(:);
 d_tpdf = d_tpdf(:);

% Loop for alpha
for i = 1:num_alpha
    alpha = alpha_values(i);
    
    % Noise shaping loop
    [d_combined, x_dither_quantized, y] = feedbackNoiseShapingSpike(num_iterations, x, q, fs, T, alpha, b, a, d_tpdf);   
    
    % subtractive dither
    shaped_tpdf = filter(b, a, d_combined);
    ysd = y - shaped_tpdf;
    
    % Entropy calculation
    sd_entropy_values(i) = AudioEntropy(ysd);
    nsd_entropy_values(i) = AudioEntropy(y);

   % MSE 
    mse_sd_raw(i) = MSE(x, ysd);
    mse_nsd_raw(i) = MSE(x, y);
    mse_sd(i) = mse_sd_raw(i)/(q^2);
    mse_nsd(i) = mse_nsd_raw(i)/(q^2);

    % VISQOL
    sd_visqol_values(i) = visqol(x, ysd, fs);  
    nsd_visqol_values(i) = visqol(x, y, fs);   

    % STOI
    sd_stoi_values(i) = stoi(x, ysd, fs);  
    nsd_stoi_values(i) = stoi(x, y, fs);

    fprintf('Progress: %.0f alpha\n', i); 
end

% Plot the results
figure;

% 1: entropy vs alpha
subplot(3,1,1);
hold on;
plot(alpha_values, sd_entropy_values, 'b', 'DisplayName', ' SD Entropy');
plot(alpha_values, nsd_entropy_values, 'k', 'DisplayName', ' NSD Entropy');

title('Entropy vs Alpha');
xlabel('Alpha');
ylabel('Entropy');
legend; 

% 2: SD and NSD VISQOL vs Alpha
subplot(3,1,2);
hold on; 
plot(alpha_values, sd_visqol_values, 'r', 'DisplayName', 'SD VISQOL'); 
plot(alpha_values, nsd_visqol_values, 'g', 'DisplayName', 'NSD VISQOL'); 
hold off; 

title('VISQOL vs Alpha');
xlabel('Alpha');
ylabel('VISQOL');
legend; 

% 4: SD and NSD MSE vs Alpha
subplot(3,1,3);
hold on; 
plot(alpha_values, mse_sd, 'm', 'DisplayName', 'SD MSE'); 
plot(alpha_values, mse_nsd, 'c', 'DisplayName', 'NSD MSE'); 
hold off; 

title('MSE vs Alpha');
xlabel('Alpha');
ylabel('MSE');
legend; 

sgtitle('Entropy, VISQOL, STOI, and MSE vs Alpha Values');

figure;

% scatter plot for VISQO vs entropy
scatter(sd_entropy_values, sd_visqol_values, 50, alpha_values, 'filled');  

colorbar;
xlabel('Entropy');
ylabel('VISQOL');

sgtitle('VISQOL vs Entropy');


figure;
% scatter plot for STOI vs entropy
scatter(sd_entropy_values, sd_stoi_values, 50, alpha_values, 'filled');  

colorbar;
xlabel('Entropy');
ylabel('STOI');

sgtitle('STOI vs Entropy');
