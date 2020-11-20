p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_filt.mat'));
files = is_split(files);

numExps = length(files);
final_results = cell(numExps,7,1);


for i = 1:numExps
    
    %Load files from server
    load(fullfile(files(i).folder, 'timestamp.mat'));
    %load(fullfile(files(i).folder, 'cuplocation.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    load(fullfile(files(i).folder, 'zscored_cell_filt.mat'));
    
    %Get selective cells (Center/Open) always fir
    load(fullfile(files(i).folder, 'idx_center.mat'));
    idx_open = idx;
    load(fullfile(files(i).folder, 'idx_periphery.mat'));
    idx_closed = idx;
    
    f = [idx_open idx_closed];
    x = 1:size(zscored_cell_filt,2);
    x(f) = [];
    
    zscored_cell_filt = zscored_cell_filt(:,x);
    %Write File Name in Final Results Matrix
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    for iiii = 2:3
    behavior = interactions(:,iiii);

    [msbins, behbins] = ROC_bin(5000,timestamp);
    [binned_behavior, ~] = ROC_binary_bins(behbins, msbins, behavior, zscored_cell_filt);
    
    AUC = [];
    for iii = 1:size(zscored_cell_filt,2)
        auc_temp = [];
        for ii = 2:size(binned_behavior,2)
            if binned_behavior(ii) == 1
                g = [msbins(ii-1):msbins(ii)];
                auc = trapz(zscored_cell_filt(g,iii));
                auc_temp = [auc_temp auc];
            end
        end
         AUC = [AUC mean(auc_temp)];
    end
     
    final_results{i,iiii} = mean(AUC);
    end
end
