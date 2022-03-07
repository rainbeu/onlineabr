handles.Setup.Stimulus.StimulusLevelOffsets  = [80,90]; % dB re stimulus level ("Level")
handles.Setup.Stimulus.StimulusSide =  'R';

handles.Setup.Recording.MaxRepsPerCond = 500;
handles.Setup.Recording.ArtefactThr = 20; % µV
handles.Setup.Recording.RejectArtefacts = true;

%%

handles.Setup.Stimulus.Level          = 0; % dB SPL after calibration

handles.Setup.Stimulus.Type           = 'click';
handles.Setup.Stimulus.Duration       = 0.010;
handles.Setup.Stimulus.Window         = 'none';
handles.Setup.Stimulus.RampDur        = 0.000;

handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = [0]; % dB

%%

handles.Setup.Stimulus.LevelThreshold = false;
handles.Setup.Stimulus.UseSignSwapping = true;
handles.Setup.Stimulus.PresentationType = 'simple binaural';

handles.Setup.Recording.ExtraSmp    = 4800;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.FileName    = ['data/sonny/datafile_',handles.Setup.Stimulus.Type,...
    '_',handles.Setup.Stimulus.StimulusSide,...
    '_',num2str(min(handles.Setup.Stimulus.StimulusLevelOffsets)),...
    '-',num2str(max(handles.Setup.Stimulus.StimulusLevelOffsets)),'dB'];



% unused / only internally used
%% just fill in reasonable "null" values
handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = [0]; % dB

handles.Setup.Stimulus.MaskerSide   =  'L+R'; % 'L', 'R', 'L+R'
handles.Setup.Stimulus.BufferLen             = 0;  % samples
handles.Setup.Stimulus.IAC                   = 0;  % interaural correlation of masker
handles.Setup.Stimulus.CenterFreq            = 0;  % Hz
handles.Setup.Stimulus.BandWidth             = 0;  % Hz
handles.Setup.Stimulus.MaskerLevel           = 0;  % dB SPL
handles.Setup.Stimulus.MaskerDuration        = 0;  % seconds
handles.Setup.Stimulus.StimOnsetDelay        = 0;  % seconds
handles.Setup.Stimulus.MaskerLevelOffsets    = [0]; % dB re masker level ("MaskerLevel")
handles.Setup.Stimulus.MaskerRampDur         = 0;  % seconds
handles.Setup.Stimulus.MaskerFrozen          = true; %

% %% debug values
% handles.Setup.Hardware.PlayDev    = 7;
% handles.Setup.Hardware.RecDev     = 7;
% handles.Setup.Hardware.PlayCh     = 18;
% handles.Setup.Hardware.RecCh      = 18;
% handles.Setup.Recording.EEGCh     = 5;
% handles.Setup.Recording.MicCh     = [1 2];
