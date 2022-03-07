
handles.Setup.Stimulus.Level                 = 0;      % dB SPL after calibration
handles.Setup.Stimulus.StimulusLevelOffsets  = [100];   % dB re stimulus level ("Level")

handles.Setup.Stimulus.Duration     = 0.010; % in ms
handles.Setup.Stimulus.Type         = 'click'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Window       = 'none';
handles.Setup.Stimulus.RampDur        = 0.000; % for click no ramp

handles.Setup.Stimulus.Type         = 'tone'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Window       = 'hann';
handles.Setup.Stimulus.RampDur        = 0.002; % for click no ramp

%%
handles.Setup.Recording.ArtefactThr     = 100;      % �V, set actual level in OnlineABR
handles.Setup.Recording.RejectArtefacts = true; % true: reject artefacts above threshold, false: do not reject artefacts at all

handles.Setup.Recording.MaxRepsPerCond       = 300;


%%
handles.Setup.Stimulus.ITD          = 0;  % sec. e.g. [-2000 -1000 -500 -250 -100 0 100 250 500 1000 2000]
handles.Setup.Stimulus.ILD          = 0; % dB

handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Stimulus.UseSignSwapping = false;

handles.Setup.Stimulus.PresentationType      = 'simple binaural';
handles.Setup.Stimulus.StimulusSide = 'L+R'; % 'R', 'L+R'

handles.Setup.Stimulus.MaskerSide = 'L+R'; % 'R', 'L+R'

handles.Setup.Stimulus.BufferLen             = 1;  % samples
handles.Setup.Stimulus.MaskerLevel           = -inf;     % dB SPL
handles.Setup.Stimulus.MaskerDuration        = 0; % seconds
handles.Setup.Stimulus.StimOnsetDelay        = 0; % seconds
handles.Setup.Stimulus.MaskerLevelOffsets    = 0;  % dB re masker level ("MaskerLevel")
handles.Setup.Stimulus.MaskerRampDur         = 0;        % seconds
handles.Setup.Stimulus.MaskerFrozen          = true;        %

%%
handles.Setup.Recording.ExtraSmp    = 4800;
handles.Setup.Recording.PreZeros    = 480;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;


handles.Setup.Hardware.PlayDev    = get_playrec_device_id('Hammerfall','ALSA'); % ASIO was 42 until 2015/07/21, new RME driver
handles.Setup.Hardware.RecDev     = get_playrec_device_id('Hammerfall','ALSA'); % ASIO was 42 until 2015/07/21, new RME driver
handles.Setup.Hardware.PlayCh     = 6;
handles.Setup.Hardware.RecCh      = 6;


handles.Setup.Recording.EEGCh       = 1;
handles.Setup.Recording.MicCh       = [4 5];
handles.Setup.Recording.TrgCh       = 3;
handles.Setup.Recording.SaveCh      = [7 8];

handles.Setup.Hardware.LaserPort = '/dev/ttyACM0';  % serial/USB port of laser control Arduino
handles.Setup.Hardware.LaserDuration = 0.5; % seconds, Laser active period duration
handles.Setup.Hardware.LaserCh = 6;
handles.Setup.Hardware.LaserPrePeriod = 0.2; % seconds; baseline duration before laser is switched on
handles.Setup.Hardware.LaserWaitPeriod = 0.1; % seconds; wait for laser effect onset
handles.Setup.Hardware.LaserOffPeriod = 0.8; % seconds; wait for laser effect offset

% states:
% 0: laser off, stimulus off, initialize
% 1: laser off, stimulus off, baseline 
% 2: laser on, stimulus off, waiting for laser feedback
% 3: laser on, stimulus off, onset waiting
% 4: laser on, stimulus on, stimulating
% 5: laser off, stimulus on, stimulation control condition
% 6: laser off, stimulus off, waiting for laser feedback
% 7: laser off, stimulus off, offset waiting

