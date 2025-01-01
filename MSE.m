function mse = MSE(signal1,signal2)

    %   signal1: 
    %   signal2: 
    %   mse:
    
    mse = mean((signal1 - signal2).^2);
end

