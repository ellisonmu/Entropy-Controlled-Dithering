function H = AudioEntropy(signal)

    signal = signal(:); 
    y_normalized = (signal - min(signal)) / (max(signal) - min(signal));
    [counts, ~] = histcounts(y_normalized, 'Normalization', 'probability'); 
    counts(counts == 0) = [];

    % Calculate entropy
    H = -sum(counts .* log2(counts));
end
