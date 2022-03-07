function stSystemSettings = system_settings(varargin)

fs = 48000;

if nargin >= 1
    
    switch lower(varargin{1})
        
        case 'quickcalibrator'
            %% QuickCalibrator
            stSystemSettings.fChirpAmp             = 0.03; % was 0.1, eq -20 dB, 0.03 is -10 dB 
            stSystemSettings.fCalibrationSinusAmp  = 0.03; % was 0.1, eq -20 dB 
            stSystemSettings.fCalibrationFrequency = 1000;
            stSystemSettings.mfOutInChannelList    = [0 3; 1 4 ]; % starting with 0
            stSystemSettings.mfCrossChannelList    = [0 4; 1 3 ]; % starting with 0, for cross talk evaluation
            stSystemSettings.vfExpFrequencyRange   = [100 22000];  % the important frequency region (from 2017-01-30)
            stSystemSettings.nOldEqualFilterOrder  = 300;             
            stSystemSettings.nEqualFilterOrder     = 128;             
            stSystemSettings.nSamplingFrequency    = fs;
            stSystemSettings.fSweepStartFrequency  = 50;
            stSystemSettings.fSweepRate            = 1;             % octaves/second
            stSystemSettings.nRepeats              = 10;
            stSystemSettings.sDeviceCode           = 'Hammerfall DSP';
            stSystemSettings.sHostAPI              = 'ALSA';
            stSystemSettings.MicrophoneCal         = {
                'low', 132.15
                '-10', 132.15
                '+4',  140.93
                'mid', 140.93
                'Hi',  146.93
                'high',146.93
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
                'er-7c_ma3_10', 30+84.9 % Etymotic ER-7C  via +40 dB on TDT MA3 amplifier in RME Multiface @ -10dBV
                'nadine', 84.9 % Etymotic ER-7C  via +40 dB on TDT MA3 amplifier in RME Multiface @ -10dBV
                'christine', 96.2 % old microphone calibration (Knowles FG-23329)
                };
            stSystemSettings.MicFilter(4097,1:max(stSystemSettings.mfOutInChannelList(:,2))+1) = 0;
            stSystemSettings.MicFilter(1,1:max(stSystemSettings.mfOutInChannelList(:,2))+1) = 1;
            if exist('mic/ER-7C B-1128.mat','file') 
                load 'mic/ER-7C B-1128.mat' flt
                stSystemSettings.MicFilter(1:length(flt),4) = flt(:);
                fprintf('using reference calibration for ER-7C #1128, left channel\n');
            end
            if exist('mic/ER-7C B-1130.mat','file')
                load 'mic/ER-7C B-1130.mat' flt
                stSystemSettings.MicFilter(1:length(flt),5) = flt(:);
                fprintf('using reference calibration for ER-7C #1130, right channel\n');
            end
            if strcmp(stSystemSettings.MicrophoneCal, 'nadine')
                if exist('mic/ER-7C_B-1389.mat','file')
                    load 'mic/ER-7C_B-1389.mat' flt
                    ch = stSystemSettings.mfOutInChannelList(1, 2)+1;
                    stSystemSettings.MicFilter(:,ch) = 0;
                    stSystemSettings.MicFilter(1:length(flt),ch) = flt(:);
                    fprintf('using reference calibration for ER-7C #1389, left channel\n');
                end
                if exist('mic/ER-7C_B-1289.mat','file')
                    load 'mic/ER-7C_B-1289.mat' flt
                    ch = stSystemSettings.mfOutInChannelList(2, 2)+1;
                    stSystemSettings.MicFilter(:,ch) = 0;
                    stSystemSettings.MicFilter(1:length(flt),ch) = flt(:);
                    fprintf('using reference calibration for ER-7C #1289, right channel\n');
                end
           end
            
    end

end
