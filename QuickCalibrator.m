function [vfFullImpulseResponse] = QuickCalibrator(sSwitchSetting,sExpName,varargin)

max_filter_gain = 10;
    
if ~exist('sExpName','var') || isempty(sExpName)
    sExpName = '';
end

if ~exist('sSwitchSetting','var') || isempty(sSwitchSetting)
    error('please use "low" or "-10", "mid" or "+4", and "high" or "Hi"');
end


nBufferLen = 8192;
csPlotColorList = {'k','b','r','g'};

%% get system settings from file
if 2 ~= exist('system_settings')
    error('please rename the file "system_settings_template.m" in the main exp_toolbox folder to "system_settings.m", and change settings where necessary');
end
stS = system_settings('quickcalibrator');

fChirpAmp = stS.fChirpAmp;             
fCalibrationSinusAmp = stS.fCalibrationSinusAmp;  
fCalibrationFrequency = stS.fCalibrationFrequency;
if length(varargin) >= 2 && strcmpi(varargin{2},'cross')
    mfOutInChannelList = stS.mfCrossChannelList;         
    sExpName = [sExpName '_crosstalk'];
else
    mfOutInChannelList = stS.mfOutInChannelList;         
end
vfExpFrequencyRange = stS.vfExpFrequencyRange;       
nEqualFilterOrder = stS.nEqualFilterOrder;           
nSamplingFrequency = stS.nSamplingFrequency;
fSweepStartFrequency = stS.fSweepStartFrequency;
fSweepRate = stS.fSweepRate;  
if length(varargin) >= 1 && ~isempty(varargin{1}) 
    nRepeats = varargin{1};
else
    nRepeats = stS.nRepeats;
end
sDeviceCode = stS.sDeviceCode;
sHostAPI = stS.sHostAPI;

if isfield(stS,'sFilterType')
    sFilterType = stS.sFilterType;
else
    sFilterType = 'minphase';
end

idx = find(strcmpi(sSwitchSetting,stS.MicrophoneCal(:,1)));
if isempty(idx)
    error('please use one of the following input settings: %s',sprintf('%s/',stS.MicrophoneCal{:,1}));
else
    fMicrophoneSensLevels = stS.MicrophoneCal{idx,2};
    switch sSwitchSetting
        case 'em23046'
            MicFilter = stS.MicFilter;
        case 'er-7c_ma3_40'
            MicFilter(:,4:5) = stS.MicFilter(:,[6 6]);
        otherwise
            MicFilter(4097,1:max(stS.mfOutInChannelList(:,2))+1) = 0;
            MicFilter(1,1:max(stS.mfOutInChannelList(:,2))+1) = 1;
    end
end


%% initialize

if playrec('isInitialised')
    playrec('reset');
end

vstSoundDevices = playrec('getDevices');
stUsedDevice = vstSoundDevices(cellfun(@(x)~isempty(strfind(x,sDeviceCode)),{vstSoundDevices.name}));
stUsedDevice = stUsedDevice(cellfun(@(x)~isempty(strfind(x,sHostAPI)),{stUsedDevice.hostAPI}));
if isempty(stUsedDevice)
    error('RME card not found');
end
if length(stUsedDevice) > 1
    stUsedDevice = stUsedDevice(strcmp({stUsedDevice.name},sDeviceCode));
end
if max(mfOutInChannelList(:,1)) > stUsedDevice.outputChans
    error('output channel number mismatch');
end
if max(mfOutInChannelList(:,1)) > stUsedDevice.inputChans
    error('input channel number mismatch');
end

% playrec('init',nSamplingFrequency,stUsedDevice.deviceID,stUsedDevice.deviceID,max(mfOutInChannelList(:,1))+1,max(mfOutInChannelList(:,2))+1,nBufferLen);
playrec('init',nSamplingFrequency,stUsedDevice.deviceID,stUsedDevice.deviceID,max(mfOutInChannelList(:,1))+1,max(mfOutInChannelList(:,2))+1);

