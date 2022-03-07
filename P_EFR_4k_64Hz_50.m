handles.Setup.Stimulus.Duration       = 0.200;
handles.Setup.Stimulus.Type           = 'efr'; 
handles.Setup.Stimulus.Frequency      = 64; % modulation freq

handles.Setup.Stimulus.ModulationDepth = 0.5;  % in ratio: 0.0 to 1.0; one per ABR recording only!

handles.Setup.Stimulus.CarrierFrequency = 4000; 
handles.Setup.Stimulus.RampDur        = 0.005; 
handles.Setup.Stimulus.Window         = 'hann'; % 'none';% 'hann'; % 'ongoing'; % 'onoffset'; % 'all';
handles.Setup.Stimulus.Level          = 0; % dB SPL after calibration

handles.Setup.Stimulus.StimulusLevelOffsets  = 80; %[65 70 75 80 85]; % dB re stimulus level ("Level")

handles.Setup.Recording.MaxRepsPerCond = 200;

handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Stimulus.UseSignSwapping = true; % true: envelope decisive

% handles.Setup.Stimulus.PresentationType      = 'L/R/B';
handles.Setup.Stimulus.PresentationType      = 'simple binaural'; % needs definition of stimulus side, see below

%% configuration for Setup.Stimulus.PresentationType == 'simple binaural'
handles.Setup.Stimulus.StimulusSide =  'L+R'; % 'L', 'R', 'L+R'
%

handles.Setup.Recording.ExtraSmp    = 1500;
handles.Setup.Recording.PreZeros    = 480;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 1/3.1; % =1/repetition rate

handles.Setup.Recording.ArtefactThr = 20; % µV
handles.Setup.Recording.RejectArtefacts = true;

handles.Setup.Recording.Randomization = 'running'; % use 'fixed' for a pre-randomized list of repetitions 


% unused / only internally used
%% just fill in reasonable "null" values
handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = [0]; % dB

handles.Setup.Stimulus.MaskerSide   =  'L+R'; % 'L', 'R', 'L+R'
handles.Setup.Stimulus.BufferLen             = 0;  % samples
handles.Setup.Stimulus.IAC                   = 0;  % interaural correlation of masker
handles.Setup.Stimulus.CenterFreq            = 0;  % Hz
handles.Setup.Stimulus.BandWidth             = 0;  % Hz
handles.Setup.Stimulus.MaskerLevel           = 0;  % dB SPL
handles.Setup.Stimulus.MaskerDuration        = 0;  % seconds
handles.Setup.Stimulus.StimOnsetDelay        = 0;  % seconds
handles.Setup.Stimulus.MaskerLevelOffsets    = [0]; % dB re masker level ("MaskerLevel")
handles.Setup.Stimulus.MaskerRampDur         = 0;  % seconds
handles.Setup.Stimulus.MaskerFrozen          = true; %

% %% debug values
% handles.Setup.Hardware.PlayDev    = 7;
% handles.Setup.Hardware.RecDev     = 7;
% handles.Setup.Hardware.PlayCh     = 18;
% handles.Setup.Hardware.RecCh      = 18;
% handles.Setup.Recording.EEGCh     = 5;
% handles.Setup.Recording.MicCh     = [1 2];
