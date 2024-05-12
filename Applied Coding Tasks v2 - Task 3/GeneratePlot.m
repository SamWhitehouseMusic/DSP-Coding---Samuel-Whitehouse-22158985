%This code generates a chirp signal, combines the two distortion functions
%and applies them to the signal. A notch filter is then applied to two
%selected frequencies and the signals are plotted alongside the STFTs to
%demonstrate the changes made to the signal via distortion and filtering.

% Generate the chirp signal
Fs = 44100; % Sets the sampling frequency
t = 0:1/Fs:2; % Sets the duration of the signal

% This defines the parameters of the chirp signal
f0 = 1000;          % Starting frequency in Hertz
f1 = Fs/2 - 100;    % Ending frequency in Hertz - this will be close to the Nyquist Frequency
t1 = 2;             % Duration of the chirp in seconds

% This generates the initial chirp signal
chirp_signal = chirp(t, f0, t1, f1);

% Define the distortion factors and thresholds
distortion_factor_sin = 3; % This can alter the sinusodial distortion
threshold_soft_clip = 3; % This can alter the soft clipping distortion

% This applies sinusoidal distortion to the chirp signal
distorted_signal_sin = sinusoidal_distortion(chirp_signal, distortion_factor_sin);

% This applies soft clipping distortion to the chirp signal
distorted_signal_soft_clip = soft_clipping_distortion(chirp_signal, threshold_soft_clip);

% This plot the original chirp signal and the distorted signals
figure;
subplot(3,1,1);
plot(t, chirp_signal);
title('Original Chirp Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, distorted_signal_sin);
title('Chirp Signal with Sinusoidal Distortion');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(t, distorted_signal_soft_clip);
title('Chirp Signal with Soft Clipping Distortion');
xlabel('Time (s)');
ylabel('Amplitude');

% This calls the function to combine and normalize distorted signals
normalized_signal = combine_and_normalize(distorted_signal_sin, distorted_signal_soft_clip);

% Notch filtering constants
Fs = 44100;  % Sampling frequency
f1 = 4000;   % Frequency 1 to attenuate (in Hz)
f2 = 6000;   % Frequency 2 to attenuate (in Hz)
Q = 10;      % Q factor for the notch filter

% Calculate alpha and omega values
omega1 = 2 * pi * f1 / Fs;
omega2 = 2 * pi * f2 / Fs;
alpha1 = sin(omega1) / (2 * Q);
alpha2 = sin(omega2) / (2 * Q);

% Frequency 1 Coefficients
b01 = 1;
b11 = -2 * cos(omega1);
b21 = 1;
a01 = 1 + alpha1;
a11 = -2 * cos(omega1);
a21 = 1 - alpha1;

% Frequency 2 Coefficients
b02 = 1;
b12 = -2 * cos(omega2);
b22 = 1;
a02 = 1 + alpha2;
a12 = -2 * cos(omega2);
a22 = 1 - alpha2;

% Apply the notch filters to the normalized distorted signal
filtered_signal_1 = filter([b01, b11, b21], [a01, a11, a21], normalized_signal); %Creates the first notch
filtered_signal_2 = filter([b02, b12, b22], [a02, a12, a22], filtered_signal_1); %Adds the second notch

% Plot the original and filtered signals
t = (0:length(normalized_signal)-1) / Fs;
figure;
subplot(2,1,1);
plot(t, normalized_signal);
title('Original Distorted Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, filtered_signal_2);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');
% Play the audio of the filtered signal
sound(filtered_signal_2, Fs);


% Parameters for STFT calculation
window_length = 1024;  % Length of the window for STFT
overlap_length = 512;  % Length of overlap between consecutive windows

% Calculate STFT for the clean chirp signal
[~, f_clean, t_clean, S_clean] = spectrogram(chirp_signal, window_length, overlap_length, [], Fs);

% Calculate STFT for the distorted signal
[~, f_distorted, t_distorted, S_distorted] = spectrogram(normalized_signal, window_length, overlap_length, [], Fs);

% Calculate STFT for the filtered signal
[~, f2, t2, S2] = spectrogram(filtered_signal_2, window_length, overlap_length, [], Fs);

% Plot STFT for clean chirp signal
figure;
subplot(3, 1, 1);
imagesc(t_clean, f_clean, 10*log10(abs(S_clean)));
axis xy;
colormap jet;
colorbar;
title('STFT of Clean Chirp Signal');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% Plot STFT for the distorted signal
subplot(3, 1, 2);
imagesc(t_distorted, f_distorted, 10*log10(abs(S_distorted)));
axis xy;
colormap jet;
colorbar;
title('STFT of Distorted Chirp Signal');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% Plot STFT for the filtered signal
subplot(3 ,1, 3);
imagesc(t2, f2, 10*log10(abs(S2)));
axis xy;
colormap jet;
colorbar;
title('STFT of Filtered Signal');
xlabel('Time (s)');
ylabel('Frequency (Hz)');