fChirpDuration = log(nSamplingFrequency/2/fSweepStartFrequency)/log(2^fSweepRate);
vfChirpSignal = fChirpAmp           *[zeros(nSamplingFrequency/10,1);...
                                      sin(2*pi*fSweepStartFrequency/log(2^fSweepRate)*(2.^(fSweepRate*(0:round(fChirpDuration*nSamplingFrequency)-1).'/nSamplingFrequency)-1));...
                                      zeros(nSamplingFrequency/10,1)];
vfSinusSignal = fCalibrationSinusAmp*[zeros(nSamplingFrequency/10,1);...
                                      sin(2*pi*fCalibrationFrequency*(0:3*nSamplingFrequency-1).'/nSamplingFrequency);...
                                      zeros(nSamplingFrequency/10,1)];
bBP = fir1(1024,fCalibrationFrequency*2.^([-1 1]*1/6)/nSamplingFrequency*2);


nPreLength = round(2e-3*nSamplingFrequency);
nCutLength = 2^nextpow2(10e-3*nSamplingFrequency);
vfFrequencyAxis = (0:nCutLength-1).'/nCutLength*nSamplingFrequency;
vfFrequencyAxis(vfFrequencyAxis>=nSamplingFrequency/2) = vfFrequencyAxis(vfFrequencyAxis>=nSamplingFrequency/2) - nSamplingFrequency;


for nChannelIdx = 1:size(mfOutInChannelList,1)
    
    if length(fMicrophoneSensLevels) > mfOutInChannelList(nChannelIdx,2)+1
        fMicrophoneSensLevel = fMicrophoneSensLevels(mfOutInChannelList(nChannelIdx,2)+1);
    else
        fMicrophoneSensLevel = fMicrophoneSensLevels(1);
    end
    fprintf('Microphone Sensitivity for Ch %1.0f: %1.2f\n',mfOutInChannelList(nChannelIdx,2)+1,fMicrophoneSensLevel);
    
    tic
    nRecPage = playrec('playrec',repmat(vfChirpSignal,nRepeats,1),mfOutInChannelList(nChannelIdx,1)+1,nRepeats*length(vfChirpSignal),mfOutInChannelList(nChannelIdx,2)+1);
    fWaitbarHandle = waitbar(0,'playing chirp signal');
    while ~playrec('isFinished')
        pause(0.1);
        waitbar(toc*nSamplingFrequency/(nRepeats*length(vfChirpSignal)),fWaitbarHandle);
    end
    close(fWaitbarHandle);
    vfRecordedSignal = mean(reshape(double(playrec('getRec',nRecPage)),[],nRepeats),2);
    vfRecordedSignal = fftfilt(MicFilter(:, mfOutInChannelList(nChannelIdx,2)+1), vfRecordedSignal);
    
    vfFullImpulseResponse(:,nChannelIdx) = ifft(fft(vfRecordedSignal)./fft(vfChirpSignal));
    if strcmpi(sSwitchSetting,'probe') || strcmpi(sSwitchSetting,'knowles')
        Tmp = fftfilt(stS.MicFilter(:,mfOutInChannelList(nChannelIdx,2)+1),[vfFullImpulseResponse(:,nChannelIdx);zeros(size(stS.MicFilter,1),1)]);
        vfFullImpulseResponse(:,nChannelIdx) = Tmp(ceil(size(stS.MicFilter,1)/2)+(0:length(vfFullImpulseResponse)-1));
    end
    [dummy,nLatency] = max(abs(hilbert(vfFullImpulseResponse(1:nSamplingFrequency,nChannelIdx))));
    
    if nLatency > 4*nBufferLen
        nLatency = 4*nBufferLen;
    end

    vnDistortionPartIndex = zeros(nCutLength, 3);
    mfSpectra = zeros(nCutLength, 3);
    figure(1)
    subplot(size(mfOutInChannelList,1),1,nChannelIdx);
    cla
    for nDistortionOrder = 1:3;
        vnDistortionPartIndex(:,nDistortionOrder) = nLatency - nPreLength + round(-nSamplingFrequency*(log2(nDistortionOrder)/fSweepRate)) + (1:nCutLength).'; 
        vnDistortionPartIndex(vnDistortionPartIndex(:,nDistortionOrder)<1,nDistortionOrder)=length(vfFullImpulseResponse(:,nChannelIdx))+vnDistortionPartIndex(vnDistortionPartIndex(:,nDistortionOrder)<1,nDistortionOrder);
        mfSpectra(:,nDistortionOrder) = fft(hann(nCutLength).*vfFullImpulseResponse(vnDistortionPartIndex(:,nDistortionOrder),nChannelIdx));
        vbPlotIdx = vfFrequencyAxis < nSamplingFrequency/2/nDistortionOrder;
        semilogx(1/nDistortionOrder*vfFrequencyAxis(vbPlotIdx), db(abs(mfSpectra(vbPlotIdx,nDistortionOrder)))+fMicrophoneSensLevel,'color',csPlotColorList{nDistortionOrder});
        hold on
        grid on
        if nDistortionOrder == 1
%             fspec = (0:length(vfFullImpulseResponse)-1).'/length(vfFullImpulseResponse)*nSamplingFrequency;
%             fspec(fspec>=nSamplingFrequency/2) = fspec(fspec>=nSamplingFrequency/2) - nSamplingFrequency;
%             tmp = real(ifft(fft(vfFullImpulseResponse(:,nChannelIdx)).*(abs(fspec)>=vfExpFrequencyRange(1)&abs(fspec)<=vfExpFrequencyRange(2))));
%             vfShortIR = tmp(vnDistortionPartIndex(:,nDistortionOrder),nChannelIdx);
            vfShortIR = vfFullImpulseResponse(vnDistortionPartIndex(:,nDistortionOrder),nChannelIdx);
        end
    end
    legend({'linear response','1st order harmonic','2nd order harmonic'},'location','northwest');
    drawnow;

    switch sFilterType
        case 'linear'
            vfFilterAmplitudes = 1./abs(mfSpectra(:,1));
            vfFilterAmplitudes = vfFilterAmplitudes/max(vfFilterAmplitudes(vfFrequencyAxis>vfExpFrequencyRange(1)&vfFrequencyAxis<vfExpFrequencyRange(2)));  
            % new 2013-06-18
            vfFilterAmplitudes = vfFilterAmplitudes / interp1(vfFrequencyAxis,vfFilterAmplitudes,fCalibrationFrequency);
            
            % limit spectrum to maximal filter gain
            vfFilterAmplitudes = min(vfFilterAmplitudes, max_filter_gain);
            
            vfFilterAmplitudes(abs(vfFrequencyAxis)<=vfExpFrequencyRange(1)|abs(vfFrequencyAxis)>=vfExpFrequencyRange(2)) = 1;
            vfFilterAmplitudes(isnan(vfFilterAmplitudes)|isinf(vfFilterAmplitudes)) = 1;
            mfFilterCoeffs(:,nChannelIdx) = fir2(nEqualFilterOrder,vfFrequencyAxis(vfFrequencyAxis<=nSamplingFrequency/2)/nSamplingFrequency*2,vfFilterAmplitudes(vfFrequencyAxis<=nSamplingFrequency/2));
            % mfOldFilterCoeffs(:,nChannelIdx) = fir2(nEqualFilterOrder,vfFrequencyAxis(vfFrequencyAxis<=nSamplingFrequency/2)/nSamplingFrequency*2,vfFilterAmplitudes(vfFrequencyAxis<=nSamplingFrequency/2));
        case 'minphase'
            % invert spectrum
            vfFilterAmplitudes = 1./abs(mfSpectra(:,1));
            
            % normalize spectrum
            vfFilterAmplitudes = vfFilterAmplitudes / interp1(vfFrequencyAxis,vfFilterAmplitudes,fCalibrationFrequency);

            % limit spectrum to maximal filter gain
            vfFilterAmplitudes = min(vfFilterAmplitudes, max_filter_gain);

            % set spectrum to meaningful values outside frequency limits
            vfFilterAmplitudes(abs(vfFrequencyAxis)<=vfExpFrequencyRange(1)) = vfFilterAmplitudes(find(vfFrequencyAxis>vfExpFrequencyRange(1), 1, 'first'));
            vfFilterAmplitudes(abs(vfFrequencyAxis)>=vfExpFrequencyRange(2)) = vfFilterAmplitudes(find(vfFrequencyAxis<vfExpFrequencyRange(2), 1, 'last'));
            vfFilterAmplitudes(isnan(vfFilterAmplitudes)|isinf(vfFilterAmplitudes)) = 0;
            
            % calculate phases for minimum phase filter
            phase = ifftshift(imag(hilbert(log(abs(fftshift(vfFilterAmplitudes))))));
            mfFilterCoeffs(:,nChannelIdx) = real(ifft(vfFilterAmplitudes .* exp(-1i*phase)));
        case 'autoregressive'
            mfFilterCoeffs(:,nChannelIdx) = arburg(vfShortIR,nEqualFilterOrder);
            [H,F] = freqz(mfFilterCoeffs(:,nChannelIdx),1,2^16,nSamplingFrequency);
            mfFilterCoeffs(:,nChannelIdx) = mfFilterCoeffs(:,nChannelIdx)/interp1(F,abs(H),fCalibrationFrequency);
            
    end
    
    nRecPage = playrec('playrec',vfSinusSignal,mfOutInChannelList(nChannelIdx,1)+1,length(vfSinusSignal),mfOutInChannelList(nChannelIdx,2)+1);
    fWaitbarHandle = waitbar(0,'playing sine tone');
    while ~playrec('isFinished')
        pause(0.1);
        waitbar(toc*nSamplingFrequency/length(vfChirpSignal),fWaitbarHandle);
    end
    close(fWaitbarHandle);
    vfRecordedSignal = playrec('getRec',nRecPage);
    figure(2)
    subplot(size(mfOutInChannelList,1),2,(nChannelIdx-1)*2+1);
    plot(vfRecordedSignal);
    vfRecordedSignal = fftfilt(bBP,[double(vfRecordedSignal);zeros(1024,size(vfRecordedSignal,2))]);
    subplot(size(mfOutInChannelList,1),2,(nChannelIdx-1)*2+2);
    plot(vfRecordedSignal);
    
    nStartSample = find(abs(vfRecordedSignal)>std(vfRecordedSignal),1,'first');
    nStopSample  = find(abs(vfRecordedSignal)>std(vfRecordedSignal),1,'last');
    
        
    vfMaxSPL(:,nChannelIdx) = db(std(vfRecordedSignal(nStartSample:nStopSample),1)/std(vfSinusSignal(nSamplingFrequency/10+1:end-nSamplingFrequency/10),1)) + fMicrophoneSensLevel;
    
    title(sprintf('output channel %u, input channel %u',mfOutInChannelList(nChannelIdx,:)));

end

save(sprintf('EqFiltCoeff_%s_%s.mat',sExpName,datestr(now,'yyyy-mm-dd')),'mfFilterCoeffs','nSamplingFrequency','mfOutInChannelList','vfMaxSPL','fCalibrationFrequency','fMicrophoneSensLevels');
%mfFilterCoeffs = mfOldFilterCoeffs;
%save(sprintf('EqFiltCoeff_%s_%s_DONOTUSEFORABR.mat',sExpName,datestr(now,'yyyy-mm-dd')),'mfFilterCoeffs','nSamplingFrequency','mfOutInChannelList','vfMaxSPL','fCalibrationFrequency','fMicrophoneSensLevels');
save(sprintf('EqImpResp_%s_%s.mat',sExpName,datestr(now,'yyyy-mm-dd')),'vfFullImpulseResponse','nSamplingFrequency','mfOutInChannelList','vfMaxSPL','fCalibrationFrequency','fMicrophoneSensLevels');

disp('The maximal output levels are:')
for nChannelIdx = 1:size(mfOutInChannelList,1)
    disp(sprintf('output channel: %u, maximum SPL: %5.1f',mfOutInChannelList(nChannelIdx,1),vfMaxSPL(nChannelIdx)));
end

playrec('reset');

