function [stimulus, TimeOffset, shiftstim, masker, St, MaskerSamples, mWin] = PrepareStimulus(fs, St, Hw, SingleITDIndex)
    N = round(St.Duration*fs);
    
    masker = [0 0];
    
    % workaround for mismatched DefaultParameters.m (or P_*.m)
    % with cleaned up PrepareStimulus (only Bandwidth, no BandWidth)
    if isfield(St, 'BandWidth') && ~isfield(St, 'Bandwidth')
        St.Bandwidth = St.BandWidth;
        St = rmfield(St, 'BandWidth');
    end
    
    
    switch St.Type
        case 'tone'
            switch St.Window
                case { 'ongoing', 'onoffset' }
                    stimulus = sin(2*pi*St.Frequency*(0:2*N-1).'/fs);
                otherwise
                    stimulus = sin(2*pi*St.Frequency*(0:N-1).'/fs);
            end
            RMS = db(std(stimulus(1:N,:),1));
            TimeOffset = 0;
        case 'transposedtone'
            switch St.Window
                case { 'ongoing', 'onoffset' }
                    stimulus = sin(2*pi*St.Frequency*(0:2*N-1).'/fs);
                otherwise
                    stimulus = sin(2*pi*St.Frequency*(0:N-1).'/fs);
            end
            RMS = db(std(stimulus(1:N,:),1));
            TimeOffset = 0;
            % high-frequency carrier tone
            carrier = sin(2*pi*St.CarrierFrequency*(0:2*N-1).'/fs);
            % half wave rectification of modulator
            stimulus = 0.5 * (abs(stimulus) + stimulus);
            % low pass filtering of modulator
            f = (0:length(stimulus)-1).'/length(stimulus)*St.Fs; f(f>=St.Fs/2) = f(f>=St.Fs/2) - St.Fs;
            stimulus = real(ifft(bsxfun(@times, fft(stimulus), abs(f) <= St.LowPassFrequency)));
            % modulating modulator on carrier tone
            % is done after shifting for ITD
        case 'click'
            stimulus = [1;zeros(N-1,1)];
            RMS = -db(sqrt(2));
            TimeOffset = 0;
        case 'standardclick'
            StdDuration = 50e-6;
            stimulus = zp2tf(exp(-1i*[+1;-1]*(1/StdDuration)*2*pi/fs),[],1).';
            stimulus(end+1:N) = 0;
            stimulus = stimulus/max(abs(stimulus));
            RMS = -db(sqrt(2));
            TimeOffset = round(StdDuration*fs/2)/fs;
        case 'doubleclick'
            stimulus = [0.2;zeros(6,1);1;zeros(N-8,1)];
            RMS = 10*log10(0.2.^2+1^2);
            TimeOffset = 3/fs;
        case 'broadband noise'
            stimulus = randn(N,1);
            RMS = db(std(stimulus(1:N,:),1));
            TimeOffset = 0;
        case 'narrowband noise'
            stimulus = randn(N,1);
            f = (0:N-1).'/N*fs; f(f>=fs/2) = f(f>=fs/2) - fs;
            stimulus = real(ifft(fft(stimulus).*(abs(f)>(St.CenterFreq-St.Bandwidth/2)&abs(f)<=(St.CenterFreq+St.Bandwidth/2))));
            RMS = db(std(stimulus(1:N,:),1));
            TimeOffset = 0;
        case 'modulated noise'
            stimulus = 1-St.ModulationDepth*cos(2*pi*St.Frequency*(0:N-1).'/fs);
            RMS = db(std(stimulus(1:N,:).*randn(N,size(stimulus,2)),1));
            TimeOffset = 0;
        case 'efr'
            St.ModulationIndex = db(St.ModulationDepth);
            stimulus = (1+St.ModulationDepth*cos(2*pi*St.Frequency*(0:N-1).'/fs)) ...
                         .* sin(2*pi*St.CarrierFrequency*(0:N-1).'/fs);
            RMS = db(std(stimulus(1:N,:),1));
            TimeOffset = 0;
        case {'wave','raw'}
            if strcmp(St.Type,'wave')
                [stimulus,St.Fs] = wavread(St.FileName);
            else
                fid = fopen(St.FileName,'r');
                stimulus = reshape(fread(fid,St.SampleFormat),St.FileCh,[]).';
                fclose(fid);
            end
            if St.Fs ~= fs
                if St.bDoResample
                    stimulus = resample(stimulus,fs,St.Fs);
                else
                    error('wave file and output sampling rates do not match');
                end
            end
            N = length(stimulus);
            RMS = db(std(stimulus(1:N,:),1));
            TimeOffset = St.FileTimeOffset;
            
        case 'CAP'
            % St.BufferLen
            % St.IAC
            % St.CenterFreq
            % St.Bandwidth
            % St.MaskerLevel
            % St.MaskerDuration
            % St.StimOnsetDelay
            % St.PresentationType
            % St.MaskerLevelOffsets
            % St.StimulusLevelOffsets
            % St.MaskerRampDur
            % St.StimulusSide
            % St.MaskerSide
            
            masker = randn(St.BufferLen,1);
            if St.IAC < 1.0
                masker(:,2) = St.IAC * masker + sqrt(1-St.IAC.^2) * randn(St.BufferLen,1);
            else
                masker(:,2) = masker(:,1);
            end
            f = (0:St.BufferLen-1).'/St.BufferLen * fs;
            f(f>=fs/2) = f(f>=fs/2) - fs;
            masker = real(ifft(bsxfun(@times,fft(masker),abs(abs(f)-St.CenterFreq) < St.Bandwidth)));
            masker = bsxfun(@rdivide,masker,std(masker));
            
            mRMS = 0;
            
            stimulus = sin(2*pi*St.Frequency*(0:N-1).'/fs);
            RMS = db(std(stimulus(1:N,:),1));
            TimeOffset = 0;
            
            
        otherwise
            error('unsupported stimulus type: %s',St.Type);
    end
    
    %% stimulus windowing
    
    R = round(St.RampDur*fs)*2;
    switch St.Window
        case 'none'
            W = [];
        case { 'hann', 'all' }
            W = hann(R);
        case { 'ongoing', 'onoffset' }
            W = [];
        otherwise
            error('unsupported window type: %s',St.Window);
    end
    stimulus = bsxfun(@times,stimulus,[W(1:end/2);ones(length(stimulus)-length(W),1);W(end/2+1:end)]);
    switch St.Type
        case 'CAP'
            R = round(St.MaskerRampDur*fs)*2;
            switch St.Window
                case 'none'
                    W = [];
                case 'hann'
                    W = hann(R);
                otherwise
                    error('unsupported window type: %s',St.Window);
            end
            mWin = [W(1:end/2);ones(round(St.MaskerDuration*fs)-length(W),1);W(end/2+1:end)];
            MaskerSamples = length(mWin);
        otherwise
            MaskerSamples = length(stimulus);
            St.BufferLen = MaskerSamples+1;
            masker = zeros(MaskerSamples,2);
            mWin = zeros(MaskerSamples,1);
    end
    
    %% stimulus time delay
    switch St.Type
        case 'CAP'
            stimulus = [zeros(round(St.StimOnsetDelay*fs),size(stimulus,2));stimulus];
            TimeOffset = TimeOffset + St.StimOnsetDelay;
    end
    
    
    %% load calibration data
    Cal = load(Hw.CalFile);
    if Cal.nSamplingFrequency ~= fs
        error('calibration and output sampling rates do not match');
    end
    for ch = 1:length(Hw.StimCh)
        idx = find(Cal.mfOutInChannelList(:,1)+1 == Hw.StimCh(ch),1,'first');
        CalFilter(:,ch)  = Cal.mfFilterCoeffs(:,idx);
        MaxSPL(ch)       = Cal.vfMaxSPL(idx);
        gd               = grpdelay(Cal.mfFilterCoeffs(:,idx),1,size(Cal.mfFilterCoeffs(:,idx),1),fs);
        GroupDelay(ch,1) = mean(gd(2:end))/fs;
    end
    
    
    
    %% stimulus level calibration
    switch St.Type
        case { 'transposedtone' }
        otherwise
            stimulus = bsxfun(@times,stimulus,10.^((-MaxSPL(:)+St.Level(:)-RMS(:)+Hw.LevelCorrection(:))/20).');
    end
    switch St.Type
        case 'CAP'
            masker = bsxfun(@times,masker,10.^((-MaxSPL(:)+St.MaskerLevel(:)-mRMS(:)+Hw.LevelCorrection(:))/20).');
    end
    
    
    %% stimulus spectrum calibration
    switch St.Type
        case 'modulated noise'
            stimulus = [stimulus;zeros(size(CalFilter,1),size(stimulus,2))];
            TimeOffset = TimeOffset + max(mean(GroupDelay),0);
        case 'CAP'
            stimulus = fftfilt(CalFilter,[stimulus;zeros(size(CalFilter,1),size(stimulus,2))]);
            TimeOffset = TimeOffset + max(mean(GroupDelay),0);
            masker = fftfilt(CalFilter,[masker;zeros(size(CalFilter,1),size(masker,2))]);
            masker = masker(max(round(mean(GroupDelay)*fs),0)+(1:St.BufferLen),:);
        case { 'transposedtone' }
            stimulus = repmat(stimulus, 1, 2);
        otherwise
            stimulus = fftfilt(CalFilter,[stimulus;zeros(size(CalFilter,1),size(stimulus,2))]);
            TimeOffset = TimeOffset + max(mean(GroupDelay),0);
            %         TimeOffset = TimeOffset + size(CalFilter,1)/2/fs;
    end
    
    %% stimulus ITD/ILD preparation
    switch St.PresentationType
        case 'L/R/B'
            switch St.Window
                case { 'onoffset' }
                    W = hann(R);
                    base_stimulus = stimulus;
                    stimulus = repmat([W(1:end/2);ones(N-length(W),1);W(end/2+1:end)],1,2);
            end
            stimulus = [zeros(ceil(max(abs(St.ITD))*fs),size(stimulus,2));stimulus;zeros(ceil(max(abs(St.ITD))*fs),size(stimulus,2))];
            TimeOffset = TimeOffset + max(abs(St.ITD));
            f = (0:size(stimulus,1)-1).'/size(stimulus,1)*fs;
            f(f>=fs/2) = f(f>=fs/2) - fs;
            if isempty(SingleITDIndex)
                shiftstim = zeros(size(stimulus,1),2,length(St.ITD));
                for tx = 1:length(St.ITD)
                    % positive ILD and ITD move to the right,
                    % positive ITD => later left (1), earlier right (2)
                    shiftstim(:,1,tx) = real(ifft(fft(stimulus(:,1)) .* exp(-1i*2*pi*f*(+St.ITD(tx)/2))));
                    shiftstim(:,2,tx) = real(ifft(fft(stimulus(:,2)) .* exp(-1i*2*pi*f*(-St.ITD(tx)/2))));
                end
            elseif SingleITDIndex <= length(St.ITD) && SingleITDIndex > 0
                tx = SingleITDIndex;
                shiftstim(:,1,tx) = real(ifft(fft(stimulus(:,1)) .* exp(-1i*2*pi*f*(+St.ITD(tx)/2))));
                shiftstim(:,2,tx) = real(ifft(fft(stimulus(:,2)) .* exp(-1i*2*pi*f*(-St.ITD(tx)/2))));
            else
                tx = 1;
                shiftstim(:,1,tx) = real(ifft(fft(stimulus(:,1)) .* exp(-1i*2*pi*f*(+St.ITD(tx)/2))));
                shiftstim(:,2,tx) = real(ifft(fft(stimulus(:,2)) .* exp(-1i*2*pi*f*(-St.ITD(tx)/2))));
            end
            
            switch St.Window
                case { 'onoffset' }
                    stimulus = bsxfun(@times, stimulus, base_stimulus(N/4+(1:size(stimulus,1)), :));
                    shiftstim = bsxfun(@times, shiftstim, base_stimulus(N/4+(1:size(stimulus,1)), :));
                case { 'ongoing' }
                    W = hann(R);
                    W = [zeros(ceil(max(abs(St.ITD))*fs),1);W(1:end/2);ones(N-length(W),1);W(end/2+1:end);zeros(ceil(max(abs(St.ITD))*fs),1)];
                    stimulus = bsxfun(@times, W, stimulus(N/4+(1:length(W)), :));
                    shiftstim = bsxfun(@times, W, shiftstim(N/4+(1:length(W)), :, :));
            end
        case 'simple binaural'
            St.ILD = St.MaskerLevelOffsets;
            St.ITD = St.StimulusLevelOffsets;
            shiftstim = stimulus;
    end
    
    %% transposed stimulus generation
    switch St.Type
        case { 'transposedtone' }
            stimulus = bsxfun(@times, stimulus, carrier(N/4+(1:size(stimulus,1))));
            shiftstim = bsxfun(@times, shiftstim, carrier(N/4+(1:size(shiftstim,1))));
    end
    
    %% level calibration for transposed tones
    switch St.Type
        case { 'transposedtone' }
            % R = double ramp duration in samples
            RMS = db(std(stimulus(1+R/2:N-R/2,:),1));
            stimulus = bsxfun(@times,stimulus,10.^((-MaxSPL(:)+St.Level(:)-RMS(:)+Hw.LevelCorrection(:))/20).');
            stimulus = fftfilt(CalFilter,[stimulus;zeros(size(CalFilter,1),size(stimulus,2))]);
            shiftstim = bsxfun(@times, shiftstim, 10.^((-MaxSPL(:)+St.Level(:)-RMS(:)+Hw.LevelCorrection(:))/20).');
            shiftstim = [shiftstim; zeros(size(CalFilter,1),size(shiftstim,2),size(shiftstim,3))];
            for k = 1:size(shiftstim, 3)
                shiftstim(:,:,k) = fftfilt(CalFilter, shiftstim(:,:,k));
            end
            TimeOffset = TimeOffset + max(mean(GroupDelay),0);
        otherwise
    end
    %% switch off unused channels
    switch St.PresentationType
        case 'simple binaural'
            switch St.StimulusSide
                case 'L'
                    stimulus(:,2) = 0;
                case 'R'
                    stimulus(:,1) = 0;
                case 'L+R'
            end
            switch St.MaskerSide
                case 'L'
                    masker(:,2) = 0;
                case 'R'
                    masker(:,1) = 0;
                case 'L+R'
            end
    end
