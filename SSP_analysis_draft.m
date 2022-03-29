[name,path] = uigetfile('*.mat', 'Select SSP file');

datname = regexprep(name, '\..?at$', '.dat');
matname = regexprep(name, '\..?at$', '.mat');

r = ABRRawData(fullfile(path, datname));
load(fullfile(path, matname));

% [z,p,k] = butter(4,[300 1200]/St.Fs*2);
% sos = zp2sos(z,p,k);

flt = fir1(1024, [300 1200]/St.Fs*2);

clist  =  unique(Conditions(:,1));
SSP = nan(19200, length(clist));

for cx  =  1:length(clist)
    list  =  find(Conditions(:,1) == clist(cx));
    X  =  nan(19200, length(list));
    for k  =  1:length(list)
        x = 188*r.get_channel(list(k),1);
        X(:,k) = 0.5*(x(1:19200)+x(19200+(1:19200)));
    end
%     SSP(:,cx)  =  mean(movmean(abs(sosfilt(sos,X)),48),2);
    SSP(:,cx)  =  mean(movmean(abs(fftfilt(flt,X)),48),2);
end

SSP = SSP - mean(SSP(end+(-50*48:0),:));

offset = 2*quantile(SSP, 0.95);
ylims = [-2*max(abs(SSP(:,1))) 1.2*max(abs(SSP(:,end)))];
offset = cumsum([0 offset(1:end-1)]);
ylims(2) = ylims(2) + max(offset);

t = (0:length(SSP)-1).'/fs;
subplot(2,2,[1 3]);
plot((t-1558/fs)/1e-3, SSP-mean(SSP(:,1)) + offset)
xlim([-20 300]);
grid on
set(gca, 'YTick', offset, 'YTickLabel', St.StimulusLevelOffsets)
ylim(ylims);
xlabel('time / ms');
ylabel('level / dB SPL');

L = St.StimulusLevelOffsets;
labels = string(num2str(L(:)));
L(isinf(L)) = -30;

subplot(2,2,2)
plot(L,max(SSP(1558+(0:6*48),:)),'x-');
xlim([min(L) max(L)]);
ylim([0 20])
grid on
xlabel('level / dB SPL');
ylabel('max peak / µV');
set(gca, 'XTick', L, 'XTickLabel', labels);

subplot(2,2,4)
plot(L,mean(SSP(11158+(-50*48:0),:)),'x-');
xlim([min(L) max(L)]);
ylim([0 2])
grid on
xlabel('level / dB SPL');
ylabel('mean plateau / µV');
set(gca, 'XTick', L, 'XTickLabel', labels);
