function data_viewer(datafile)

scale = 1.25;
% load average data file from disk
load(datafile)
if strcmp(St.PresentationType, 'simple binaural')
    Avg = Avg(:, 1:end-2, :);
    AvgC = AvgC(:, 1:end-2, :);
    Mic = Mic(:, :, 1:end-2, :);
    MicC = MicC(:, :, 1:end-2, :);
end

n_cond = numel(Avg)/size(Avg,1);
mx_avg = max(0.5, max(abs(Avg(:))));
mx_mic = max(abs(Mic(:)));

% prepare ABR band pass filter
flt = fir1(4096,[300 3000]/St.Fs*2);
% flt = fir1(4096,[150 5000]/St.Fs*2);
flt = 1;


sz = size(Avg);
Avg = fftfilt(flt, [Avg(:,:);zeros(length(flt),n_cond)]);
Avg = Avg(round(length(flt)/2)+(1:sz(1)),:);
Avg = reshape(Avg, sz);

Mic = Mic(:,1:2,:,:,:);

[~,s0] = max(abs(Mic));
s0 = mode(s0(:));
t = ((0:size(Mic,1)-1).'-s0)/48000/1e-3;

snr_factor = 3;
% noiselevel = snr_factor*std(Avg(:,:),1);
% noiselevel = snr_factor*std(Avg(t<0,:),1);
noiselevel = snr_factor*std(Avg(t<0|t>8,:),1);
% noiselevel = snr_factor*median(abs(Avg(:,:)))*0.6745;

plot(t, bsxfun(@plus, squeeze(Mic(:,1,:))/mx_mic*mx_avg/2, (0:n_cond-1)*mx_avg/scale),'linewidth',0.5,'color',[0.5 0.5 1]);
hold on;
plot(t, bsxfun(@plus, squeeze(Mic(:,2,:))/mx_mic*mx_avg/2, (0:n_cond-1)*mx_avg/scale),'linewidth',0.5,'color',[1   0.5 0.5]);
plot(t([1 end]), [1;1]*bsxfun(@plus, noiselevel, (0:n_cond-1)*mx_avg/scale),'color',[1 1 1]*0, 'linestyle', ':');
plot(t([1 end]), [1;1]*bsxfun(@plus, -noiselevel, (0:n_cond-1)*mx_avg/scale),'color',[1 1 1]*0, 'linestyle', ':');
plot(t, bsxfun(@plus, Avg(:,:), (0:n_cond-1)*mx_avg/scale),'linewidth',2);
hold off;
set(gca,'xtick',0:10,'xgrid','on');
xlabel('time re. stimulus / ms')
ylim([-1.5 n_cond+0.5]*mx_avg/1.25)
line([1;1]*-0.5, bsxfun(@plus, [0;1], 0*mx_avg/scale),'linewidth',2, 'color','k');
text(-0.5, -0.1, '1 µV', 'horizontalalignment','center','verticalalignment','top');


if strcmp(St.PresentationType, 'simple binaural')
    set(gca,'ytick',(0:n_cond-1)*mx_avg/scale,'yticklabel',St.StimulusLevelOffsets);
    ylabel('presentation level / dB SPL');
else
    set(gca,'ytick',(0:n_cond-1)*mx_avg/scale,'yticklabel',cat(1,{'L';'R'},strtrim(cellstr(num2str(St.ITD(:)/1e-6)))));
    ylabel('interaural time difference / µs');
end

xlim([-1 11])

[~, filename] = fileparts(datafile);
title(filename,'interpreter','none');

