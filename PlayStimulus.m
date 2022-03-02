function stS = PlayStimulus(stS,sDisplayCallback,sFinishedCallback)
    
    %% parameters
    fs = stS.Fs;
    Hw = stS.Hardware;
    St = stS.Stimulus;
    Rc = stS.Recording;
    
    stS.Msg = 'Start';
    bRunning = true;
    fid = -1;
    
    InputScalingFactor_uV = get_input_scaling_factor_uV(Hw);
    MicScaling_Pa = get_mic_scaling_Pa(Hw);
    
    [fb,fa] = butter(4,[300 3000]/fs*2);
    
    
    %% sound device initialization
    if ~Hw.DryRun
        if playrec('isInitialised')
            playrec('reset')
        end
        playrec('init',fs,Hw.PlayDev,Hw.RecDev,Hw.PlayCh,Hw.RecCh,Hw.BufferSize,Hw.LatencySamples/fs,Hw.LatencySamples/fs);
    else
        fprintf('dry run\n');
    end
    
    %% stimulus generation
    
    % N = round(St.Duration*fs);
    %
    % masker = [0 0];
    %
    % switch St.Type
    %     case 'tone'
    %         switch St.Window
    %             case { 'ongoing', 'onoffset' }
    %                 stimulus = sin(2*pi*St.Frequency*(0:2*N-1).'/fs);
    %             otherwise
    %                 stimulus = sin(2*pi*St.Frequency*(0:N-1).'/fs);
    %         end
    %         RMS = db(std(stimulus(1:N,:),1));
    %         TimeOffset = 0;
    %     case 'transposedtone'
    %         switch St.Window
    %             case { 'ongoing', 'onoffset' }
    %                 stimulus = sin(2*pi*St.Frequency*(0:2*N-1).'/fs);
    %             otherwise
    %                 stimulus = sin(2*pi*St.Frequency*(0:N-1).'/fs);
    %         end
    %         RMS = db(std(stimulus(1:N,:),1));
    %         TimeOffset = 0;
    %         % high-frequency carrier tone
    %         carrier = sin(2*pi*St.CarrierFrequency*(0:2*N-1).'/fs);
    %         % half wave rectification of modulator
    %         stimulus = 0.5 * (abs(stimulus) + stimulus);
    %         % low pass filtering of modulator
    %         f = (0:length(stimulus)-1).'/length(stimulus)*St.Fs; f(f>=St.Fs/2) = f(f>=St.Fs/2) - St.Fs;
    %         stimulus = real(ifft(bsxfun(@times, fft(stimulus), abs(f) <= St.LowPassFrequency)));
    %         % modulating modulator on carrier tone
    %         % is done after shifting for ITD
    %     case 'click'
    %         stimulus = [1;zeros(N-1,1)];
    %         RMS = -db(sqrt(2));
    %         TimeOffset = 0;
    %     case 'standardclick'
    %         StdDuration = 50e-6;
    %         stimulus = zp2tf(exp(-1i*[+1;-1]*(1/StdDuration)*2*pi/fs),[],1).';
    %         stimulus(end+1:N) = 0;
    %         stimulus = stimulus/max(abs(stimulus));
    %         RMS = -db(sqrt(2));
    %         TimeOffset = round(StdDuration*fs/2)/fs;
    %     case 'doubleclick'
    %         stimulus = [0.2;zeros(6,1);1;zeros(N-8,1)];
    %         RMS = 10*log10(0.2.^2+1^2);
    %         TimeOffset = 3/fs;
    %     case 'broadband noise'
    %         stimulus = randn(N,1);
    %         RMS = db(std(stimulus(1:N,:),1));
    %         TimeOffset = 0;
    %     case 'narrowband noise'
    %         stimulus = randn(N,1);
    %         f = (0:N-1).'/N*fs; f(f>=fs/2) = f(f>=fs/2) - fs;
    %         stimulus = real(ifft(fft(stimulus).*(abs(f)>(St.CenterFreq-St.Bandwidth/2)&abs(f)<=(St.CenterFreq+St.Bandwidth/2))));
    %         RMS = db(std(stimulus(1:N,:),1));
    %         TimeOffset = 0;
    %     case 'modulated noise'
    %         stimulus = 1-St.ModulationDepth*cos(2*pi*St.Frequency*(0:N-1).'/fs);
    %         RMS = db(std(stimulus(1:N,:).*randn(N,size(stimulus,2)),1));
    %         TimeOffset = 0;
    %     case {'wave','raw'}
    %         if strcmp(St.Type,'wave')
    %             [stimulus,St.Fs] = wavread(St.FileName);
    %         else
    %             fid = fopen(St.FileName,'r');
    %             stimulus = reshape(fread(fid,St.SampleFormat),St.FileCh,[]).';
    %             fclose(fid);
    %         end
    %         if St.Fs ~= fs
    %             if St.bDoResample
    %                 stimulus = resample(stimulus,fs,St.Fs);
    %             else
    %                 error('wave file and output sampling rates do not match');
    %             end
    %         end
    %         N = length(stimulus);
    %         RMS = db(std(stimulus(1:N,:),1));
    %         TimeOffset = St.FileTimeOffset;
    %
    %     case 'CAP'
    %         % St.BufferLen
    %         % St.IAC
    %         % St.CenterFreq
    %         % St.BandWidth
    %         % St.MaskerLevel
    %         % St.MaskerDuration
    %         % St.StimOnsetDelay
    %         % St.PresentationType
    %         % St.MaskerLevelOffsets
    %         % St.StimulusLevelOffsets
    %         % St.MaskerRampDur
    %         % St.StimulusSide
    %         % St.MaskerSide
    %
    %         masker = randn(St.BufferLen,1);
    %         if St.IAC < 1.0
    %             masker(:,2) = St.IAC * masker + sqrt(1-St.IAC.^2) * randn(St.BufferLen,1);
    %         else
    %             masker(:,2) = masker(:,1);
    %         end
    %         f = (0:St.BufferLen-1).'/St.BufferLen * fs;
    %         f(f>=fs/2) = f(f>=fs/2) - fs;
    %         masker = real(ifft(bsxfun(@times,fft(masker),abs(abs(f)-St.CenterFreq) < St.BandWidth)));
    %         masker = bsxfun(@rdivide,masker,std(masker));
    %
    %         mRMS = 0;
    %
    %         stimulus = sin(2*pi*St.Frequency*(0:N-1).'/fs);
    %         RMS = db(std(stimulus(1:N,:),1));
    %         TimeOffset = 0;
    %
    %
    %     otherwise
    %         error('unsupported stimulus type: %s',St.Type);
    % end
    %
    % %% stimulus windowing
    %
    % R = round(St.RampDur*fs)*2;
    % switch St.Window
    %     case 'none'
    %         W = [];
    %     case { 'hann', 'all' }
    %         W = hann(R);
    %     case { 'ongoing', 'onoffset' }
    %         W = [];
    %     otherwise
    %         error('unsupported window type: %s',St.Window);
    % end
    % stimulus = bsxfun(@times,stimulus,[W(1:end/2);ones(length(stimulus)-length(W),1);W(end/2+1:end)]);
    % switch St.Type
    %     case 'CAP'
    %         R = round(St.MaskerRampDur*fs)*2;
    %         switch St.Window
    %             case 'none'
    %                 W = [];
    %             case 'hann'
    %                 W = hann(R);
    %             otherwise
    %                 error('unsupported window type: %s',St.Window);
    %         end
    %         mWin = [W(1:end/2);ones(round(St.MaskerDuration*fs)-length(W),1);W(end/2+1:end)];
    %         MaskerSamples = length(mWin);
    %     otherwise
    %         MaskerSamples = length(stimulus);
    %         masker = zeros(MaskerSamples,2);
    %         mWin = zeros(MaskerSamples,1);
    % end
    %
    % %% stimulus time delay
    % switch St.Type
    %     case 'CAP'
    %         stimulus = [zeros(round(St.StimOnsetDelay*fs),size(stimulus,2));stimulus];
    %         TimeOffset = TimeOffset + St.StimOnsetDelay;
    % end
    %
    %
    % %% load calibration data
    % Cal = load(Hw.CalFile);
    % if Cal.nSamplingFrequency ~= fs
    %     error('calibration and output sampling rates do not match');
    % end
    % for ch = 1:length(Hw.StimCh)
    %     idx = find(Cal.mfOutInChannelList(:,1)+1 == Hw.StimCh(ch),1,'first');
    %     CalFilter(:,ch)  = Cal.mfFilterCoeffs(:,idx);
    %     MaxSPL(ch)       = Cal.vfMaxSPL(idx);
    %     gd               = grpdelay(Cal.mfFilterCoeffs(:,idx),1,size(Cal.mfFilterCoeffs(:,idx),1),fs);
    %     GroupDelay(ch,1) = mean(gd(2:end))/fs;
    % end
    %
    %
    %
    % %% stimulus level calibration
    % switch St.Type
    %     case { 'transposedtone' }
    %     otherwise
    %         stimulus = bsxfun(@times,stimulus,10.^((-MaxSPL(:)+St.Level(:)-RMS(:)+Hw.LevelCorrection(:))/20).');
    % end
    % switch St.Type
    %     case 'CAP'
    %         masker = bsxfun(@times,masker,10.^((-MaxSPL(:)+St.MaskerLevel(:)-mRMS(:)+Hw.LevelCorrection(:))/20).');
    % end
    %
    %
    % %% stimulus spectrum calibration
    % switch St.Type
    %     case 'modulated noise'
    %         stimulus = [stimulus;zeros(size(CalFilter,1),size(stimulus,2))];
    %     case 'CAP'
    %         stimulus = fftfilt(CalFilter,[stimulus;zeros(size(CalFilter,1),size(stimulus,2))]);
    %         TimeOffset = TimeOffset + max(mean(GroupDelay),0);
    %         masker = fftfilt(CalFilter,[masker;zeros(size(CalFilter,1),size(masker,2))]);
    %         masker = masker(max(round(mean(GroupDelay)*fs),0)+(1:St.BufferLen),:);
    %     case { 'transposedtone' }
    %         stimulus = repmat(stimulus, 1, 2);
    %     otherwise
    %         stimulus = fftfilt(CalFilter,[stimulus;zeros(size(CalFilter,1),size(stimulus,2))]);
    %         TimeOffset = TimeOffset + max(mean(GroupDelay),0);
    % %         TimeOffset = TimeOffset + size(CalFilter,1)/2/fs;
    % end
    %
    % %% stimulus ITD/ILD preparation
    % switch St.PresentationType
    %     case 'L/R/B'
    %         switch St.Window
    %             case { 'onoffset' }
    %                 W = hann(R);
    %                 base_stimulus = stimulus;
    %                 stimulus = repmat([W(1:end/2);ones(N-length(W),1);W(end/2+1:end)],1,2);
    %         end
    %         stimulus = [zeros(ceil(max(abs(St.ITD))*fs),size(stimulus,2));stimulus;zeros(ceil(max(abs(St.ITD))*fs),size(stimulus,2))];
    %         TimeOffset = TimeOffset + max(abs(St.ITD));
    %         f = (0:size(stimulus,1)-1).'/size(stimulus,1)*fs;
    %         f(f>=fs/2) = f(f>=fs/2) - fs;
    %         shiftstim = zeros(size(stimulus,1),2,length(St.ITD));
    %         for tx = 1:length(St.ITD)
    %             % positive ILD and ITD move to the right,
    %             % positive ITD => later left (1), earlier right (2)
    %             shiftstim(:,1,tx) = real(ifft(fft(stimulus(:,1)) .* exp(-1i*2*pi*f*(+St.ITD(tx)/2))));
    %             shiftstim(:,2,tx) = real(ifft(fft(stimulus(:,2)) .* exp(-1i*2*pi*f*(-St.ITD(tx)/2))));
    %         end
    %         switch St.Window
    %             case { 'onoffset' }
    %                 stimulus = bsxfun(@times, stimulus, base_stimulus(N/4+(1:size(stimulus,1)), :));
    %                 shiftstim = bsxfun(@times, shiftstim, base_stimulus(N/4+(1:size(stimulus,1)), :));
    %             case { 'ongoing' }
    %                 W = hann(R);
    %                 W = [zeros(ceil(max(abs(St.ITD))*fs),1);W(1:end/2);ones(N-length(W),1);W(end/2+1:end);zeros(ceil(max(abs(St.ITD))*fs),1)];
    %                 stimulus = bsxfun(@times, W, stimulus(N/4+(1:length(W)), :));
    %                 shiftstim = bsxfun(@times, W, shiftstim(N/4+(1:length(W)), :, :));
    %         end
    %     case 'simple binaural'
    %         St.ILD = St.MaskerLevelOffsets;
    %         St.ITD = St.StimulusLevelOffsets;
    % end
    %
    % %% transposed stimulus generation
    % switch St.Type
    %     case { 'transposedtone' }
    %         stimulus = bsxfun(@times, stimulus, carrier(N/4+(1:size(stimulus,1))));
    %         shiftstim = bsxfun(@times, shiftstim, carrier(N/4+(1:size(shiftstim,1))));
    % end
    %
    % %% level calibration for transposed tones
    % switch St.Type
    %     case { 'transposedtone' }
    %         % R = double ramp duration in samples
    %         RMS = db(std(stimulus(1+R/2:N-R/2,:),1));
    %         stimulus = bsxfun(@times,stimulus,10.^((-MaxSPL(:)+St.Level(:)-RMS(:)+Hw.LevelCorrection(:))/20).');
    %         stimulus = fftfilt(CalFilter,[stimulus;zeros(size(CalFilter,1),size(stimulus,2))]);
    %         shiftstim = bsxfun(@times, shiftstim, 10.^((-MaxSPL(:)+St.Level(:)-RMS(:)+Hw.LevelCorrection(:))/20).');
    %         shiftstim = [shiftstim; zeros(size(CalFilter,1),size(shiftstim,2),size(shiftstim,3))];
    %         for k = 1:size(shiftstim, 3)
    %             shiftstim(:,:,k) = fftfilt(CalFilter, shiftstim(:,:,k));
    %         end
    %         TimeOffset = TimeOffset + max(mean(GroupDelay),0);
    %     otherwise
    % end
    % %% switch off unused channels
    % switch St.PresentationType
    %     case 'simple binaural'
    %         switch St.StimulusSide
    %             case 'L'
    %                 stimulus(:,2) = 0;
    %             case 'R'
    %                 stimulus(:,1) = 0;
    %             case 'L+R'
    %         end
    %         switch St.MaskerSide
    %             case 'L'
    %                 masker(:,2) = 0;
    %             case 'R'
    %                 masker(:,1) = 0;
    %             case 'L+R'
    %         end
    % end
    
    [stimulus, TimeOffset, shiftstim, masker, St, MaskerSamples, mWin] = PrepareStimulus(fs, St, Hw, []);
    
    %% trigger
    trigger = zeros(size(stimulus,1),1);
    trigger(round(TimeOffset*fs)+(1:round(0.001*fs))) = 0.1824;  % works with all switch positions on RME Multiface
    
    %% preparation
    
    counter = 0;
    stS.RecSize = round(Rc.PreTime*fs)+max(round(Rc.RecTime*fs),length(stimulus))+Rc.ExtraSmp;
    IdxVec = (-round(Rc.PreTime*fs):round(Rc.RecTime*fs)-1).';
    stS.t_ms = (IdxVec/fs)/1e-3;
    stS.FFTSize = 2^nextpow2(round(Rc.RecTime*fs));
    stS.f_Hz =  (0:stS.FFTSize-1).'/stS.FFTSize*fs;
    
    Time = 0;
    LastTime = -Inf;
    AvgPeriod = 0;
    VarPeriod = 0;
    tic;
    
    f = (0:length(IdxVec)-1).'/length(IdxVec)*fs; f(f>=fs/2) = f(f>=fs/2) - fs;
    
    Avg  = zeros(length(IdxVec),length(St.ITD)+2,length(St.ILD));
    Var  = zeros(length(IdxVec),length(St.ITD)+2,length(St.ILD));
    AvgC = zeros(length(St.ITD)+2,length(St.ILD));
    
    Mic  = zeros(length(IdxVec),length(Rc.MicCh),length(St.ITD)+2,length(St.ILD));
    MicC = zeros(length(St.ITD)+2,length(St.ILD));
    
    lastpage   = -1;
    page       =  1;
    startpage  =  0;
    if ~Hw.DryRun
        page      = playrec('playrec',[stimulus*0,trigger],[Hw.StimCh Hw.TrgCh],stS.RecSize,1:Hw.RecCh);
        startpage = page;
    else
    end
    % recording = zeros(stS.RecSize,Hw.RecCh);
    signal = 0*stimulus;
    pre_padding = zeros(round(Rc.PreTime*fs)-floor(TimeOffset*fs),3);
    
    lastitdidx = -1; itdidx = -1; lastsign = 1; sign = 1; lastildidx = -1; ildidx = -1;
    stimstart = [];
    ITDix = 1;
    ILDix = 1;
    
    LeftIdx  = 1;
    RightIdx = 2;
    
    mx = 0;
    
    ArtefactCounter = 0;
    TriggerWrongCounter = 0;
    PreTimeTooShort = false;
    PostTimeTooShort = false;
    
    Conditions = nan((Rc.MaxRepsPerCond*2)*(length(St.ITD)+2)*length(St.ILD),4);
    
    %% data file
    datetime = datestr(now,'yyyy-mm-dd-HH-MM-SS');
    
    filename = [Rc.FileName '_' datetime];
    bAgain = true;
    while bAgain
        answer = inputdlg('Enter file name (without extension)','Recording file name',1,{filename},struct('Resize','on','WindowStyle','modal','Interpreter','none'));
        if ~isempty(answer) && (exist([answer{1} '.dat'],'file') || exist([answer{1} '.mat'],'file'))
            overwrite = questdlg([answer{1} '.dat or ' answer{1} '.mat already exist. Overwrite?'],'Warning','Yes','No','Cancel','No');
            if strcmp(overwrite,'Yes')
                filename = answer{1};
                bAgain = false;
            elseif strcmp(overwrite,'No')
            elseif strcmp(overwrite,'Cancel')
                return;
            end
        elseif ~isempty(answer)
            filename = answer{1};
            bAgain = false;
        else
            return;
        end
    end
    
    fid = fopen([filename '.dat'],'w');
    if fid < 0
        error('could not open data file %s for writing',[filename '.dat']);
    end
    fwrite(fid,'ABRdata','char');
    fwrite(fid,datetime,'char');
    fwrite(fid,fs,'uint32');
    fwrite(fid,max(Hw.RecCh, max(Rc.SaveCh)),'uint16');
    fwrite(fid,stS.RecSize,'uint32');
    fwrite(fid,TimeOffset,'double');
    fwrite(fid,InputScalingFactor_uV,'double');
    
    % prepare index list if necessary
    [~, ~, St, ~] = GetNextStimulusIndices(St, Rc);
    
    %% play/rec loop
    
    while bRunning && (all(AvgC(:)==0) || min(AvgC(AvgC(:)>0)) < Rc.MaxRepsPerCond)
        
        % get recording
        if lastpage ~= startpage && lastpage >= 0 && all([lastitdidx lastildidx] > 0)
            
            if ~Hw.DryRun
                playrec('block',lastpage);
                recording = double(playrec('getRec',lastpage));
                % immediately delete page from memory (will not be used any more)
                % otherwise the RAM will fill up very quickly
                playrec('delPage',lastpage);
            else
                recording = lastsignal;
            end
            
            recording(1:length(signal), Rc.SaveCh) = signal;
            
            % write raw data to file
            fwrite(fid,reshape(recording.',[],1),'float32');
            
            counter = counter + 1;
            
            Conditions(counter,1) = lastitdidx;
            Conditions(counter,2) = lastildidx;
            Conditions(counter,3) = lastsign;
            
            % process data
            EEG = recording(:,Rc.EEGCh)*InputScalingFactor_uV;
            EEG = EEG - mean(EEG);
            mx = max(mx,max(abs(EEG)));
            
            % threshold 0.1 works with all switch positions on RME Multiface
            stimstart = find(filtfilt(0.3,[1 -0.7],recording(:,Rc.TrgCh)) > 0.1,1,'first');
            
            if ~isempty(stimstart) && stimstart+min(IdxVec) >= 1 && stimstart+max(IdxVec) <= length(EEG)
                
                CutOut = EEG(stimstart+IdxVec);
                
                if ~Rc.RejectArtefacts || max(abs(CutOut)) < Rc.ArtefactThr
                    
                    AvgC(lastitdidx,lastildidx)  = AvgC(lastitdidx,lastildidx) + 1;
                    Delta                        = CutOut - Avg(:,lastitdidx,lastildidx);
                    Avg(:,lastitdidx,lastildidx) = Avg(:,lastitdidx,lastildidx) + Delta/AvgC(lastitdidx,lastildidx);
                    Var(:,lastitdidx,lastildidx) = Var(:,lastitdidx,lastildidx) + Delta .* (CutOut - Avg(:,lastitdidx,lastildidx));
                    
                    Conditions(counter,4) = 1;
                    
                else
                    
                    Conditions(counter,4) = 0;
                    ArtefactCounter = ArtefactCounter + 1;
                    
                end
                
                MicC(lastitdidx,lastildidx)    = MicC(lastitdidx,lastildidx) + 1;
                Delta                          = lastsign*MicScaling_Pa*recording(stimstart+IdxVec,Rc.MicCh) - Mic(:,:,lastitdidx,lastildidx);
                Mic(:,:,lastitdidx,lastildidx) = Mic(:,:,lastitdidx,lastildidx) + Delta/MicC(lastitdidx,lastildidx);
                
            else
                
                if stimstart+min(IdxVec) < 1
                    PreTimeTooShort = true;
                end
                if stimstart+max(IdxVec) > length(EEG)
                    PostTimeTooShort = true;
                end
                TriggerWrongCounter = TriggerWrongCounter + 1;
                
            end
            
            
        end
        
        [itdidx, ildidx, St, bR] = GetNextStimulusIndices(St, Rc);
        bRunning = bR && bRunning;
        
        % prepare next stimulus
        switch St.PresentationType
            case 'L/R/B'
                lastildidx = ildidx;
                %             ildidx     = randi(length(St.ILD),1);
                if ~St.LevelThreshold
                    % positive ILD => softer left (1), louder right (2)
                    LeftILDFactor  = 10^(-St.ILD(ildidx)/2/20);
                    RightILDFactor = 10^(+St.ILD(ildidx)/2/20);
                else
                    LeftILDFactor  = 10^(+St.ILD(ildidx)/20);
                    RightILDFactor = 10^(+St.ILD(ildidx)/20);
                end
                lastitdidx = itdidx;
                %             itdidx    = randi(length(St.ITD)+2,1);
            case 'simple binaural'
                lastildidx = ildidx;
                %             ildidx     = randi(length(St.ILD),1);
                LeftMaskerFactor  = 10^(+St.ILD(ildidx)/20);
                RightMaskerFactor = 10^(+St.ILD(ildidx)/20);
                lastitdidx = itdidx;
                %             itdidx    = randi(length(St.ITD),1);
                LeftStimFactor  = 10^(+St.ITD(itdidx)/20);
                RightStimFactor = 10^(+St.ITD(itdidx)/20);
        end
        
        
        if St.UseSignSwapping
            lastsign  = sign;
            sign      = floor(rand(1)*2)*2-1;
        end
        
        %     lastsignal = [[sum(signal,2), zeros(size(signal,1),1), trigger, 10^(-22/20)*signal, zeros(size(signal,1),1)];zeros(Rc.ExtraSmp,Hw.RecCh)];
        lastsignal = signal;
        lastsignal = [zeros(size(pre_padding,1),size(lastsignal,2));lastsignal];
        lastsignal(end+1:stS.RecSize, :) = 0;
        
        if ~isfield(St, 'Frozen') || ~St.Frozen
            [stimulus, TimeOffset, shiftstim, masker, St, MaskerSamples, mWin] = PrepareStimulus(fs, St, Hw, itdidx-2);
        end
        
        switch St.PresentationType
            case 'L/R/B'
                switch itdidx
                    case 1
                        signal(:,1) = LeftILDFactor  * sign * stimulus(:,1);
                        signal(:,2) = 0;
                    case 2
                        signal(:,2) = RightILDFactor * sign * stimulus(:,2);
                        signal(:,1) = 0;
                    otherwise
                        signal(:,1) = LeftILDFactor  * sign * shiftstim(:,1,itdidx-2);
                        signal(:,2) = RightILDFactor * sign * shiftstim(:,2,itdidx-2);
                end
            case 'simple binaural'
                signal(:,1) = LeftStimFactor  * stimulus(:,1);
                signal(:,2) = RightStimFactor * stimulus(:,2);
                if St.MaskerFrozen
                    offset = 0;
                else
                    offset = randi(St.BufferLen-MaskerSamples,1);
                end
                signal(1:MaskerSamples,1) = signal(1:MaskerSamples,1) + LeftMaskerFactor  * mWin .* masker(offset+(1:MaskerSamples),1);
                signal(1:MaskerSamples,2) = signal(1:MaskerSamples,2) + RightMaskerFactor * mWin .* masker(offset+(1:MaskerSamples),2);
                
                signal = sign * signal;
                
        end
        
        
        
        % play next stimulus
        pause(rand(1)*1/50);
        lastpage = page;
        switch St.Type
            case 'modulated noise'
                noise  = randn(size(signal,1),1);
                signal = signal.*repmat(noise,1,size(signal,2));
                signal = fftfilt(CalFilter,signal);
            otherwise
        end
        
        if ~Hw.DryRun
            page  = playrec('playrec',[pre_padding;[signal,trigger]],[Hw.StimCh Hw.TrgCh],stS.RecSize,1:Hw.RecCh);
        else
        end
        
        % display data
        if all([ITDix ILDix]>0) && (Time-LastTime) > stS.DisplayTime
            
            % OnlineABR display function uses the stS structure, which
            % which needs to be updated with local placeholders
            stS.Stimulus  = St;
            stS.Hardware  = Hw;
            stS.Recording = Rc;
            
            switch St.PresentationType
                case 'L/R/B'
                    BinIdx   = ITDix+2;
                    stS.Msg   = sprintf('Epochs: %1.0f (%1.0f)\nLeft: %1.0f\nRight: %1.0f\nBin.: %1.0f\nAvg. Period: %5.2f +/- %5.2f ms\nMax: %1.3f\nStd: %1.3f\nITD: %1.0f µs\nILD: %1.1f dB',...
                        counter,min(AvgC(:)),AvgC(LeftIdx,ILDix),AvgC(RightIdx,ILDix),AvgC(BinIdx,ILDix),...
                        AvgPeriod/1e-3,sqrt(VarPeriod/counter)/1e-3,mx,sqrt(max(max(Var(:,[LeftIdx RightIdx ITDix],ILDix)).'./AvgC([LeftIdx RightIdx ITDix],ILDix))),...
                        St.ITD(ITDix)/1e-6,St.ILD(ILDix));
                    Data(1:size(Avg,1),LeftIdx)  = Avg(:,LeftIdx      ,ILDix);
                    Data(1:size(Avg,1),RightIdx) = Avg(:,RightIdx      ,ILDix);
                    Data(1:size(Avg,1),3)        = Avg(:,BinIdx,ILDix);
                    
                    L = real(ifft(fft(Avg(:,LeftIdx ,ILDix)).*exp(-1i*2*pi*f*(+St.ITD(ITDix)/2))));
                    R = real(ifft(fft(Avg(:,RightIdx,ILDix)).*exp(-1i*2*pi*f*(-St.ITD(ITDix)/2))));
                case 'simple binaural'
                    BinIdx = ITDix;
                    stS.Msg   = sprintf('Epochs: %1.0f (%1.0f)\nAvg. Period: %5.2f +/- %5.2f ms\nMax: %1.3f\nStd: %1.3f\nStim Level: %1.1f dB\nMasker Level: %1.1f dB',...
                        counter,min(AvgC(AvgC>0)),...
                        AvgPeriod/1e-3,sqrt(VarPeriod/counter)/1e-3,mx,sqrt(max(max(Var(:,BinIdx,ILDix)).'./AvgC(BinIdx,ILDix))),...
                        St.ITD(ITDix),St.ILD(ILDix));
                    Data(1:size(Avg,1),1) = 0;
                    Data(1:size(Avg,1),2) = 0;
                    Data(1:size(Avg,1),3) = Avg(:,BinIdx,ILDix);
                    
                    L = 0;
                    R = 0;
            end
            
            Data(1:size(Avg,1),4)        = Avg(:,BinIdx,ILDix)-(L+R);
            Data(1:size(Avg,1),9)        = L+R;
            
            Data(:,5:6) = Mic(:,1:2,BinIdx,ILDix);
            [bR,ITDix,ILDix] = OnlineABR(sDisplayCallback,stS,Data,TimeOffset);
            bRunning = bR && bRunning;
            
            if ArtefactCounter > 0
                fprintf('artefacts rejected: %1.0f\n', ArtefactCounter);
            end
            if TriggerWrongCounter > 0
                fprintf('triggers not found: %1.0f\n', TriggerWrongCounter);
                if PreTimeTooShort
                    fprintf('pre time too short\n');
                end
                if PostTimeTooShort
                    fprintf('post time too short\n');
                end
            end
            
            LastTime = Time;
            
        end
        
        % timekeeping
        if counter > 0
            PTime = Time;
            Time = toc;
            %         disp(Time-PTime);
            Delta = (Time-PTime) - AvgPeriod;
            AvgPeriod = AvgPeriod + Delta/counter;
            VarPeriod = VarPeriod + Delta * ((Time-PTime) - AvgPeriod);
        end
        
        
    end
    
    if ~Hw.DryRun
        if playrec('isInitialised')
            playrec('reset')
        end
    else
        fprintf('finished dry run.\n');
    end
    
    
    %% display final result
    
    switch St.PresentationType
        case 'L/R/B'
            BinIdx   = ITDix+2;
            stS.Msg   = sprintf('Epochs: %1.0f (%1.0f)\nLeft: %1.0f\nRight: %1.0f\nBin.: %1.0f\nAvg. Period: %5.2f +/- %5.2f ms\nMax: %1.3f\nStd: %1.3f\nITD: %1.0f µs\nILD: %1.1f dB',...
                counter,min(AvgC(:)),AvgC(LeftIdx,ILDix),AvgC(RightIdx,ILDix),AvgC(BinIdx,ILDix),...
                AvgPeriod/1e-3,sqrt(VarPeriod/counter)/1e-3,mx,sqrt(max(max(Var(:,[LeftIdx RightIdx ITDix],ILDix)).'./AvgC([LeftIdx RightIdx ITDix],ILDix))),...
                St.ITD(ITDix)/1e-6,St.ILD(ILDix));
            Data(1:size(Avg,1),LeftIdx)  = Avg(:,LeftIdx      ,ILDix);
            Data(1:size(Avg,1),RightIdx) = Avg(:,RightIdx      ,ILDix);
            Data(1:size(Avg,1),3)        = Avg(:,BinIdx,ILDix);
            
            L = real(ifft(fft(Avg(:,LeftIdx ,ILDix)).*exp(-1i*2*pi*f*(+St.ITD(ITDix)/2))));
            R = real(ifft(fft(Avg(:,RightIdx,ILDix)).*exp(-1i*2*pi*f*(-St.ITD(ITDix)/2))));
        case 'simple binaural'
            BinIdx = ITDix;
            stS.Msg   = sprintf('Epochs: %1.0f (%1.0f)\nAvg. Period: %5.2f +/- %5.2f ms\nMax: %1.3f\nStd: %1.3f\nStim Level: %1.1f dB\nMasker Level: %1.1f dB',...
                counter,min(AvgC(AvgC>0)),...
                AvgPeriod/1e-3,sqrt(VarPeriod/counter)/1e-3,mx,sqrt(max(max(Var(:,BinIdx,ILDix)).'./AvgC(BinIdx,ILDix))),...
                St.ITD(ITDix),St.ILD(ILDix));
            Data(1:size(Avg,1),1) = 0;
            Data(1:size(Avg,1),2) = 0;
            Data(1:size(Avg,1),3) = Avg(:,BinIdx,ILDix);
            
            L = 0;
            R = 0;
    end
    Data(1:size(Avg,1),4)        = Avg(:,BinIdx,ILDix)-(L+R);
    Data(1:size(Avg,1),9)        = L+R;
    
    Data(:,5:6) = Mic(:,1:2,BinIdx,ILDix);
    [bRunning,ITDix,ILDix] = OnlineABR(sDisplayCallback,stS,Data,TimeOffset);
    
    if ArtefactCounter > 0
        fprintf('artefacts rejected: %1.0f\n', ArtefactCounter);
    end
    if TriggerWrongCounter > 0
        fprintf('triggers not found: %1.0f\n', TriggerWrongCounter);
        if PreTimeTooShort
            fprintf('pre time too short\n');
        end
        if PostTimeTooShort
            fprintf('post time too short\n');
        end
    end
    
    
    
    
    %% clean up
    
    Conditions(all(isnan(Conditions),2),:) = [];
    
    if fid > 0
        fclose(fid);
        save([filename '.mat'],'Conditions','AvgC','Avg','MicC','Mic','St','Hw','Rc');
    end
    
    if isfield(St, 'temp')
        St = rmfield(St, 'temp');
    end
    
    stS.Stimulus  = St;
    stS.Hardware  = Hw;
    stS.Recording = Rc;
    OnlineABR(sFinishedCallback,stS);
    
    
