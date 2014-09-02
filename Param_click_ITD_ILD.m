handles.Setup.Stimulus.Duration     = 0.010;
handles.Setup.Stimulus.Type         = 'click'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Level        = 80; % dB SPL after calibration

handles.Setup.Stimulus.ITD          = [-500 0 900] * 1e-6; % sec
handles.Setup.Stimulus.ILD          = [-10 0 6]; % dB

handles.Setup.Recording.FileName    = 'data/datafile';

handles.Setup.Recording.ExtraSmp    = 480;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.ArtefactThr = 20; % µV

handles.Setup.Recording.MaxRepsPerCond = 10000;
