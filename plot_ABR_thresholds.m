function figure_handle = plot_ABR_thresholds(filelist,ABR_data_path,level_vec)
% Avg(Time, ITD(L=1,R=2,Bin=3...), ILD)
% Lena, 08/2017

figure_handle = figure;
set(gcf, 'menubar', 'none'); % none vs. figure

% get number of unique level conditions
[C_level_vec,~,ic_level_vec] = unique(level_vec);

for x = 1:length(C_level_vec)
    
    filelist_sub = filelist(ic_level_vec == x);
    
    % calculate weighted average if one condition was measured more than
    % once
    overall_avg_1 = 0;
    overall_div_1 = 0;
    overall_avg_2 = 0;
    overall_div_2 = 0;
    for y = 1:length(filelist_sub)
        data = load(fullfile(ABR_data_path,filelist_sub(y).name));
        overall_avg_1 = overall_avg_1 + data.Avg(:,1) * data.AvgC(1);
        overall_div_1 = overall_div_1 + data.AvgC(1);
        overall_avg_2 = overall_avg_2 + data.Avg(:,2) * data.AvgC(2);
        overall_div_2 = overall_div_2 + data.AvgC(2);
    end
    overall_avg_1 = overall_avg_1 / overall_div_1;
    overall_avg_2 = overall_avg_2 / overall_div_2;
    
    % plot measures
    subplot(1,2,1)
    plot(((0:length(data.Avg(:,1))-1)./data.St.Fs.*1000)-data.Rc.PreTime.*1000,...
        overall_avg_1+C_level_vec(x),'b'); hold all;
        text((length(data.Avg(:,1))-1)./data.St.Fs.*1000-data.Rc.PreTime.*1000+0.2,...
            overall_avg_1(end,1)+C_level_vec(x),num2str(overall_div_1),'FontSize',6)
    
    subplot(1,2,2)
    plot(((0:length(data.Avg(:,1))-1)./data.St.Fs.*1000)-data.Rc.PreTime.*1000,...
        overall_avg_2+C_level_vec(x),'r'); hold all;
    text((length(data.Avg(:,1))-1)./data.St.Fs.*1000-data.Rc.PreTime.*1000+0.2,...
        overall_avg_2(end,1)+C_level_vec(x),num2str(overall_div_2),'FontSize',6)
    
end

subplot(1,2,1)
text(-0.35,1,sprintf('dB SPL\nnV'),'units','normalized')
text(0.9,-0.08,'ms','units','normalized')
xlim([0 (length(data.Avg(:,1))-1)./data.St.Fs.*1000-data.Rc.PreTime.*1000])
if (min(level_vec) < 25) && (max(level_vec) < 95)
    ylim([min(level_vec)-5 95])
elseif (min(level_vec) >= 25) && (max(level_vec) >= 95)
    ylim([25 max(level_vec)+5])
elseif (min(level_vec) < 25) && (max(level_vec) >= 95)
    ylim([min(level_vec)-5 max(level_vec)+5])
else
    ylim([25 95])
end
box off
    

subplot(1,2,2)
xlim([0 (length(data.Avg(:,2))-1)./data.St.Fs.*1000-data.Rc.PreTime.*1000])
if (min(level_vec) < 25) && (max(level_vec) < 95)
    ylim([min(level_vec)-5 95])
elseif (min(level_vec) >= 25) && (max(level_vec) >= 95)
    ylim([25 max(level_vec)+5])
elseif (min(level_vec) < 25) && (max(level_vec) >= 95)
    ylim([min(level_vec)-5 max(level_vec)+5])
else
    ylim([25 95])
end
box off

if (strcmp(data.St.Type,'click')) || (strcmp(data.St.Type,'chirp'))
    title_str = sprintf('%s',data.St.Type);
else
    title_str = sprintf('%s %d kHz',data.St.Type,data.St.Frequency/1000);
end
suptitle(title_str)

