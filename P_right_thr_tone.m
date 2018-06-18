handles.Setup.Stimulus.StimulusLevelOffsets  = [40,50,60,70:10:90]; % dB re stimulus level ("Level")
handles.Setup.Stimulus.StimulusSide =  'R';

handles.Setup.Recording.MaxRepsPerCond = 500;
handles.Setup.Recording.ArtefactThr = 20; % µV
handles.Setup.Recording.RejectArtefacts = true;

%%

handles.Setup.Stimulus.Level          = 0; % dB SPL after calibration

handles.Setup.Stimulus.Type           = 'tone';
handles.Setup.Stimulus.Frequency      = 1000;
handles.Setup.Stimulus.Duration       = 0.002;
handles.Setup.Stimulus.Window         = 'hann';
handles.Setup.Stimulus.RampDur        = 0.001;

handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = [0]; % dB

%%

handles.Setup.Stimulus.LevelThreshold = false;
handles.Setup.Stimulus.UseSignSwapping = true;
handles.Setup.Stimulus.PresentationType = 'simple binaural';

handles.Setup.Recording.ExtraSmp    = 4800;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;


handles.Setup.Recording.FileName    = ['data/Carfax_datafile_',handles.Setup.Stimulus.Type,...
    '_',num2str(handles.Setup.Stimulus.Frequency),'Hz',...
    '_',handles.Setup.Stimulus.StimulusSide,...
    '_',num2str(min(handles.Setup.Stimulus.StimulusLevelOffsets)),...
    '-',num2str(max(handles.Setup.Stimulus.StimulusLevelOffsets)),'dB'];