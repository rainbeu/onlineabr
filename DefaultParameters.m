handles.Setup.Fs                  = 48000;
handles.Setup.DisplayTime         = 1;  % display is updated every ... seconds 

handles.Setup.Hardware.PlayDev    = 40; % ASIO
handles.Setup.Hardware.RecDev     = 40; % ASIO
handles.Setup.Hardware.PlayCh     = 6;
handles.Setup.Hardware.RecCh      = 6;
handles.Setup.Hardware.BufferSize = 0;
handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_owl_better_2014-05-28.mat';
handles.Setup.Hardware.LevelCorrection = [-0 0];
handles.Setup.Hardware.StimCh     = [1 2];
handles.Setup.Hardware.TrgCh      = 3;

handles.Setup.Stimulus.Duration       = 0.020;
handles.Setup.Stimulus.Type           = 'click'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Frequency      = 2000;
handles.Setup.Stimulus.ModulationDepth = 1;
handles.Setup.Stimulus.Fs             = handles.Setup.Fs;
handles.Setup.Stimulus.FileName       = 'chirp20kHz_48kHz.wav'; 
handles.Setup.Stimulus.FileTimeOffset = 203/48000;
handles.Setup.Stimulus.SampleFormat   = 'int16';
handles.Setup.Stimulus.FileCh         = 1;
handles.Setup.Stimulus.bDoResample    = false;
handles.Setup.Stimulus.RampDur        = 0.005;
handles.Setup.Stimulus.Window         = 'none'; % 'hann'
handles.Setup.Stimulus.Level          = 70; % dB SPL after calibration

% handles.Setup.Stimulus.ITD            = [-2000 -1000 0 1000 2000] * 1e-6;  % sec.
%handles.Setup.Stimulus.ILD            = [-30 -20 -10 0 10 20 30]; % dB
%handles.Setup.Stimulus.ITD            = [-2000 -1000 -750 -500 -250 0 250 500 750 1000 2000] * 1e-6;  % sec.
handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = [0]; % dB

handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Stimulus.UseSignSwapping = true;

handles.Setup.Recording.FileName    = 'data/datafile';
handles.Setup.Recording.EEGCh       = 1;
handles.Setup.Recording.MicCh       = [4 5];
handles.Setup.Recording.TrgCh       = 3;

handles.Setup.Recording.ExtraSmp    = 960;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.ArtefactThr = 25; % µV

handles.Setup.Recording.MaxRepsPerCond = 5000;

