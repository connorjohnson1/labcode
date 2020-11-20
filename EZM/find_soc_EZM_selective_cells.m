p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\Registration\EZM_Sociability');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events.mat'));
files = is_split(files);

numExps = length(files);
final_results = cell(numExps,2,1);

%Connor Johnson 10/16/20 ACM Lab Boston University
%
%The purpose of this code is to extract the cells that encode only one
%condition from our EZM and Day 1 Sociability registered data

for i = 1:numExps
    
    %Load files from the EZM Registered Data (Post auROC)
    load(fullfile(files(i).folder, 'idx_open.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    idx_open = idx;
    load(fullfile(files(i).folder, 'idx_closed.mat'));
    load(fullfile(files(i).folder, 'zscored_cell.mat'));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    EZM_timestamp = timestamp;
    idx_closed = idx;
    EZM_int = interactions;
    EZM_zscore = zscored_cell;
    %Find registered Sociability folder
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(9:11));
    final_results(i,1) = currentfile;
    file_delim{8} = 'Sociability';
    soc_file = string(join(file_delim,'\'));
    
    %Load files from the EZM Registered Data (Post auROC)
    load(fullfile(soc_file, 'idx_littermate.mat'));
    idx_fam = idx;
    load(fullfile(soc_file, 'idx_empty.mat'));
    load(fullfile(soc_file, 'zscored_cell.mat'));
    load(fullfile(soc_file, 'obj_interactions.mat'));
    load(fullfile(soc_file, 'timestamp.mat'));
    load(fullfile(soc_file, 'cuplocation.mat'));
    idx_empty = idx;
    
    closed_fam = intersect(idx_closed, idx_fam);
    open_fam = intersect(idx_open, idx_fam);
    final_results{i,1} = idx_empty;
    final_results{i,2} = idx_fam;
    
    %if sum(open_fam) > 0
        %for EZM
        EZM_zscore = EZM_zscore(:,13);
        [msbins, behbins] = ROC_bin(100,EZM_timestamp);
        behavior = EZM_int(:,2);
        [binned_behavior, binned_raw] = ROC_binary_bins(behbins, msbins, behavior, EZM_zscore);
        [AUROC, TPR, FPR] = get_ROC(binned_raw, binned_behavior);
        final_results{i,3} = AUROC;
        
        if cuplocation(1) == 1;
            interactions2 = interactions;
            interactions2(:,2) = interactions(:,3);
            interactions2(:,3) = interactions(:,2);
            interactions = interactions2;
        elseif cuplocation(2) == 1;
               interactions = interactions;
        end
        
        zscored_cell_filt = zscored_cell(:,13);
        [msbins, behbins] = ROC_bin(100,timestamp);
        behavior = interactions(:,3);
        [binned_behavior, binned_raw] = ROC_binary_bins(behbins, msbins, behavior, zscored_cell_filt);
        [AUROC, TPR, FPR] = get_ROC(binned_raw, binned_behavior);
        final_results{i,4} = AUROC;
    %end
    
    
    
    
    
end