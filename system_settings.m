function stSystemSettings = system_settings(varargin)

fs = 48000;

if nargin >= 1
    
    switch lower(varargin{1})
        
        case 'quickcalibrator'
            %% QuickCalibrator
            stSystemSettings.fChirpAmp             = 0.03;
            stSystemSettings.fCalibrationSinusAmp  = 0.03;
            stSystemSettings.fCalibrationFrequency = 1000;
            stSystemSettings.mfOutInChannelList    = [4 3; 5 4 ]; % starting with 0
            stSystemSettings.mfCrossChannelList    = [4 4; 5 3 ]; % starting with 0, for cross talk evaluation
            stSystemSettings.vfExpFrequencyRange   = [400 22000];  % the important frequency region
            stSystemSettings.nEqualFilterOrder     = 128;             
            stSystemSettings.nSamplingFrequency    = fs;
            stSystemSettings.fSweepStartFrequency  = 200;
            stSystemSettings.fSweepRate            = 1;             % octaves/second
            stSystemSettings.nRepeats              = 10;
            stSystemSettings.sDeviceCode           = 'Hammerfall DSP';
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
                'probe', 122
                'gras',  143.938
                };
            stSystemSettings.MicFilter(4097,1:max(stSystemSettings.mfOutInChannelList(:,2))+1) = 0;
            stSystemSettings.MicFilter(1,1:max(stSystemSettings.mfOutInChannelList(:,2))+1) = 1;
            if exist('ER-7C B-1000.mat','file')
                load 'ER-7C B-1000.mat' flt
                stSystemSettings.MicFilter(:,4) = flt(:);
            end
            if exist('ER-7C B-1048.mat','file')
                load 'ER-7C B-1048.mat' flt
                stSystemSettings.MicFilter(:,5) = flt(:);
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
