handles.Setup.Fs                  = 48000;
handles.Setup.DisplayTime         = 1;  % display is updated every ... seconds 

handles.Setup.Hardware.PlayDev    = 0; % notebook: 2
handles.Setup.Hardware.RecDev     = 0; % notebook: 2
handles.Setup.Hardware.PlayCh     = 6;
handles.Setup.Hardware.RecCh      = 6;
handles.Setup.Hardware.BufferSize = 0;
%handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_ABR_gerbil_2_2014-05-02.mat';
%handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_ABR_gerbil_2_2014-06-30_DONOTUSEFORABR.mat';
%handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_ABR_gerbil_2_2014-05-21.mat';
%handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_ABR_gerbil_2_2014-06-30_NOFILTERHIGH.mat';
%handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_ABR_gerbil_2014-06-12.mat';
handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_ABR_mouse_2014-08-26.mat';
handles.Setup.Hardware.LevelCorrection = [-0 0];
handles.Setup.Hardware.StimCh     = [1 2];
handles.Setup.Hardware.TrgCh      = 3;

handles.Setup.Stimulus.Duration       = 0.010;
handles.Setup.Stimulus.Type           = 'tone'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Frequency      = 16000;
handles.Setup.Stimulus.ModulationDepth = 1;
handles.Setup.Stimulus.Fs             = 96000;
handles.Setup.Stimulus.FileName       = 'chirp20kHz_48kHz.wav'; 
handles.Setup.Stimulus.FileTimeOffset = 203/48000;
handles.Setup.Stimulus.SampleFormat   = 'int16';
handles.Setup.Stimulus.FileCh         = 1;
handles.Setup.Stimulus.bDoResample    = false;
handles.Setup.Stimulus.RampDur        = 0.005;
handles.Setup.Stimulus.Window         = 'none'; % 'hann'
handles.Setup.Stimulus.Level          = 0; % dB SPL after calibration

% handles.Setup.Stimulus.ITD            = [-2000 -1000 0 1000 2000] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = [75:5:95]; % dB
% handles.Setup.Stimulus.ILD            = [-30 -20 -10 0 10 20 30]; % dB
%handles.Setup.Stimulus.ITD            = [-1000 -750 -500 -250 -125 0 125 250 500 750 1000] * 1e-6;  % sec.
%handles.Setup.Stimulus.ITD            = [-2000 -1000 -750 -500 -250 -125 -62.5 0 62.5 125 250 500 750 1000 2000] * 1e-6;  % sec.
handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
%handles.Setup.Stimulus.ILD            = [0]; % dB
%handles.Setup.Stimulus.ILD            = [50:10:80]; % dB
%handles.Setup.Stimulus.ILD            = [-10 0 10]; % dB

handles.Setup.Stimulus.LevelThreshold = true; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Stimulus.UseSignSwapping = true;

handles.Setup.Recording.FileName    = 'data/h0019';
handles.Setup.Recording.EEGCh       = 1;
handles.Setup.Recording.MicCh       = [4 5];
handles.Setup.Recording.TrgCh       = 3;

handles.Setup.Recording.ExtraSmp    = 960;
handles.Setup.Recording.PreTime     = 0.004;
handles.Setup.Recording.RecTime     = 0.015;

handles.Setup.Recording.ArtefactThr = 25; % µV

handles.Setup.Recording.MaxRepsPerCond = 400;

