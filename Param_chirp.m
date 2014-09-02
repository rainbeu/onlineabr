handles.Setup.Stimulus.Type           = 'wave'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Fs             = 48000;
handles.Setup.Stimulus.FileName       = 'chirp20kHz_48kHz.wav'; 
handles.Setup.Stimulus.FileTimeOffset = 203/48000;
handles.Setup.Stimulus.SampleFormat   = 'int16';
handles.Setup.Stimulus.FileCh         = 1;
handles.Setup.Stimulus.bDoResample    = false;
handles.Setup.Stimulus.Level          = 40; % dB SPL after calibration

handles.Setup.Stimulus.ITD            = 0 * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = 0; % dB

handles.Setup.Recording.FileName    = 'data/datafile';

handles.Setup.Recording.ExtraSmp    = 480;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.ArtefactThr = 10; % µV

handles.Setup.Recording.MaxRepsPerCond = 10000;
