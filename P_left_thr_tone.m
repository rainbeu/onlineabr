handles.Setup.Stimulus.StimulusLevelOffsets  = [20 30 40 50 60 70 80 90]; % dB re stimulus level ("Level")
handles.Setup.Stimulus.StimulusSide =  'L';

handles.Setup.Recording.MaxRepsPerCond = 500;
handles.Setup.Recording.ArtefactThr = 20; % µV
handles.Setup.Recording.RejectArtefacts = true;

%%

handles.Setup.Stimulus.Level          = 0; % dB SPL after calibration

handles.Setup.Stimulus.Type           = 'tone';
handles.Setup.Stimulus.Frequency      = 1250;
handles.Setup.Stimulus.Duration       = 0.008;
handles.Setup.Stimulus.Window         = 'hann';
handles.Setup.Stimulus.RampDur        = 0.004;

handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = [0]; % dB

%%

handles.Setup.Stimulus.LevelThreshold = false;
handles.Setup.Stimulus.UseSignSwapping = true;
handles.Setup.Stimulus.PresentationType = 'simple binaural';

handles.Setup.Recording.ExtraSmp    = 4800;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;


