function [d_combined] = TPDFspike(T, fs, d_tpdf, alpha)


    % Combine TPDF and delta function 
    mask = rand(1, T * fs) > alpha;  

    % Generate the delta function 
    delta_component = zeros(size(d_tpdf));  

    % Apply the mask
    d_combined = alpha * d_tpdf + (1 - alpha) * delta_component;
    d_combined(mask) = 0;  

end
