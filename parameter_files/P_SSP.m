handles.Setup.Stimulus.Duration       = 0.2;
handles.Setup.Stimulus.Type           = 'rw-ssp'; 
handles.Setup.Stimulus.Frequency      = 1000;
handles.Setup.Stimulus.RampDur        = 0.001; 
handles.Setup.Stimulus.Window         = 'none';

handles.Setup.Stimulus.Level          = 0; % dB SPL after calibration
handles.Setup.Stimulus.StimulusLevelOffsets  = [20 40 60 70 80];  % level steps relative to Stimulus.Level

andles.Setup.Stimulus.UseSignSwapping = false;
handles.Setup.Stimulus.Frozen = false;

handles.Setup.Stimulus.PresentationType      = 'simple binaural';

%% configuration for Setup.Stimulus.PresentationType == 'simple binaural'
handles.Setup.Stimulus.StimulusSide =  'L'; %  'L'  'R'  'L+R'

handles.Setup.Recording.ExtraSmp    = 2400;
handles.Setup.Recording.PreTime     = 0.010;
handles.Setup.Recording.RecTime     = 4 * handles.Setup.Stimulus.Duration;

handles.Setup.Recording.MaxRepsPerCond = 50;

handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps
handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = [0]; % dB
handles.Setup.Stimulus.MaskerLevelOffsets    = 0;  
