handles.Setup.Stimulus.Type           = 'wave'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Fs             = 48000;
handles.Setup.Stimulus.FileName       = 'owl_chirp_Köppl_pub_noffset.wav'; 
handles.Setup.Stimulus.FileTimeOffset = 600/48000;
handles.Setup.Stimulus.SampleFormat   = 'int16';
handles.Setup.Stimulus.FileCh         = 1;
handles.Setup.Stimulus.bDoResample    = false;
handles.Setup.Stimulus.Level          = 0; % dB SPL after calibration

handles.Setup.Stimulus.ITD          = 0;  % sec.
handles.Setup.Stimulus.ILD          = 0:10:80; % dB
handles.Setup.Stimulus.LevelThreshold = true; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Recording.FileName    = 'OwlBDP_1_Chirp';

handles.Setup.Recording.ExtraSmp    = 1300;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.ArtefactThr = 400; % ÂµV

handles.Setup.Recording.MaxRepsPerCond = 5000;
