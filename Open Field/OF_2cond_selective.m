p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_filt.mat'));
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,9,1);


for i = 1:numExps
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    load(fullfile(files(i).folder, 'raw_trace_filt.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    %load(fullfile(files(i).folder, 'cuplocation.mat'));

    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;

    cond1 = interactions(:,3);
    cond2 = interactions(:,2);
    [ratio, sel_ind] = cell_select_2cond(cell_events_filt,timestamp,cond1,cond2);
    final_results{i,3} = ratio(1)*100;
    final_results{i,2} = sel_ind;
    cond1_idx = sel_ind.cond1;
    idx_cells = cell_events_filt(:,cond1_idx);
    count = 3;
    for ii = [2,3,8,9]
        count = count + 1;
        if ii < 9
            behavior = interactions(:,ii);
            [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
            final_results{i,count} = mean(cellfreq);
        else 
            [population_freq,cell_freq] = get_avg_freq(idx_cells,timestamp);
            final_results{i,count} = population_freq;
        end
    end
      
    
end

%%
x = zeros(1,3);
for i = 1:17
    %if size(final_results_filt{i,7,:},1) ==0
    %    x(i,:) = 0;
    %else
    x(i,:) = final_results{i,8,:};
    %end
end

f = mean(x);


