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
                'probe', 122
                'er-7c', 122
                'gras',  143.938
                };
            stSystemSettings.MicFilter(4097,1:max(stSystemSettings.mfOutInChannelList(:,2))+1) = 0;
            stSystemSettings.MicFilter(1,1:max(stSystemSettings.mfOutInChannelList(:,2))+1) = 1;
    end
            
end
