handles.Setup.Stimulus.ITD = [-120 -80 -40 0 40 80 120] * 1e-6;  % (micro-)seconds

handles.Setup.Stimulus.Level = 80; % dB SPL after calibration

handles.Setup.Recording.MaxRepsPerCond = 500;

handles.Setup.Recording.ArtefactThr = 200;  % µV
handles.Setup.Recording.RejectArtefacts = true;

%%

handles.Setup.Stimulus.ILD = [0]; % dB, if LevelThreshold = true (cf. below), use as level steps
handles.Setup.Stimulus.Type = 'tone';
handles.Setup.Stimulus.Frequency      = 900;%1250;
handles.Setup.Stimulus.Duration = 0.125;  % seconds
handles.Setup.Stimulus.Window = 'onoffset';
handles.Setup.Stimulus.RampDur = 0.025;  % seconds

%%

handles.Setup.Stimulus.LevelThreshold = false;
handles.Setup.Stimulus.PresentationType = 'L/R/B';

handles.Setup.Recording.ExtraSmp = 4800;
handles.Setup.Recording.PreTime = 0.050;  % seconds
handles.Setup.Recording.RecTime = 0.250;  % seconds

handles.Setup.Stimulus.UseSignSwapping = true;

