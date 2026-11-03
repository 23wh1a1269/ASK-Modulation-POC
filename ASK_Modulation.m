
clc;
clear;
close all;

% ASK Modulation and Demodulation
% Input binary data
bits = [1 0 1 1 0 0 1 0];

% Signal parameters
bitrate = 1;
fc = 5;
fs = 1000;
Tb = 1/bitrate;

% Time vector
t = 0:1/fs:length(bits)*Tb-1/fs;

% Generate digital signal
digital = repelem(bits, fs/bitrate);

% Generate carrier signal
carrier = cos(2*pi*fc*t);

% ASK modulation
ask_signal = digital .* carrier;

% ASK demodulation
rectified = abs(ask_signal);
window = ones(1,fs/bitrate)/(fs/bitrate);
received = conv(rectified,window,'same');

% Recover original bits
recovered = zeros(1,length(bits));

for i = 1:length(bits)
    start_index = (i-1)*fs/bitrate+1;
    end_index = i*fs/bitrate;

    sample = mean(received(start_index:end_index));
    recovered(i) = sample > 0.3;
end

% Display results
figure;

subplot(4,1,1);
plot(t,digital);
title('Input Binary Signal');
xlabel('Time');
ylabel('Amplitude');
grid on;

subplot(4,1,2);
plot(t,carrier);
title('Carrier Signal');
xlabel('Time');
ylabel('Amplitude');
grid on;

subplot(4,1,3);
plot(t,ask_signal);
title('ASK Modulated Signal');
xlabel('Time');
ylabel('Amplitude');
grid on;

subplot(4,1,4);
stairs(0:length(bits)-1,recovered);
title('Demodulated Output');
xlabel('Bit Number');
ylabel('Amplitude');
ylim([-0.2 1.2]);
grid on;

disp('Original Binary Data:');
disp(bits);

disp('Recovered Binary Data:');
disp(recovered);
print('ASK_Output.png', '-dpng');
