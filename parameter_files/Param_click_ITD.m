handles.Setup.Stimulus.Duration     = 0.020;
handles.Setup.Stimulus.Type         = 'click'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Level        = 90; % dB SPL after calibration

%handles.Setup.Stimulus.ITD          = [-2000 -1000 -500 -250 -100 0 100 250 500 1000 2000] * 1e-6; % sec
handles.Setup.Stimulus.ITD          = [0 200 500] * 1e-6; % sec
handles.Setup.Stimulus.ILD          = 0; % dB

handles.Setup.Recording.FileName    = 'data/datafile';

handles.Setup.Recording.ExtraSmp    = 480;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.ArtefactThr = 20e6; % µV

handles.Setup.Recording.MaxRepsPerCond = 10000;
