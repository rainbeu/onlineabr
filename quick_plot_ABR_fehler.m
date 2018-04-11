function quick_plot_ABR_fehler(datafile)

load(datafile)
%%
flt = fir1(1024,[300 3000]/48000*2);

c = 1;
for k=1:size(Mic(:,:),2);
    if    max(abs(Mic(:,k)))/max(abs(Mic(:))) > 1e-3... 
       && max(abs(Mic(:,k))) > 10*median(abs(Mic(:,k)));
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
plot(((0:size(Avg,1)-1+1024)-512-idx).'/48000/1e-3,bsxfun(@plus,fftfilt(flt,[Avg(:,1:end-2);zeros(1024,size(Avg,2)-2)])*10,St.StimulusLevelOffsets-St.Level));
xlim([-5 15]);
ylim([min(St.StimulusLevelOffsets-St.Level)-10;max(St.StimulusLevelOffsets-St.Level)+10])
line([0;0],[min(St.StimulusLevelOffsets-St.Level)-10;max(St.StimulusLevelOffsets-St.Level)+10], 'color', [0.5 0.5 0.5], 'linestyle', '--');
xlabel('time / ms');
ylabel('Level');
%%
% mic recordings
subplot(1,2,2)
plot(((0:size(Mic,1)-1+1024)-idx).'/48000/1e-3,bsxfun(@plus,[squeeze(Mic(:,1,1:end-2));zeros(1024,size(Mic,3)-2)]*10/max(abs(Mic(:))),St.StimulusLevelOffsets-St.Level));
xlim([-5 15]);
ylim([min(St.StimulusLevelOffsets-St.Level)-10;max(St.StimulusLevelOffsets-St.Level)+10])
xlabel('time / ms');
ylabel('Level');

% FFT of ABR traces
% subplot(1,3,3)
% semilogx(((0:size(Avg,1)-1)).'/size(Avg,1)*48000,bsxfun(@plus,db(abs(fft(Avg(:,1:end-2))))*0.1,St.StimulusLevelOffsets-St.Level));
% xlim([100 10000]);
% ylim([min(St.StimulusLevelOffsets-St.Level)-10;max(St.StimulusLevelOffsets-St.Level)+10])
% xlabel('frequency / Hz');
% ylabel('Level');

