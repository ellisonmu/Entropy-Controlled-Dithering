function [d_combined, x_dither_quantized, y] = feedbackNoiseShapingSpike(num_iterations, x, q, fs, T, alpha, b, a, d_tpdf)
    % Noise shaping feedback
    %
    % Parameters:
    % x               
    % d_rpdf         
    % q               
    % fs             
    % num_iterations  
    % y               
    
    y = zeros(size(x));
    filtered_error = zeros(size(x)); 
    error_signal = zeros(size(x));
    x_dither_quantized = zeros(size(x));
    x_dither_signal = zeros(size(x));

    
    % feedback loop
    for i = 1:num_iterations

        d_combined = TPDFspike(T, fs, d_tpdf, alpha);
       
        for n = 1:length(x)

            x_dither_signal(n) = (x(n) - filtered_error(n)) + d_combined(n);
            x_dither_quantized(n) = quantizer(x_dither_signal(n), q);
            
            error_signal(n) = x_dither_quantized(n) - x(n);
            
            filtered_error(n) = filter(b, a, error_signal(n));
            
            y(n) = x_dither_quantized(n);
        end
    end
end

