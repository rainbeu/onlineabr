handles.Setup.Stimulus.ITD = [-500 -300 -100 0 100 300 500] * 1e-6;  % (micro-)seconds

handles.Setup.Stimulus.Level = 60; % dB SPL after calibration

handles.Setup.Recording.MaxRepsPerCond = 20;
handles.Setup.Recording.Randomization = 'fixed'; % use 'fixed' for a pre-randomized list of repetitions, default: 'running'

handles.Setup.Recording.ArtefactThr = 20;  % µV
handles.Setup.Recording.RejectArtefacts = false;%true;

%%

handles.Setup.Stimulus.ILD = [0]; % dB, if LevelThreshold = true (cf. below), use as level steps
handles.Setup.Stimulus.Type = 'transposedtone';
handles.Setup.Stimulus.Frequency        = 50; % modulation frequency [50 200 500 1000]
handles.Setup.Stimulus.LowPassFrequency = 1000; % for transposedtone (max 1/2 carrier freq, far above mod freq, glättet Modulator)
handles.Setup.Stimulus.CarrierFrequency = 4000; % for transposedtone
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

handles.Setup.Recording.FileName    = ['data/GEK0075_3_6__',handles.Setup.Stimulus.Type,'_',num2str(handles.Setup.Stimulus.CarrierFrequency),'_',num2str(handles.Setup.Stimulus.Frequency)];
handles.Setup.Recording.addDateTime2filename = 0;
