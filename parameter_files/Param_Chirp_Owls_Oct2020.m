
handles.Setup.Stimulus.Level                 = 0;      % dB SPL after calibration ###use with one level for BIC with L/R/B Presentation Type, for simp. bin. set to 0###
handles.Setup.Stimulus.StimulusLevelOffsets  = [19];   % dB re stimulus level ("Level") ###use with level range for thresholds and simple binarual, for BIC set to 0###

handles.Setup.Stimulus.Duration     = 0.01;
handles.Setup.Stimulus.Type         = 'wave'; 
handles.Setup.Stimulus.FileName       = 'owl_chirp_Köppl_pub_noffset.wav';  % ###change file name to used chirp data###
handles.Setup.Stimulus.RampDur      = 0;
handles.Setup.Stimulus.Window       = 'none';

%###0 and adjust RecTime to 25ms or 607/48000 with 15ms RecTime for owl_chirp_Köppl_pub_noffset file
%###it was 203/48000 for gerbil chirp###
handles.Setup.Stimulus.FileTimeOffset = 607/48000; 
handles.Setup.Stimulus.SampleFormat   = 'int16';

%%
handles.Setup.Recording.ArtefactThr          = 100;      % µV ###can be set in OnlineABR###
handles.Setup.Recording.RejectArtefacts = false; % true: reject artefacts above threshold, false: do not reject artefacts at all

handles.Setup.Recording.MaxRepsPerCond       = 50; % ###repetitions###

%%
handles.Setup.Stimulus.ITD          = 0;  % sec.
handles.Setup.Stimulus.ILD          = 0; % dB

handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Stimulus.UseSignSwapping = true;

handles.Setup.Stimulus.PresentationType      = 'simple binaural';   % ###simple binaural for thresholds, L/R/B for BIC###
handles.Setup.Stimulus.StimulusSide = 'L+R'; % 'L', 'L+R'
handles.Setup.Stimulus.MaskerSide = 'L+R'; % 'L', 'L+R'

handles.Setup.Stimulus.BufferLen             = 1;  % samples
handles.Setup.Stimulus.MaskerLevel           = -inf;     % dB SPL
handles.Setup.Stimulus.MaskerDuration        = 0; % seconds
handles.Setup.Stimulus.StimOnsetDelay        = 0; % seconds
handles.Setup.Stimulus.MaskerLevelOffsets    = 0;  % dB re masker level ("MaskerLevel")
handles.Setup.Stimulus.MaskerRampDur         = 0;        % seconds
handles.Setup.Stimulus.MaskerFrozen          = true;        %

handles.Setup.Recording.ExtraSmp    = 4800;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

