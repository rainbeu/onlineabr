handles.Setup.Stimulus.ITD = [-1000 -500 -250 0 250 500 1000] * 1e-6;  % (micro-)seconds

handles.Setup.Stimulus.Level = 90; % dB SPL after calibration

handles.Setup.Recording.MaxRepsPerCond = 500;

handles.Setup.Recording.ArtefactThr = 20;  % µV
handles.Setup.Recording.RejectArtefacts = true;

%%

handles.Setup.Stimulus.ILD = [0]; % dB, if LevelThreshold = true (cf. below), use as level steps
handles.Setup.Stimulus.Type = 'click';
handles.Setup.Stimulus.Duration = 0.010;  % seconds
handles.Setup.Stimulus.Window = 'none';
handles.Setup.Stimulus.RampDur = 0.000;  % seconds

%%

handles.Setup.Stimulus.LevelThreshold = false;
handles.Setup.Stimulus.PresentationType = 'L/R/B';

handles.Setup.Recording.ExtraSmp = 4800;
handles.Setup.Recording.PreTime = 0.004;  % seconds
handles.Setup.Recording.RecTime = 0.015;  % seconds

handles.Setup.Stimulus.UseSignSwapping = true;

