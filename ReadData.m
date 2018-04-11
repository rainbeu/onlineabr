function list = ReadData(filename)

fid = fopen([filename '.dat'],'r');
load([filename '.mat']);

if ~strcmp(fread(fid,7,'char=>char').','ABRdata'); 
    error('not an ABR data file'); 
end

fread(fid,19,'char=>char').'    %  recording date and time

fs = fread(fid,1,'uint32') % sampling frequency
ch = fread(fid,1,'uint16') % number of recorded channels
sz = fread(fid,1,'uint32') % size in samples of one channel buffer
to = fread(fid,1,'double') % stimulus timeoffset within buffer
sc = fread(fid,1,'double') % scaling factor from digital full scale (0-1) to µV

t=(0:sz-1).'/fs;
m= 0; c = 0;

while ~feof(fid); 
    x = reshape(fread(fid,sz*ch,'float32=>double'),ch,[]).'; 
    if ~isempty(x)
        for ch = 1:size(x,2)
            subplot(size(x,2),1,ch);
            plot(t,x(:,ch)); 
            figure(2);
            semilogx((0:4095)/4096*48000,db(fft(x(:,2),4096)));
            figure(1);
        end
        m = m + x;
        c = c + 1;
        subplot(size(x,2),1,1)
        if Conditions(c,1) == 1
            title(sprintf('L   %1.1f dB   %u',St.ILD(Conditions(c,2)),Conditions(c,3)));
        elseif Conditions(c,1) == 2
            title(sprintf('R   %1.1f dB   %u',St.ILD(Conditions(c,2)),Conditions(c,3)));
        else
            title(sprintf('%1.3f µs   %1.1f dB   %u',St.ITD(Conditions(c,1)-2)/1e-6,St.ILD(Conditions(c,2)),Conditions(c,3)));
        end
        if max(abs(x(:,4))) < 0.01
            list{c} = 'L';
        elseif max(abs(x(:,5))) < 0.01
            list{c} = 'R';
        elseif all(max(abs(x(:,4:5))) > 0.01)
            list{c} = 'B';
        else
            list{c} = '?';
        end
%         pause;
    end
end
fclose(fid)
