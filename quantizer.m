function [x_quantized] = quantizer(x, q)
% inputs
%   x: signal
%   q: quantization levels
%
%  output:
%   x_quantized:

    x_quantized = round(x / q) * q;
end