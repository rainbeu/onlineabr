% plot ABR thresholds
% Lena, 08/2017

%%
main_folder = 'data/Baseo2plot';%'150108_Virto';

main_file = '/home/surgery/OnlineABR';%'../PROJEKTE/ABR/';
print_my_plot = 'yes';

%%
ABR_data_path = fullfile(main_file,main_folder);
filelist = dir(fullfile(ABR_data_path,'*.mat'));

% screen for different conditions
level_vec =[];
frequency_vec = [];
for x = 1:length(filelist)
    data = load(fullfile(ABR_data_path,filelist(x).name));
    level_vec = [level_vec data.St.Level];
    frequency_vec = [frequency_vec data.St.Frequency];
end

% extract number of tested conditions
conds = unique(frequency_vec);

for x = 1:length(conds)
    filelist_sub = filelist(frequency_vec == conds(x));
    level_vec_sub = level_vec(frequency_vec == conds(x));
    figure_handle(x) = plot_ABR_thresholds(filelist_sub,ABR_data_path,level_vec_sub);
end

%% optional:
% summarize plots in one graph
if strcmp(print_my_plot,'yes')
    new_figure_handle = figure;
    set(gcf,'color','w','PaperUnits','centimeters','PaperPosition',[0,0,13,17]);
    set(gcf, 'menubar', 'none');
    
    for x = 1:length(conds)
        tmp_ax = findobj(figure_handle(x),'type','axes');
        
        ax_new = subplot(length(conds),2,x*2-1);
        tmp_copy = allchild(tmp_ax(3));
        if x > 1
            tmp_copy(1) = '';
            tmp_copy(1) = '';
        end
        copyobj(tmp_copy,ax_new);
        xlim([tmp_ax(3).XLim])
        ylim([tmp_ax(3).YLim])
        
        
        ax_new = subplot(length(conds),2,x*2);
        copyobj(allchild(tmp_ax(1)),ax_new);
        xlim([tmp_ax(1).XLim])
        ylim([tmp_ax(1).YLim])
        
        tmp_str = allchild(tmp_ax(2));
        text(-0.35,1.15,tmp_str.String,'units','normalized')
        
    end
    
    print(fullfile(main_file,main_folder),'-r600','-dtiff');
    close all
end