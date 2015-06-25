handles.Setup.Fs                  = 48000;
handles.Setup.DisplayTime         = 1;  % display is updated every ... seconds 

handles.Setup.Hardware.DryRun     = false;

handles.Setup.Hardware.PlayDev    = 40; % ASIO
handles.Setup.Hardware.RecDev     = 40; % ASIO
handles.Setup.Hardware.PlayCh     = 6;
handles.Setup.Hardware.RecCh      = 6;
handles.Setup.Hardware.BufferSize = 0;
handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_owl_better_2014-05-28.mat';
handles.Setup.Hardware.CalFile    = 'EqFiltCoeff_fake_0000-00-00.mat';
handles.Setup.Hardware.LevelCorrection = [-0 0];
handles.Setup.Hardware.StimCh     = [1 2];
handles.Setup.Hardware.TrgCh      = 3;

handles.Setup.Stimulus.Duration       = 0.100;
handles.Setup.Stimulus.Type           = 'CAP'; % 'click'; % 'tone', 'wave', 'click'
handles.Setup.Stimulus.Frequency      = 1000;
handles.Setup.Stimulus.ModulationDepth = 0;
handles.Setup.Stimulus.Fs             = handles.Setup.Fs;
handles.Setup.Stimulus.FileName       = 'chirp20kHz_48kHz.wav'; 
handles.Setup.Stimulus.FileTimeOffset = 203/48000;
handles.Setup.Stimulus.SampleFormat   = 'int16';
handles.Setup.Stimulus.FileCh         = 1;
handles.Setup.Stimulus.bDoResample    = false;
handles.Setup.Stimulus.RampDur        = 0.001;
handles.Setup.Stimulus.Window         = 'hann'; % 'none'
handles.Setup.Stimulus.Level          = 50; % dB SPL after calibration

handles.Setup.Stimulus.ITD            = [0] * 1e-6;  % sec.
handles.Setup.Stimulus.ILD            = [0]; % dB

handles.Setup.Stimulus.LevelThreshold = false; % for monaural level threshold: 
                                               % set this to true, set
                                               % level to 0, set ILD list
                                               % to desired level steps

handles.Setup.Stimulus.UseSignSwapping = false;

% handles.Setup.Stimulus.PresentationType      = 'L/R/B';
handles.Setup.Stimulus.PresentationType      = 'simple binaural';

handles.Setup.Stimulus.StimulusSide = 'L'; % 'R', 'L+R'
handles.Setup.Stimulus.MaskerSide = 'L'; % 'R', 'L+R'

handles.Setup.Stimulus.BufferLen             = 2^16;  % samples
handles.Setup.Stimulus.IAC                   = 1;      % interaural correlation of masker
handles.Setup.Stimulus.CenterFreq            = 4025;  % Hz
handles.Setup.Stimulus.BandWidth             = 7950;  % Hz
handles.Setup.Stimulus.MaskerLevel           = 70;     % dB SPL
handles.Setup.Stimulus.MaskerDuration        = 0.100; % seconds
handles.Setup.Stimulus.StimOnsetDelay        = 0.101; % seconds
handles.Setup.Stimulus.MaskerLevelOffsets    = [0 -10 +10];  % dB re masker level ("MaskerLevel")
handles.Setup.Stimulus.StimulusLevelOffsets  = [0 5];       % dB re stimulus level ("Level")
handles.Setup.Stimulus.MaskerRampDur         = 0.001;        % seconds
handles.Setup.Stimulus.MaskerFrozen          = false;        %



handles.Setup.Recording.FileName    = 'data/datafile';
handles.Setup.Recording.EEGCh       = 1;
handles.Setup.Recording.MicCh       = [4 5];
handles.Setup.Recording.TrgCh       = 3;

handles.Setup.Recording.ExtraSmp    = 3000;
handles.Setup.Recording.PreTime     = 0.101;
handles.Setup.Recording.RecTime     = 0.150;

handles.Setup.Recording.ArtefactThr = 25000; % µV

handles.Setup.Recording.MaxRepsPerCond = 5000;

