function quick_plot_ABR(datafile)

% load average data file from disk
load(datafile)

% prepare ABR band pass filter
flt = fir1(1024,[300 3000]/St.Fs*2);

switch St.Type
    case 'click'
        max_factor = 10;
    case 'chirp'
        max_factor = 8;
    case 'tone'
        max_factor = 5;
        size_mic = size(Mic);
        Mic = reshape(fftfilt(fir1(256,St.Frequency*2.^([-1/2 1/2]*1/10)/St.Fs*2), Mic(:,:)), size_mic);
end
%max_factor=8;
c = 1;
for k=1:size(Mic(:,:),2);
    if    max(abs(Mic(:,k)))/max(abs(Mic(:))) > 1e-3... 
       && max(abs(Mic(:,k))) > max_factor*median(abs(Mic(:,k)));
        tmp=find(Mic(:,k)>0.9*max(Mic(:,k)),1,'first');
        if ~isempty(tmp) && tmp > 1;
            idx(c,1) = tmp;
            c=c+1;
        end
    end
end

idx = median(idx);
%%
figure('units','normalized','position',[0 0 1 1])
% ABR traces
subplot(1,2,1)
plot(((0:size(Avg,1)-1+1024)-512-idx).'/St.Fs/1e-3,bsxfun(@plus,fftfilt(flt,[Avg(:,1:end-2);zeros(1024,size(Avg,2)-2)])*10,St.StimulusLevelOffsets-St.Level));
xlim([-5 15]);
ylim([min(St.StimulusLevelOffsets-St.Level)-10;max(St.StimulusLevelOffsets-St.Level)+10])
line([0;0],[min(St.StimulusLevelOffsets-St.Level)-10;max(St.StimulusLevelOffsets-St.Level)+10], 'color', [0.5 0.5 0.5], 'linestyle', '--');
xlabel('time / ms');
ylabel('Level');
grid on

% mic recordings
subplot(1,2,2)
plot(((0:size(Mic,1)-1+1024)-idx).'/St.Fs/1e-3,bsxfun(@plus,[squeeze(Mic(:,1,1:end-2));zeros(1024,size(Mic,3)-2)]*10/max(abs(Mic(:))),St.StimulusLevelOffsets-St.Level));
hold on
plot(((0:size(Mic,1)-1+1024)-idx).'/St.Fs/1e-3,bsxfun(@plus,[squeeze(Mic(:,2,1:end-2));zeros(1024,size(Mic,3)-2)]*10/max(abs(Mic(:))),St.StimulusLevelOffsets-St.Level));
hold off
xlim([-5 15]);
ylim([min(St.StimulusLevelOffsets-St.Level)-10;max(St.StimulusLevelOffsets-St.Level)+10])
line([0;0],[min(St.StimulusLevelOffsets-St.Level)-10;max(St.StimulusLevelOffsets-St.Level)+10], 'color', [0.5 0.5 0.5], 'linestyle', '--');
xlabel('time / ms');
ylabel('Level');
grid on

% FFT of ABR traces
% subplot(1,3,3)
% semilogx(((0:size(Avg,1)-1)).'/size(Avg,1)*St.Fs,bsxfun(@plus,db(abs(fft(Avg(:,1:end-2))))*0.1,St.StimulusLevelOffsets-St.Level));
% xlim([100 10000]);
% ylim([min(St.StimulusLevelOffsets-St.Level)-10;max(St.StimulusLevelOffsets-St.Level)+10])
% xlabel('frequency / Hz');
% ylabel('Level');

linkaxes(findall(gcf,'type','axes'), 'xy');
