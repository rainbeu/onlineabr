handles.Setup.Stimulus.ITD = [-600 -300 -120 -100 -80 -40 0 40 80 100 120 300 600] * 1e-6;  % (micro-)seconds[-120 -80 -40 0 40 80 120] * 1e-6;  % (micro-)seconds

handles.Setup.Stimulus.Level = 60; % dB SPL after calibration

handles.Setup.Recording.MaxRepsPerCond = 20;%500;
handles.Setup.Recording.Randomization = 'fixed'; % use 'fixed' for a pre-randomized list of repetitions, default: 'running'

handles.Setup.Recording.ArtefactThr = 20;  % µV
handles.Setup.Recording.RejectArtefacts = false;%true;

%%

handles.Setup.Stimulus.ILD = [0]; % dB, if LevelThreshold = true (cf. below), use as level steps
handles.Setup.Stimulus.Type = 'tone';
handles.Setup.Stimulus.Frequency      = 1250;
handles.Setup.Stimulus.Duration = 0.125;  % seconds
handles.Setup.Stimulus.Window = 'hann';
handles.Setup.Stimulus.RampDur = 0.025;  % seconds

%%

handles.Setup.Stimulus.LevelThreshold = false;
handles.Setup.Stimulus.PresentationType = 'L/R/B';

handles.Setup.Recording.ExtraSmp = 4800;
handles.Setup.Recording.PreTime = 0.050;  % seconds
handles.Setup.Recording.RecTime = 0.250;  % seconds

handles.Setup.Stimulus.UseSignSwapping = true;

handles.Setup.Recording.FileName    = ['data/GEK0075_1_5__bw_1250_0'];
handles.Setup.Recording.addDateTime2filename = 0;
