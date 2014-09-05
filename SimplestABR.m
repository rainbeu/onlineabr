load EqFiltCoeff_ABR_mouse_open_short_2013-07-09.mat

stim = mfFilterCoeffs; 
stim = stim/max(abs(stim(:)));
stim(end+1:1025,:) = 0;

fs = nSamplingFrequency;

if playrec('isInitialised')
    playrec('reset')
end
playrec('init',fs,2,2,6,6,0)

clear signal;

t = ((0:4799).'-1171)/fs;
c = 0;
SP = [1 4 5];
flt = fir1(1025,[300 3000]/24000);
    
while true; 
    
    page = playrec('playrec',[bsxfun(@times,stim,[1 1]),[zeros(512,1);1;0;-1;0;1;zeros(1025-512-5,1)]],[1 2 3],4800,1:6); 
    playrec('block',page); 
    
    c = c + 1;
    signal(:,:,c) = double(playrec('getRec',page));
    

    for k = 1:length(SP) 
        subplot(length(SP),1,k);
        if SP(k) == 1
            plot(t-(512/fs),fftfilt(flt,mean(signal(:,SP(k),:),3)),t,mean(signal(:,SP(k),:),3));
        else
            plot(t,mean(signal(:,SP(k),:),3));
        end
        xlim([-0.001 0.015]);
    end;
    drawnow;

end