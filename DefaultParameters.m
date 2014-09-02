handles.Setup.Fs                  = 48000;
handles.Setup.DisplayTime         = 1;  % display is updated every ... seconds 

handles.Setup.Hardware.PlayDev    = 0; % notebook: 2
handles.Setup.Hardware.RecDev     = 0; % notebook: 2
handles.Setup.Hardware.PlayCh     = 8;
handles.Setup.Hardware.RecCh      = 8;
handles.Setup.Hardware.BufferSize = 0;
handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_dummy';
handles.Setup.Hardware.LevelCorrection = [-0 0];
handles.Setup.Hardware.StimCh     = [5 6];
handles.Setup.Hardware.TrgCh      = 7;

handles.Setup.Stimulus.Duration       = 0.010;
handles.Setup.Stimulus.Type           = 'click'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Frequency      = 24000;
handles.Setup.Stimulus.ModulationDepth = 1;
handles.Setup.Stimulus.Fs             = 96000;
handles.Setup.Stimulus.FileName       = 'chirp20kHz_48kHz.wav'; 
handles.Setup.Stimulus.FileTimeOffset = 203/48000;
handles.Setup.Stimulus.SampleFormat   = 'int16';
handles.Setup.Stimulus.FileCh         = 1;
handles.Setup.Stimulus.bDoResample    = false;
handles.Setup.Stimulus.RampDur        = 0.005;
handles.Setup.Stimulus.Window         = 'none'; % 'hann'
handles.Setup.Stimulus.Level          = 50; % dB SPL after calibration

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

handles.Setup.Recording.MaxRepsPerCond = 1000;

