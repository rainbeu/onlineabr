function stS = PlayStimulus(stS,sDisplayCallback,sFinishedCallback)

%% parameters
fs = stS.Fs;
Hw = stS.Hardware;
St = stS.Stimulus;
Rc = stS.Recording;

stS.Msg = 'Start';
bRunning = true;
fid = -1;

InputScalingFactor_uV = 10^(2/20)/1e4*2*sqrt(2)/1e-6;
MicScaling_Pa = 2e-5/1e-6*10^(2/20);
[fb,fa] = butter(4,[300 3000]/fs*2);


%% sound device initialization
if playrec('isInitialised')
    playrec('reset')
end
playrec('init',fs,Hw.PlayDev,Hw.RecDev,Hw.PlayCh,Hw.RecCh,Hw.BufferSize);

%% stimulus generation

N = round(St.Duration*fs);

switch St.Type
    case 'tone'
        stimulus = sin(2*pi*St.Frequency*(0:N-1).'/fs);
        RMS = db(std(stimulus(1:N,:),1));
        TimeOffset = 0;
    case 'click'
        stimulus = [1;zeros(N-1,1)];
        RMS = 0;
        TimeOffset = 0;
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
        RMS = db(std(stimulus(1:N,:),1));
        TimeOffset = 0;
    case 'modulated noise'
        stimulus = 1-St.ModulationDepth*cos(2*pi*St.Frequency*(0:N-1).'/fs);
        RMS = db(std(stimulus(1:N,:).*randn(N,size(stimulus,2)),1));
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
    otherwise
        error('unsupported stimulus type: %s',St.Type);
end


%% stimulus windowing

R = round(St.RampDur*fs)*2;
switch St.Window
    case 'none'
        W = [];
    case 'hann'
        W = hann(R);
    otherwise
        error('unsupported window type: %s',St.Window);
end
stimulus = bsxfun(@times,stimulus,[W(1:end/2);ones(length(stimulus)-length(W),1);W(end/2+1:end)]);


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
stimulus = bsxfun(@times,stimulus,10.^((-MaxSPL(:)+St.Level(:)-RMS(:)+Hw.LevelCorrection(:))/20).');


%% stimulus spectrum calibration
switch St.Type
    case 'modulated noise'
        stimulus = [stimulus;zeros(size(CalFilter,1),size(stimulus,2))];
    otherwise
        stimulus = fftfilt(CalFilter,[stimulus;zeros(size(CalFilter,1),size(stimulus,2))]);
        TimeOffset = TimeOffset + max(mean(GroupDelay),0);
%         TimeOffset = TimeOffset + size(CalFilter,1)/2/fs;
end

%% stimulus ITD/ILD preparation
stimulus = [zeros(ceil(max(abs(St.ITD))*fs),size(stimulus,2));stimulus;zeros(ceil(max(abs(St.ITD))*fs),size(stimulus,2))];
TimeOffset = TimeOffset + max(abs(St.ITD));
f = (0:size(stimulus,1)-1).'/size(stimulus,1)*fs;
f(f>=fs/2) = f(f>=fs/2) - fs;
shiftstim = zeros(size(stimulus,1),2,length(St.ITD));
for tx = 1:length(St.ITD)
    % positive ILD and ITD move to the right,
    % positive ITD => later left (1), earlier right (2)
    shiftstim(:,1,tx) = real(ifft(fft(stimulus(:,1)) .* exp(-1i*2*pi*f*(+St.ITD(tx)/2))));
    shiftstim(:,2,tx) = real(ifft(fft(stimulus(:,2)) .* exp(-1i*2*pi*f*(-St.ITD(tx)/2))));
end


%% trigger
trigger = zeros(size(stimulus,1),1);
trigger(round(TimeOffset*fs)+(1:round(0.001*fs))) = 1;

%% preparation

counter = 0;
stS.RecSize = length(stimulus)+Rc.ExtraSmp;
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

Mic  = zeros(length(IdxVec),length(Rc.MicCh)*2,length(St.ITD)+2,length(St.ILD));
MicC = zeros(length(St.ITD)+2,length(St.ILD));

lastpage   = -1;
page       =  1;
page      = playrec('playrec',[stimulus*0,trigger],[Hw.StimCh Hw.TrgCh],stS.RecSize,1:Hw.RecCh);
recording = zeros(stS.RecSize,Hw.RecCh);
signal = 0*stimulus;

lastitdidx = -1; itdidx = -1; lastsign = 1; sign = 1; lastildidx = 0; ildidx = 0;
stimstart = [];
ITDix = 1;
ILDix = 1;

LeftIdx  = 1;
RightIdx = 2;

mx = 0;

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
fwrite(fid,Hw.RecCh,'uint16');
fwrite(fid,stS.RecSize,'uint32');
fwrite(fid,TimeOffset,'double');
fwrite(fid,InputScalingFactor_uV,'double');


%% play/rec loop

while bRunning && min(AvgC(:)) < Rc.MaxRepsPerCond
    
    % get recording
    if lastpage >= 0 && all([lastitdidx lastildidx] > 0)
        
        playrec('block',lastpage);
        recording = double(playrec('getRec',lastpage));
        % immediately delete page from memory (will not be used any more)
        % otherwise the RAM will fill up very quickly
        playrec('delPage',lastpage);
        
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
        
        stimstart = find(filtfilt(0.3,[1 -0.7],recording(:,Rc.TrgCh)) > 0.5,1,'first');
        
        if ~isempty(stimstart) && stimstart+min(IdxVec) >= 1 && stimstart+max(IdxVec) <= length(EEG)
            
            CutOut = EEG(stimstart+IdxVec);
            
            if max(abs(CutOut)) < Rc.ArtefactThr
                
                AvgC(lastitdidx,lastildidx)  = AvgC(lastitdidx,lastildidx) + 1;
                Delta                        = CutOut - Avg(:,lastitdidx,lastildidx);
                Avg(:,lastitdidx,lastildidx) = Avg(:,lastitdidx,lastildidx) + Delta/AvgC(lastitdidx,lastildidx);
                Var(:,lastitdidx,lastildidx) = Var(:,lastitdidx,lastildidx) + Delta .* (CutOut - Avg(:,lastitdidx,lastildidx));
                
                Conditions(counter,4) = 1;
                
            else
                
                Conditions(counter,4) = 0;
                
            end
            
            MicC(lastitdidx,lastildidx)    = MicC(lastitdidx,lastildidx) + 1;
            Delta                          = lastsign*MicScaling_Pa*[recording(stimstart+IdxVec,Rc.MicCh),lastsignal(512+(1:length(IdxVec)),4:5)] - Mic(:,:,lastitdidx,lastildidx);
            Mic(:,:,lastitdidx,lastildidx) = Mic(:,:,lastitdidx,lastildidx) + Delta/MicC(lastitdidx,lastildidx);
            
        end
        
        
    end
    
    % prepare next stimulus
    lastildidx = ildidx;
%     ildidx     = randi(length(St.ILD),1);
    ildidx = floor(rand(1)*length(St.ILD))+1;
    if ~St.LevelThreshold
        LeftILDFactor  = 10^(-St.ILD(ildidx)/2/20);
        RightILDFactor = 10^(+St.ILD(ildidx)/2/20);
    else
        LeftILDFactor  = 10^(+St.ILD(ildidx)/20);
        RightILDFactor = 10^(+St.ILD(ildidx)/20);
    end
    lastitdidx = itdidx;
%     itdidx    = randi(length(St.ITD)+2,1);
    itdidx = floor(rand(1)*length(St.ITD))+1;
    if St.UseSignSwapping
        lastsign  = sign;
        sign      = floor(rand(1)*2)*2-1;
    end
    
    
    lastsignal = zeros(size(signal,1)+Rc.ExtraSmp,Hw.RecCh);
    lastsignal(1:size(signal,1),Rc.EEGCh) = sum(signal,2);
    lastsignal(1:size(signal,1),Rc.MicCh) = 10^(-22/20)*signal;
    lastsignal(1:size(trigger,1),Rc.TrgCh) = trigger;
%     lastsignal = [[sum(signal,2), zeros(size(signal,1),1), trigger, 10^(-22/20)*signal, zeros(size(signal,1),1)];zeros(Rc.ExtraSmp,Hw.RecCh)];
    
    % positive ILD => softer left (1), louder right (2)
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
    page  = playrec('playrec',[signal,trigger],[Hw.StimCh Hw.TrgCh],stS.RecSize,1:Hw.RecCh);
    
    % display data
    if all([ITDix ILDix]>0) && (Time-LastTime) > stS.DisplayTime
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
        
        Data(1:size(Avg,1),4)        = Avg(:,BinIdx,ILDix)-(L+R);
        Data(1:size(Avg,1),9)        = L+R;
        
        Data(:,5:6) = Mic(:,1:2,BinIdx,ILDix);
        Data(:,7:8) = Mic(:,3:4,BinIdx,ILDix);
        [bRunning,ITDix,ILDix] = OnlineABR(sDisplayCallback,stS,Data,TimeOffset);
        LastTime = Time;
        
    end
    
    % timekeeping
    if counter > 0
        PTime = Time;
        Time = toc;
        Delta = (Time-PTime) - AvgPeriod;
        AvgPeriod = AvgPeriod + Delta/counter;
        VarPeriod = VarPeriod + Delta * ((Time-PTime) - AvgPeriod);
    end
    
    
end


if playrec('isInitialised')
    playrec('reset')
end


%% display final result
BinIdx   = ITDix+2;
stS.Msg   = sprintf('Epochs: %1.0f\nLeft: %1.0f\nRight: %1.0f\nBin.: %1.0f\nAvg. Period: %5.2f +/- %5.2f ms\nMax: %1.3f\nStd: %1.3f\nITD: %1.0f µs\nILD: %1.1f dB',...
    counter,AvgC(LeftIdx,ILDix),AvgC(RightIdx,ILDix),AvgC(BinIdx,ILDix),...
    AvgPeriod/1e-3,sqrt(VarPeriod/counter)/1e-3,mx,sqrt(max(max(Var(:,[LeftIdx RightIdx ITDix],ILDix)).'./AvgC([LeftIdx RightIdx ITDix],ILDix))),...
    St.ITD(ITDix)/1e-6,St.ILD(ILDix));
Data(1:size(Avg,1),LeftIdx) = Avg(:,LeftIdx      ,ILDix);
Data(1:size(Avg,1),RightIdx) = Avg(:,RightIdx      ,ILDix);
Data(1:size(Avg,1),3) = Avg(:,BinIdx,ILDix);
L = real(ifft(fft(Avg(:,LeftIdx ,ILDix)).*exp(-1i*2*pi*f*(+St.ITD(ITDix)/2))));
R = real(ifft(fft(Avg(:,RightIdx,ILDix)).*exp(-1i*2*pi*f*(-St.ITD(ITDix)/2))));
Data(1:size(Avg,1),4)   = Avg(:,BinIdx,ILDix)-(L+R);
Data(:,5:6) = Mic(:,1:2,BinIdx,ILDix);
Data(:,7:8) = Mic(:,3:4,BinIdx,ILDix);
[bRunning,ITDix,ILDix] = OnlineABR(sDisplayCallback,stS,Data,TimeOffset);





%% clean up

Conditions(all(isnan(Conditions),2),:) = [];

if fid > 0
    fclose(fid);
    save([filename '.mat'],'Conditions','AvgC','Avg','MicC','Mic','St','Hw','Rc');
end

stS.Stimulus  = St;
stS.Hardware  = Hw;
stS.Recording = Rc;
OnlineABR(sFinishedCallback,stS);


