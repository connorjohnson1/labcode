p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events.mat'));
files = is_split(files);

numExps = length(files);
final_results = cell(numExps,6,1);

parpool(10)
for i = 1:numExps
    
    %Load files from server
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cuplocation.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'cell_events.mat'));
    load(fullfile(files(i).folder, 'zscored_cell.mat'));
     
    %Write File Name in Final Results Matrix
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(9:11));
    final_results(i,1) = currentfile;
    
    if cuplocation(1) == 1;
         interactions2 = interactions;
         interactions2(:,2) = interactions(:,3);
         interactions2(:,3) = interactions(:,2);
         interactions = interactions2;
    elseif cuplocation(2) == 1;
            interactions = interactions;
    end
    
    %bin both the ms and behavior matrices into equal # of frames
    [msbins, behbins] = ROC_bin(100,timestamp);
    
    %Behavior is interactions with Familiar Cup
    behavior = interactions(:,2);
    
    %create values of the matrices based on the bin locations
    [binned_behavior, binned_raw] = ROC_binary_bins(behbins, msbins, behavior, zscored_cell);
    
    %get auROC
    [AUROC, TPR, FPR] = get_ROC(binned_raw, binned_behavior);
    
    %save our original auROC curve values
    auROC_orig = AUROC;
    
    %create an empty matrix for shuffled data
    shuffled_raw = zeros(1000,size(binned_raw,2));
    
    %shuffle the data 1000 times (circular shift)
    rng(1)
    p = randperm(size(binned_raw,1),1000); %generate only once
    parfor ii = 1:1000
        binned_raw_shift = circshift(binned_raw,p(ii),1);
        [AUROC, TPR, FPR] = get_ROC(binned_raw_shift, binned_behavior);
        shuffled_raw(ii,:) = AUROC;
    end

        
    %create 2std threshold
    stdthresh = quantile(shuffled_raw,0.95);
    %find cells whos original auROC is 2std greater than mean shuffled
    %auROC
    selective = auROC_orig > stdthresh;
    %get cell numbers
    idx = find(selective == 1);
    %get percentage
    percent_sel = length(idx)/size(selective,2);
    
    %save cell numbers and percentage
    final_results{i,2} = idx;
    final_results{i,3} = percent_sel*100;
    save(fullfile(files(i).folder,'idx_familiar'),'idx');
    idx_cells = cell_events(:,idx);

     for ii = [2,3,4]
        if ii < 4
            behavior = interactions(:,ii);
            [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
            final_results{i,ii+2} = mean(cellfreq);
        else 
            [population_freq,cell_freq] = get_avg_freq(idx_cells,timestamp);
            final_results{i,ii+2} = population_freq;
        end
    end

end
delete(gcp('nocreate'))
