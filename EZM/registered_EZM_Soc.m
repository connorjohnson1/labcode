p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events.mat'));
files = is_split(files);

numExps = length(files);
final_results = cell(numExps,3,1);

for i = 1:numExps
    
    load(fullfile(files(i).folder, 'idx_headdip.mat'));
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(9:11));
    final_results(i,1) = currentfile;
    file_delim{8} = 'Sociability';
    soc_file = string(join(file_delim,'\'));
    load(fullfile(soc_file, 'timestamp.mat'));
    load(fullfile(soc_file, 'obj_interactions.mat'));
    load(fullfile(soc_file, 'cell_events.mat'));
    load(fullfile(soc_file, 'cuplocation.mat'));
    
    if cuplocation(1) == 1;
         interactions2 = interactions;
         interactions2(:,2) = interactions(:,3);
         interactions2(:,3) = interactions(:,2);
         interactions = interactions2;
    elseif cuplocation(2) == 1;
            interactions = interactions;
    end
    idx_cells = cell_events(:,idx);
    for ii = 2:4
        if ii == 4
            [population_freq,cell_freq] = get_avg_freq(idx_cells,timestamp);
            final_results{i,ii} = population_freq;
        else
        behavior = interactions(:,ii);
        [cellfreq, ~, ~] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
        final_results{i,ii} = mean(cellfreq);
        end
    end
    
    
    
end
