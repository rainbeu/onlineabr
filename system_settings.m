function stSystemSettings = system_settings(varargin)

fs = 48000;

if nargin >= 1
    
    switch lower(varargin{1})
        
        case 'quickcalibrator'
            %% QuickCalibrator
            stSystemSettings.fChirpAmp             = 0.01; % was 0.1, eq -20 dB, 0.03 is -10 dB 
            stSystemSettings.fCalibrationSinusAmp  = 0.01; % was 0.1, eq -20 dB 
            stSystemSettings.fCalibrationFrequency = 4000;
            stSystemSettings.mfOutInChannelList    = [0 3; 1 4 ]; % starting with 0
            stSystemSettings.mfCrossChannelList    = [0 4; 1 3 ]; % starting with 0, for cross talk evaluation
            stSystemSettings.vfExpFrequencyRange   = [250 16500];  % the important frequency region (from 2017-01-30)
%             stSystemSettings.vfExpFrequencyRange   = [100 16500];  % the important frequency region (up to 2017-01-30)
%             stSystemSettings.vfExpFrequencyRange   = [500 16500];  % old values changed on 2016-11-29
            stSystemSettings.nOldEqualFilterOrder  = 300;             
            stSystemSettings.nEqualFilterOrder     = 128;             
            stSystemSettings.nSamplingFrequency    = fs;
            stSystemSettings.fSweepStartFrequency  = 50;
            stSystemSettings.fSweepRate            = 1;             % octaves/second
            stSystemSettings.nRepeats              = 10;
            stSystemSettings.sDeviceCode           = 'Hammerfall DSP';
            stSystemSettings.sHostAPI              = 'ASIO';
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
                'gras',  143.938
                'ma3_40', 96.179 % old microphone calibration (Knowles FG-23329)
                'em23046', 94.6109 % new microphone calibration from Tytology (Knowles EM-23046)
                'er-7c_ma3_40', 87.88 % Etymotic ER-7C  via +40 dB on TDT MA3 amplifier in RME Multiface @ -10dBV
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
            if exist('ER-7C B-1128.mat','file')
                load 'ER-7C B-1128.mat' flt
                stSystemSettings.MicFilter(1:length(flt(:)),6) = flt(:);
            end
            
        case 'analyserawdata'
            %% AnalyseRawData
            stSystemSettings.fBlocksize_s = 10;
            stSystemSettings.nSamplingRate = fs;
            stSystemSettings.fTriggerThresh = 0.05;
            stSystemSettings.nSpikeChannels = 1;
            stSystemSettings.nChannels = 6;

            
        case 'cutraws'
            %% CutRaws6
            stSystemSettings.nPreCutSamples = 10;
            stSystemSettings.fStartSeconds = 0.5;                  % seconds of silence at beginning of each recorded measurement session
            stSystemSettings.fTriggerCheckSeconds = 0.1;           % seconds reserved for start test of each trigger code
            stSystemSettings.nTrigChannel = 3;                     % channel number (starting with 1) of trigger channel
            stSystemSettings.nChannels = 6;                        % number of channels in input raw file
            stSystemSettings.sDataType = 'int16';                  % data type of input and trigger raw files (is usually int16)
            stSystemSettings.nDataBytes = ceil(nextpow2(double(intmax(stSystemSettings.sDataType)))/8);
            stSystemSettings.nDataBits = 8*stSystemSettings.nDataBytes;
            stSystemSettings.fNormConst = 32768;                   % max data value in raw files (is usually 32768 when datatype is int16)
            stSystemSettings.sTriggerPrefix = 'trigger_code_';     % filename prefix of trigger raw files
            stSystemSettings.FrameLen = 2^16;                      % trigger search subframe length
            stSystemSettings.FrameOverlap = 2048;                  % trigger search subframe overlap (double trigger len)
            stSystemSettings.fNoTrigThresh = 0.1;
            stSystemSettings.sCutFilePrefix = 'temp/cutfile_';
    
            
        case 'analyseplexondata'
            %% 
            % stSystemSettings. = ;
            
        case 'estimatespikethreshold'
            %% 
            % stSystemSettings. = ;
            stSystemSettings.LowFilter  = 300;
            stSystemSettings.HighFilter = 6000;
            stSystemSettings.SNRFactor  = 10; % hier Faktor angeben, um den errechneten Spikethreshold größer zu machen, 10 passt zu Auswertung und ungefähr zu unseren Schätzungen...
            
        case 'parseplayfile'
            %% 
            % stSystemSettings. = ;
            
        case 'signalbrowser'
            %% 
            % stSystemSettings. = ;
            
        case 'spikedetector'
            %% 
            % stSystemSettings. = ;
            stSystemSettings.sDataType         = 'int16';
            stSystemSettings.nBitScaling       = intmax(stSystemSettings.sDataType);
            stSystemSettings.LowFilter         = 300;
            stSystemSettings.HighFilter        = 6000;
            stSystemSettings.fWinPreTime       = 0.25e-3;
            stSystemSettings.fWinPostTime      = 0.75e-3;
            stSystemSettings.fRefractoryPeriod = 0.5e-3;
            stSystemSettings.bPlot             = false;
            stSystemSettings.nChannels         = 6;
            stSystemSettings.nFs               = fs;

            
        case 'triggertest'
            %% 
            % stSystemSettings. = ;
            
        case 'spikeanalyser'
            %% 
            % stSystemSettings. = ;
            
        case 'readresultrile'
            %% 
            % stSystemSettings. = ;
            
        case 'constants'
            %% 
            % stSystemSettings. = ;
            
        case 'generateflra'
            %% 
            % stSystemSettings. = ;
            
        case 'makesearch'
            %% 
            % stSystemSettings. = ;
            stSystemSettings.fNoiseLevel       = 85;    % dB SPL (total noise level)
            stSystemSettings.fOverallDuration  = 600;   % seconds
            stSystemSettings.fNoiseDuration    = 0.050; % seconds
            stSystemSettings.fHannRampDuration = 0.003; % seconds
            stSystemSettings.fRepetitionTime   = 0.550; % seconds
            stSystemSettings.ChannelList       = [0 1];
            
        case 'makestairs'
            %% 
            % stSystemSettings. = ;
            stSystemSettings.vfFrequencyList   = [200 500 1000 2000 3000 4000 5000 6000 7000 8000 10000 12000]; %[200 500 1000 2000 3000 4000 5000 6000 7000 8000 10000 12000 14000 16000]
            stSystemSettings.fToneLevel        = 80;     % dB SPL
            stSystemSettings.fOverallDuration  = 1320;  % seconds
            stSystemSettings.fToneDuration     = 0.100; % seconds
            stSystemSettings.fHannRampDuration = 0.010; % seconds
            stSystemSettings.fRepetitionTime   = 1.100; % seconds
            stSystemSettings.ChannelList       = [0 1];
            
        case 'getamplitudefromcal'
            %% 
            % stSystemSettings. =false ;
            
%         case ''
%             %% 
%             % stSystemSettings. = ;
            
            
    end

end
