handles.Setup.Stimulus.ITD = [-600 -300-120 -100 -80 -40 0 40 80 100 120 300 600] * 1e-6;  % (micro-)seconds

handles.Setup.Stimulus.Level = 60; % dB SPL after calibration

handles.Setup.Recording.MaxRepsPerCond = 20;

handles.Setup.Recording.ArtefactThr = 10;  % µV
handles.Setup.Recording.RejectArtefacts = true;

%%

handles.Setup.Stimulus.ILD = [0]; % dB, if LevelThreshold = true (cf. below), use as level steps
handles.Setup.Stimulus.Type = 'narrowband noise';
handles.Setup.Stimulus.CenterFreq = 1250;
handles.Setup.Stimulus.Bandwidth = 200; % for transposedtone
handles.Setup.Stimulus.Duration = 0.125;  % seconds
handles.Setup.Stimulus.Window = 'hann';
handles.Setup.Stimulus.RampDur = 0.025;  % seconds
handles.Setup.Stimulus.Frozen = false;

%%

handles.Setup.Stimulus.LevelThreshold = false;
handles.Setup.Stimulus.PresentationType = 'L/R/B';

handles.Setup.Recording.ExtraSmp = 4800;
handles.Setup.Recording.PreTime = 0.050;  % seconds
handles.Setup.Recording.RecTime = 0.250;  % seconds

handles.Setup.Stimulus.UseSignSwapping = true;

%handles.Setup.Recording.FileName    = ['data/Baseo____',handles.Setup.Stimulus.Type,'_',num2str(handles.Setup.Stimulus.CarrierFrequeny/1e3),'k',num2str(handles.Setup.Stimulus.Frequency)];

