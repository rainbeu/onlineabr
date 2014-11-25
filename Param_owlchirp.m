handles.Setup.Stimulus.Type           = 'wave'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Fs             = 48000;
handles.Setup.Stimulus.FileName       = 'owl_chirp_Köppl_pub_noffset.wav'; 
handles.Setup.Stimulus.FileTimeOffset = 600/48000;
handles.Setup.Stimulus.SampleFormat   = 'int16';
handles.Setup.Stimulus.FileCh         = 1;
handles.Setup.Stimulus.bDoResample    = false;
handles.Setup.Stimulus.Level          = 50; % dB SPL after calibration

handles.Setup.Stimulus.ITD            = [-1000 -500 -250 -125 -62.5 0 62.5 125 250 500 1000] * 1e-6;  % sec.
% handles.Setup.Stimulus.ITD            = 0 * 1e-6;  % sec.
%handles.Setup.Stimulus.ITD            = [-500 0 500] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = 0; % dB

handles.Setup.Recording.FileName    = 'OwlBDP_1_Chirp';

handles.Setup.Recording.ExtraSmp    = 1300;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.ArtefactThr = 400; % ÂµV

handles.Setup.Recording.MaxRepsPerCond = 400;
