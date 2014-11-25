handles.Setup.Stimulus.Duration       = 0.001;
handles.Setup.Stimulus.Type           = 'tone'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Frequency      = 1000;
handles.Setup.Stimulus.RampDur        = 0.0005;
handles.Setup.Stimulus.Window         = 'hann'; % 'none' or 'hann'
handles.Setup.Stimulus.Level          = 80; % dB SPL after calibration

handles.Setup.Stimulus.ITD            = [-1000 -500 -250 -125 -62.5 0 62.5 125 250 500 1000] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = 0; % dB
handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Recording.FileName    = 'OwlABR_1_1KHz';

handles.Setup.Recording.ExtraSmp    = 4800;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.035;

handles.Setup.Recording.ArtefactThr = 20; % µV

handles.Setup.Recording.MaxRepsPerCond = 1000;
