%This function combines and normalises the two distorted signals

function normalized_signal = combine_and_normalize(distorted_signal_sin, distorted_signal_soft_clip)
    % Combine the distorted signals
    combined_signal = distorted_signal_sin + distorted_signal_soft_clip;

    % Normalize the combined signal
    max_amplitude = max(abs(combined_signal));
    normalized_signal = combined_signal / max_amplitude;
end