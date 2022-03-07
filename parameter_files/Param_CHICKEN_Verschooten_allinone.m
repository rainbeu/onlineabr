
handles.Setup.Stimulus.Level                 = 0;      % dB SPL after calibration
handles.Setup.Stimulus.StimulusLevelOffsets  = [-inf 55];   % dB re stimulus level ("Level")
handles.Setup.Stimulus.Frequency    = 1000;

handles.Setup.Stimulus.Duration     = 0.1;
handles.Setup.Stimulus.Type         ='CAP';
handles.Setup.Stimulus.RampDur      = 0.001;
handles.Setup.Stimulus.Window       = 'hann';
% handles.Setup.Stimulus.Window       = 'none';

%%
handles.Setup.Recording.ArtefactThr          = 200;      % default 20 µV
handles.Setup.Recording.RejectArtefacts = true; % true: reject artefacts above threshold, false: do not reject artefacts at all

handles.Setup.Recording.MaxRepsPerCond       = 1000;


%%
handles.Setup.Stimulus.ITD          = 0;  % sec.
handles.Setup.Stimulus.ILD          = 0; % dB

handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Stimulus.UseSignSwapping = true;

handles.Setup.Stimulus.PresentationType      = 'simple binaural';
handles.Setup.Stimulus.StimulusSide = 'R'; % 'L', 'L+R'
handles.Setup.Stimulus.MaskerSide = 'R'; % 'L', 'L+R'

handles.Setup.Stimulus.BufferLen             = 4800;  % samples duration*sampling rate (multiply by any factor for unfrozen masker)
handles.Setup.Stimulus.MaskerLevel           = 0;     % dB SPL
handles.Setup.Stimulus.MaskerDuration        = 0.1; % seconds
handles.Setup.Stimulus.StimOnsetDelay        = 0.101; % seconds
handles.Setup.Stimulus.MaskerLevelOffsets    = [-inf 75];  % dB re masker level ("MaskerLevel")
handles.Setup.Stimulus.MaskerRampDur         = 0.001;        % seconds
handles.Setup.Stimulus.MaskerFrozen          = true;        %

handles.Setup.Recording.ExtraSmp    = 4800;
handles.Setup.Recording.PreTime     = 0.110;
handles.Setup.Recording.RecTime     = 0.25;

