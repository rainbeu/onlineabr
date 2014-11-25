
handles.Setup.Stimulus.Duration     = 0.020;
handles.Setup.Stimulus.Type         = 'click'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Frequency    = 1000;
handles.Setup.Stimulus.RampDur      = 0.005;
handles.Setup.Stimulus.Window       = 'none'; % 'hann'
handles.Setup.Stimulus.Level        = 0; % dB SPL after calibration

handles.Setup.Stimulus.ITD          = 0;  % sec.
handles.Setup.Stimulus.ILD          = 0:10:90; % dB
handles.Setup.Stimulus.LevelThreshold = true; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Recording.FileName    = 'data/datafile';

handles.Setup.Recording.ExtraSmp    = 1300;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.ArtefactThr = 400; % µV

handles.Setup.Recording.MaxRepsPerCond = 2000;
