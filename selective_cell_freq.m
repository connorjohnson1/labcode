p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events.mat'));
files = is_split(files);

numExps = length(files);
final_results = cell(numExps,7,1);

for i = 1:numExps
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(9:11));
    final_results(i,1) = currentfile;
    file_delim{8} = 'Sociability';
    soc_file = string(join(file_delim,'\'));
    load(fullfile(files(i).folder, 'cell_events.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(soc_file, 'idx_empty.mat'));
    %load(fullfile(files(i).folder, 'idx_open.mat'));
    %load(fullfile(files(i).folder, 'idx_closed.mat'));
    %idx_closed_1 = idx;
     idx_cells = cell_events(:,idx);
    
    for ii = 2:4
        if ii ==4
            behavior = ones(size(behavior));
            [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
            final_results{i,ii} = mean(cellfreq);
        else
        behavior = interactions(:,ii);
        [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
        final_results{i,ii} = mean(cellfreq);
        
        end
    end
        
    
    
   % load(fullfile(soc_file, 'idx_familiar.mat'));
   % idx_fam = idx;
   % load(fullfile(soc_file, 'idx_empty.mat'));
   % idx_empty = idx;
    load(fullfile(soc_file, 'obj_interactions.mat'));
    load(fullfile(soc_file, 'timestamp.mat'));
     load(fullfile(soc_file, 'cell_events.mat'));
     load(fullfile(soc_file, 'cuplocation.mat'));
    idx_cells = cell_events(:,idx);
    if cuplocation(1) == 1;
         interactions2 = interactions;
         interactions2(:,2) = interactions(:,3);
         interactions2(:,3) = interactions(:,2);
         interactions = interactions2;
    elseif cuplocation(2) == 1;
            interactions = interactions;
    end
    
    for ii = 2:4
        if ii ==4
            behavior = ones(size(behavior));
            [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
            final_results{i,ii+3} = mean(cellfreq);
        else
            behavior = interactions(:,ii);
            [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
            final_results{i,ii+3} = mean(cellfreq);
        end
    end
    
end