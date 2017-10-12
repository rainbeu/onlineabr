function data_viewer(datafile)

% load average data file from disk
load(datafile)

n_cond = numel(Avg)/size(Avg,1);
mx_avg = max(abs(Avg(:)));
mx_mic = max(abs(Mic(:)));

% prepare ABR band pass filter
flt = fir1(1024,[300 3000]/St.Fs*2);


sz = size(Avg);
Avg = fftfilt(flt, [Avg(:,:);zeros(length(flt),n_cond)]);
Avg = Avg(round(length(flt)/2)+(1:sz(1)),:);
Avg = reshape(Avg, sz);

Mic = Mic(:,1:2,:,:,:);

[~,s0] = max(abs(Mic));
s0 = mode(s0(:));
t = ((0:size(Mic,1)-1).'-s0)/48000/1e-3;

plot(t, bsxfun(@plus, squeeze(Mic(:,1,:))/mx_mic*mx_avg, (0:n_cond-1)*mx_avg/2), ...
     t, bsxfun(@plus, squeeze(Mic(:,2,:))/mx_mic*mx_avg, (0:n_cond-1)*mx_avg/2),'linewidth',0.5,'color',[0.70 .7 0.7]);
hold on;
plot(t, bsxfun(@plus, Avg(:,:), (0:n_cond-1)*mx_avg/2),'linewidth',2);
hold off;
set(gca,'xtick',0:10,'xgrid','on');
xlabel('time re. stimulus / ms')
