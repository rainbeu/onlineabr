handles.Setup.Stimulus.Duration       = 0.200;
handles.Setup.Stimulus.Type           = 'modulated noise'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Frequency      = 100;
handles.Setup.Stimulus.ModulationDepth = 1;
handles.Setup.Stimulus.RampDur        = 0.0000;
handles.Setup.Stimulus.Window         = 'none'; % 'none' or 'hann'
handles.Setup.Stimulus.Level          = 60; % dB SPL after calibration

handles.Setup.Stimulus.ITD            = 0 * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = 0; % dB
handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Recording.FileName    = 'data/datafile';

handles.Setup.Recording.ExtraSmp    = 5280;
handles.Setup.Recording.PreTime     = 0.010;
handles.Setup.Recording.RecTime     = 0.290;

handles.Setup.Recording.ArtefactThr = 20; % µV

handles.Setup.Recording.MaxRepsPerCond = 1000;
