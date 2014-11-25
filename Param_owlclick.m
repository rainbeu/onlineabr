handles.Setup.Stimulus.Duration     = 0.010;
handles.Setup.Stimulus.Type         = 'click'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Level        = 80; % dB SPL after calibration

handles.Setup.Stimulus.ITD          = [-1000 -500 -250 -125 -62.5 0 62.5 125 250 500 1000] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD          = 0; % dB

handles.Setup.Recording.FileName    = 'OwlBDP_1_Click';

handles.Setup.Recording.ExtraSmp    = 4800;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.ArtefactThr = 20; % µV

handles.Setup.Recording.MaxRepsPerCond = 2000;
