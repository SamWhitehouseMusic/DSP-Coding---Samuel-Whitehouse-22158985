% This code defines one of the two distortion functions used in the code.
% This defines the soft clipping distortion function.

function distorted_signal = soft_clipping_distortion(input_signal, threshold)
    distorted_signal = 2/pi * atan(input_signal ./ threshold);
end