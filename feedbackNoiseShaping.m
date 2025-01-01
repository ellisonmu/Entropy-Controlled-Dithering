function [x_dither_quantized, y] = feedbackNoiseShaping(num_iterations, x, q, b, a, test_tpdf)
    % noise shaping feedback loop
    %
    % Parameters:
    % x               : input signal
    % d_tpdf
    % q               : quantization step size
    % fs              : sampling frequency
    % num_iterations  
    %
    % Returns:
    % y               : output signal

    y = zeros(size(x));
    filtered_error = zeros(size(x)); 
    error_signal = zeros(size(x));
    x_dither_quantized = zeros(size(x));
    x_dither_signal = zeros(size(x));

    % feedback loop
    for i = 1:num_iterations

        % process each sample
        for n = 1:length(x)
            % dither additon and quantization
            x_dither_signal(n) = (x(n) - filtered_error(n)) + test_tpdf(n);
            x_dither_quantized(n) = quantizer(x_dither_signal(n), q);
            
            % calculate the error signal
            error_signal(n) = x_dither_quantized(n) - x(n);
            
            filtered_error(n) = filter(b, a, error_signal(n));
            
            % update the output signal 
            y(n) = x_dither_quantized(n);
        end
    end
end
