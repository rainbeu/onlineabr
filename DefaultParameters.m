handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_fake_0000-00-00.mat';

%%
handles.Setup.Fs                  = 48000;
handles.Setup.DisplayTime         = 1;  % display is updated every ... seconds 

handles.Setup.Hardware.DryRun     = false; % for use with real sound hardware
% handles.Setup.Hardware.DryRun     = true; % for use without actual sound hardware

handles.Setup.Hardware.PlayDev    = get_playrec_device_id; % ASIO was 42 until 2015/07/21, new RME driver
handles.Setup.Hardware.RecDev     = get_playrec_device_id; % ASIO was 42 until 2015/07/21, new RME driver
handles.Setup.Hardware.PlayCh     = 6;
handles.Setup.Hardware.RecCh      = 6;
handles.Setup.Hardware.BufferSize = 0;
handles.Setup.Hardware.LatencySamples = 1024;

handles.Setup.Hardware.LevelCorrection = [0 0];
handles.Setup.Hardware.StimCh     = [1 2];
handles.Setup.Hardware.TrgCh      = 3;

handles.Setup.Stimulus.Duration       = 0.010;
handles.Setup.Stimulus.Type           = 'click'; % 'click';  % 'tone'; % 'wave'; % 'CAP'; % 'transposedtone' 
handles.Setup.Stimulus.Frequency      = 4000;
handles.Setup.Stimulus.ModulationDepth = 0;
handles.Setup.Stimulus.CarrierFrequency = 4000; % for transposedtone
handles.Setup.Stimulus.LowPassFrequency = 2000; % for transposedtone
handles.Setup.Stimulus.Fs             = handles.Setup.Fs;
handles.Setup.Stimulus.FileName       = 'chirp20kHz_48kHz.wav'; 
handles.Setup.Stimulus.FileTimeOffset = 203/48000;
handles.Setup.Stimulus.SampleFormat   = 'int16';
handles.Setup.Stimulus.FileCh         = 1;
handles.Setup.Stimulus.bDoResample    = false;
handles.Setup.Stimulus.RampDur        = 0.001; 
handles.Setup.Stimulus.Window         = 'hann'; % 'none';% 'hann'; % 'ongoing'; % 'onoffset'; % 'all';
handles.Setup.Stimulus.Level          = 70; % dB SPL after calibration

handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = [0]; % dB

handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Stimulus.UseSignSwapping = true;
handles.Setup.Stimulus.Frozen = true;

% handles.Setup.Stimulus.PresentationType      = 'L/R/B';
handles.Setup.Stimulus.PresentationType      = 'simple binaural';

%% configuration for Setup.Stimulus.PresentationType == 'simple binaural'
handles.Setup.Stimulus.StimulusSide =  'R'; % 'R';  % 'L+R';
handles.Setup.Stimulus.MaskerSide   =  'R'; % 'R';  % 'L+R';
%

handles.Setup.Stimulus.BufferLen             = 2^16;  % samples
handles.Setup.Stimulus.IAC                   = 1;      % interaural correlation of masker
handles.Setup.Stimulus.CenterFreq            = 6000;  % Hz
handles.Setup.Stimulus.BandWidth             = 11000;  % Hz
handles.Setup.Stimulus.MaskerLevel           = 70;     % dB SPL
handles.Setup.Stimulus.MaskerDuration        = 0.100; % seconds
handles.Setup.Stimulus.StimOnsetDelay        = 0.101; % seconds
handles.Setup.Stimulus.MaskerLevelOffsets    = [0 -10 +10];  % dB re masker level ("MaskerLevel")
handles.Setup.Stimulus.StimulusLevelOffsets  = [0 5];       % dB re stimulus level ("Level")
handles.Setup.Stimulus.MaskerRampDur         = 0.001;        % seconds
handles.Setup.Stimulus.MaskerFrozen          = false;        %


handles.Setup.Recording.FileName    = ['/home/experiment/data/carolin/ABR/abrdata_'];
handles.Setup.Recording.EEGCh       = 1;
handles.Setup.Recording.MicCh       = [4 5];
handles.Setup.Recording.TrgCh       = 3;
handles.Setup.Recording.SaveCh      = [7 8];

handles.Setup.Recording.ExtraSmp    = 4800;
handles.Setup.Recording.PreZeros    = 480;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.ArtefactThr = 20; % µV
handles.Setup.Recording.RejectArtefacts = true;

handles.Setup.Recording.MaxRepsPerCond = 500;
handles.Setup.Recording.Randomization = 'running'; % use 'fixed' for a pre-randomized list of repetitions 

%% sound card
%% peak voltages
handles.Setup.Hardware.SoundCardVoltToSamplePeak = 1/1.780; % low / -10 dBV
% handles.Setup.Hardware.SoundCardVoltToSamplePeak = 1/4.893; % mid / +4 dBu
% handles.Setup.Hardware.SoundCardVoltToSamplePeak = 1/9.763; % high / Hi Gain
%% RMS voltages
handles.Setup.Hardware.SoundCardVoltToSampleRMS = 1/1.259; % low / -10 dBV
% handles.Setup.Hardware.SoundCardVoltToSampleRMS = 1/3.460; % mid / +4 dBu
% handles.Setup.Hardware.SoundCardVoltToSampleRMS = 1/6.904; % high / Hi Gain
%% 
handles.Setup.Hardware.SoundCard_In_Impedance = 10000; % Ohm

%% microphone amplifier (if applicable)
% no mic amp
handles.Setup.Hardware.MicAmp_Out_Impedance = 0; % Ohm
handles.Setup.Hardware.MicAmp_In_Impedance = 1e9; % Ohm
handles.Setup.Hardware.MicAmp_GainFactor = 10^(0/20); % linear

% TDT MA3 @ 40 dB amplification
% handles.Setup.Hardware.MicAmp_Out_Impedance = 5; % Ohm
% handles.Setup.Hardware.MicAmp_In_Impedance = 600; % Ohm
% handles.Setup.Hardware.MicAmp_GainFactor = 10^(40/20); % linear

%% microphone
% Knowles FG-23329
% handles.Setup.Hardware.Mic_Out_Impedance = 4400; % Ohm
% handles.Setup.Hardware.Mic_PascalToVoltRMS = 10^(-53.5/20)*1.0/0.1; % Knowles FG-23329 RMS!
% handles.Setup.Hardware.Mic_PascalToVoltPeak = 10^(-50.5/20)*1.0/0.1; % Knowles FG-23329 Peak!

% Etymotic ER-7C probe microphone
handles.Setup.Hardware.Mic_Out_Impedance = 235; % Ohm % Etymotic ER-7C probe microphone
handles.Setup.Hardware.Mic_PascalToVoltRMS = 0.050; % Etymotic ER-7C probe microphone

% if not empty: skip detailed calculation of microphone transfer
handles.Setup.Hardware.Mic_Cal_Value = [];
% handles.Setup.Hardware.Mic_Cal_Value = 96.179; % add to dB FS to get dB SPL

%% physiological signal amplifier
handles.Setup.Hardware.PhysAmp_Out_Impedance = 600; % Ohm
handles.Setup.Hardware.PhysAmp_GainFactor = 10000; % linear

