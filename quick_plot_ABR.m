function quick_plot_ABR(datafile)

% load average data file from disk
load(datafile)

% prepare ABR band pass filter
flt = fir1(1024,[300 3000]/St.Fs*2);

% increase time reference accuracy from microphone recordings
idx = round(Rc.PreTime*St.Fs);
Mic = Mic(:, 1:2, :);
[mx,~] = max(abs(Mic(idx:end,:)));
[~,pmx2] = max(mx);
idx = find(abs(Mic(idx:end,pmx2)) > mx/2, 1, 'first') + idx - 1;

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
