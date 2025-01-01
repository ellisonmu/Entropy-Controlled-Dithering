function [d_tpdf] = TPDF(d_rpdf)

%tpdf based on d_rpdf
d_tpdf = zeros(size(d_rpdf));
d_tpdf(1) = d_rpdf(1); 
d_tpdf(2:end) = d_rpdf(2:end) - d_rpdf(1:end-1); 

end