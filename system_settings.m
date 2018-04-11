function stSystemSettings = system_settings(varargin)

fs = 48000;

if nargin >= 1
    
    switch lower(varargin{1})
        
        case 'quickcalibrator'
            %% QuickCalibrator
            stSystemSettings.fChirpAmp             = 0.01; % digital amplitude of test chirp/sweep
            stSystemSettings.fCalibrationSinusAmp  = 0.01; % digital amplitude of test tone
            stSystemSettings.fCalibrationFrequency = 4000; % frequency of test tone, reference for absolute level
            stSystemSettings.mfOutInChannelList    = [0 3; 1 4 ]; % channel numbers starting with 0
            stSystemSettings.mfCrossChannelList    = [0 4; 1 3 ]; % channel numbers starting with 0, for cross talk evaluation
            stSystemSettings.vfExpFrequencyRange   = [250 18000];  % the frequency region used for experiments
            stSystemSettings.nOldEqualFilterOrder  = 300;  % obsolete             
            stSystemSettings.nEqualFilterOrder     = 128;  % FIR filter order for equalization filter           
            stSystemSettings.nSamplingFrequency    = fs; % general sampling frequency
            stSystemSettings.fSweepStartFrequency  = 50; % the chirp/sweep starts at this frequency (in Hz)
            stSystemSettings.fSweepRate            = 1;  % the chirp/sweep frequency increases with this speed in octaves/second
            stSystemSettings.nRepeats              = 10; % default number of chirp/sweep repeats for noise reduction
            stSystemSettings.sDeviceCode           = 'Hammerfall DSP'; % search for sound which contains this in name
            stSystemSettings.sHostAPI              = 'ASIO'; % search for sound API which contains this in name
            stSystemSettings.MicrophoneCal         = {
                'low', 93.15
                '-10', 93.15
                '+4',  101.93
                'mid', 101.93
                'Hi',  107.93
                'high',107.93
                'El',    2
                'el',    2
                '0',     0
                'zero',  0
                'bk',  106
                'buk', 106
                'probe', 122.2
                'gras',  143.9
                'fg23329', 136
                'ma3_40', 96.2 % old microphone calibration (Knowles FG-23329)
                'em23046', 94.6 % new microphone calibration from Tytology (Knowles EM-23046)
                'er-7c_ma3_40', 84.9 % Etymotic ER-7C  via +40 dB on TDT MA3 amplifier in RME Multiface @ -10dBV
                };
            stSystemSettings.MicFilter(4097,1:max(stSystemSettings.mfOutInChannelList(:,2))+1) = 0;
            stSystemSettings.MicFilter(1,1:max(stSystemSettings.mfOutInChannelList(:,2))+1) = 1;
            if exist('left_filter.mat','file')
                load 'left_filter.mat' coeffs_left
                stSystemSettings.MicFilter(:,4) = coeffs_left(:);
            end
            if exist('right_filter.mat','file')
                load 'right_filter.mat' coeffs_right
                stSystemSettings.MicFilter(:,5) = coeffs_right(:);
            end
            
end
