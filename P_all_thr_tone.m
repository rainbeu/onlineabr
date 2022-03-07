handles.Setup.Stimulus.Type           = 'tone';
handles.Setup.Stimulus.Frequency      = 1000;
handles.Setup.Stimulus.Duration       = 0.008; % .008 for 1k
handles.Setup.Stimulus.Window         = 'hann';
handles.Setup.Stimulus.RampDur        = 0.004; % .004 for 1k

handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD = [50 60 70 80 90];  % level relative to Stimulus.Level in dB
handles.Setup.Stimulus.Level = 0; % dB SPL after calibration (base value) (plus ILD values)

handles.Setup.Recording.MaxRepsPerCond = 500;

handles.Setup.Recording.ArtefactThr = 20;  % µV
handles.Setup.Recording.RejectArtefacts = true;

%%

handles.Setup.Stimulus.LevelThreshold = true; % !!!! important for level thresholds
handles.Setup.Stimulus.PresentationType = 'L/R/B';  % measure all ears and binaural at once

handles.Setup.Recording.ExtraSmp = 4800;
handles.Setup.Recording.PreTime = 0.004;  % seconds
handles.Setup.Recording.RecTime = 0.015;  % seconds

handles.Setup.Stimulus.UseSignSwapping = true;

