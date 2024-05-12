% This code defines one of the two distortion functions used in the code.
% This defines the soft clipping distortion function.

function distorted_signal = sinusoidal_distortion(input_signal, distortion_factor)
    distorted_signal = sin(distortion_factor * input_signal);
end