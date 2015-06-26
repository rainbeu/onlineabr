filelist = {
    'datafile_2015-06-26-12-16-39.mat'
    'datafile_2015-06-26-12-18-11.mat'
    'datafile_2015-06-26-12-19-20.mat'
    };

for fx = 1:length(filelist)
    
    % load data file
    load(fullfile('data',filelist{fx}));
    figure(fx)
    
    % Avg = samples x conditions (two empty conditions at the end)
    % Mic = samples x channels x conditions (also two empty conditions at the end)
    % channel 1 is left channel
    
    % get number of stimulus parameter (levels)
    n = size(Avg,2)-2;
    
    % calculate maximum amplitudes for display
    % EEG avg
    maxAvg = max(abs(Avg(:)));
    % mic evg
    maxMic = max(abs(reshape(Mic(:,1,:),[],1)));
    
    % time vector
    time = (0:size(Avg,1)-1).'/St.Fs;
    % start time offset of stimulus (est. at 10% of max amp)
    offset = find(abs(Mic(:,1,end-2))>0.1*max(abs(Mic(:,1,end-2))),1,'first');
    
    
    for k = 1:n
        % EEG average
        subplot(n,2,(k-1)*2+1);
        plot((time-offset/St.Fs)/1e-3,Avg(:,k))
        ylim([-1.1 1.1]*maxAvg);
        title(sprintf('EEG, Level: %1.1f',St.ITD(k)));
        
        % Mic signal average
        subplot(n,2,(k-1)*2+2);
        plot((time-offset/St.Fs)/1e-3,Mic(:,1,k))
        ylim([-1.1 1.1]*maxMic);
        title(sprintf('Mic, Level: %1.1f',St.ITD(k)));
    end
    
    
    
end