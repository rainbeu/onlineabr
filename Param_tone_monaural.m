
handles.Setup.Stimulus.Level                 = 0;      % dB SPL after calibration
handles.Setup.Stimulus.StimulusLevelOffsets  = [10:10:100];   % dB re stimulus level ("Level")
handles.Setup.Stimulus.Frequency    = 4000;

handles.Setup.Stimulus.Duration     = 0.010;
handles.Setup.Stimulus.Type         ='tone';
handles.Setup.Stimulus.RampDur      = 0.001;
handles.Setup.Stimulus.Window       = 'hann';

%%
handles.Setup.Recording.ArtefactThr          = 20;      % µV
handles.Setup.Recording.RejectArtefacts = false; % true: reject artefacts above threshold, false: do not reject artefacts at all

handles.Setup.Recording.MaxRepsPerCond       = 32;


%%
handles.Setup.Stimulus.ITD          = 0;  % sec.
handles.Setup.Stimulus.ILD          = 0; % dB

handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Stimulus.UseSignSwapping = true;

handles.Setup.Stimulus.PresentationType      = 'simple binaural';
handles.Setup.Stimulus.StimulusSide = 'L'; % 'R', 'L+R'
handles.Setup.Stimulus.MaskerSide = 'L'; % 'R', 'L+R'

handles.Setup.Stimulus.BufferLen             = 1;  % samples
handles.Setup.Stimulus.MaskerLevel           = -inf;     % dB SPL
handles.Setup.Stimulus.MaskerDuration        = 0; % seconds
handles.Setup.Stimulus.StimOnsetDelay        = 0; % seconds
handles.Setup.Stimulus.MaskerLevelOffsets    = 0;  % dB re masker level ("MaskerLevel")
handles.Setup.Stimulus.MaskerRampDur         = 0;        % seconds
handles.Setup.Stimulus.MaskerFrozen          = true;        %

handles.Setup.Recording.ExtraSmp    = 4800;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

