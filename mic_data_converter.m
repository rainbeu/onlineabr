%% load data files
left  = load('EM23046-3_PTplastic_fr2.mat');
right = load('EM23046-4_PTplastic_fr2.mat');

%% set processing and output parameters
target_fs = 48000;
target_filter_order = 4096;
spectral_smoothing = 0.75;
low_freq_magnitude = 0;
high_freq_magnitude = 0;

%% microphone and signal hardware parameters
% Mic_PascalToVolt = 10^(-53.5/20)*1.0/0.1; % Knowles FG-23329
% Mic_PascalToVolt = 10^(-56/20)*1.0/0.1; % Knowles EM-23046
Mic_PascalToVolt = 0.00138 * 10^(frdata.cal.MicGain_dB/20);

Mic_Out_Impedance = 4400; % Ohm

MicAmp_In_Impedance = 600; % Ohm
MicAmp_Out_Impedance = 5; % Ohm
MicAmp_GainFactor = 10^(frdata.cal.MicGain_dB/20); % linear

SoundCard_In_Impedance = 10000; % Ohm

SoundCardVoltToSample = 1/1.780;   % low / -10 dBV
% SoundCardVoltToSample = 1/4.893; % mid / +4 dBu
% SoundCardVoltToSample = 1/9.763; % high / Hi Gain

PhysAmp_Out_Impedance = 600; % Ohm
PhysAmp_GainFactor = 10000; % linear

Pa0dBSPL = 2e-5; % Pa @ 0 dB SPL

%% extract relevant variables
f_left  = left.frdata.Freqs(:);
f_right = right.frdata.Freqs(:);

m_left  = left.frdata.adjmag(:);
m_right = right.frdata.adjmag(:);

%% smooth spectrum on log frequency axis 
%  (better balance between low and high freqeuency smoothing)
log_f = logspace(log10(min(f_left)), log10(max(f_left)), max(length(f_left), length(f_right)));
fm_left = 10.^(interp1(log_f, filtfilt(1-spectral_smoothing, [1 -spectral_smoothing], ...
                interp1(f_left, db(m_left), ...
                    log_f, 'linear', 'extrap')), ...
                    f_left, 'linear', 'extrap')/20);
fm_right = 10.^(interp1(log_f, filtfilt(1-spectral_smoothing, [1 -spectral_smoothing], ...
                interp1(f_left, db(m_right), ...
                    log_f, 'linear', 'extrap')), ...
                    f_left, 'linear', 'extrap')/20);

%% invert and limit
fm_left = 1 ./ fm_left;
fm_left = min(fm_left, 10);
idx = ~isnan(fm_left) & ~isinf(fm_left);

fm_right = 1 ./ fm_right;
fm_right = min(fm_right, 10);
idx = idx & ~isnan(fm_right) & ~isinf(fm_right);
                
%% calculate FIR filter coefficients
coeffs_left  = fir2(target_filter_order, ...
                    [0; f_left(idx)/target_fs*2; 1], ...
                    [0; fm_left(idx); 1]);
coeffs_right = fir2(target_filter_order, ...
                    [0; f_right(idx)/target_fs*2; 1], ...
                    [0; fm_right(idx); 1]);
                
%%
dBFS2SPL = -db(Pa0dBSPL ...
    * Mic_PascalToVolt...
    * MicAmp_In_Impedance/(MicAmp_In_Impedance+Mic_Out_Impedance) ...
    * MicAmp_GainFactor ...
    * SoundCard_In_Impedance/(SoundCard_In_Impedance+MicAmp_Out_Impedance) ...
    * SoundCardVoltToSample)
                
%% save filter coefficients
save('left_filter.mat',  'coeffs_left',  'target_fs', 'dBFS2SPL');
save('right_filter.mat', 'coeffs_right', 'target_fs', 'dBFS2SPL');

%% display filter spectra for control
[H_left , F_left]  = freqz(coeffs_left,  1, 2^nextpow2(length(f_left)),  target_fs);
[H_right, F_right] = freqz(coeffs_right, 1, 2^nextpow2(length(f_right)), target_fs);

subplot(2, 1, 1)
semilogx(f_left, db(m_left), F_left, db(abs(H_left)));
xlim([50 target_fs/2]);
ylim([-30 30]);
grid on
title('left');

subplot(2, 1, 2)
semilogx(f_right, db(m_right), F_right, db(abs(H_right)));
xlim([50 target_fs/2]);
ylim([-30 30]);
grid on
title('right');

