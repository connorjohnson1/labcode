p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_transients_filt.mat'));
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,8,1);



for i = 1:numExps
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'startframe.mat'));
    load(fullfile(files(i).folder, 'cell_transients_filt.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'cuplocation.mat'));

   
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    %if cuplocation(1) == 0 | cuplocation(2) == 0
    
        
        
    %else
       if cuplocation(1) == 1
             interactions2 = interactions;
             interactions2(:,2) = interactions(:,3);
             interactions2(:,3) = interactions(:,2);
             interactions = interactions2;
        elseif cuplocation(2) == 1

        end
        
        cond1 = interactions(:,2);
        if cuplocation(1) == 0
            cond2 = sum(interactions(:,5:6),2);
        elseif cuplocation(2) == 0
            cond2 = sum(interactions(:,4:5),2);  
        end
        
        [ratio, sel_ind] = cell_select_2cond_AUC(cell_transients_filt,startframe,timestamp,cond1,cond2);
        final_results{i,7} = ratio;
        final_results{i,8} = sel_ind;
        cond1_idx = sel_ind.cond1;
        %cond2_idx = sel_ind.cond2;
        %neutral_idx = sel_ind.neutral;
        if cuplocation(1) == 1;
             interactions2 = interactions;
             interactions2(:,2) = interactions(:,3);
             interactions2(:,3) = interactions(:,2);
             interactions = interactions2;
        elseif cuplocation(2) == 1;
             interactions = interactions;
        end
        
        for ii = 2:6
            behavior = interactions(:,ii);
            if sum(behavior) == 0
                final_results{i,ii} = [];
            else
            idx_cells = cell_events_filt(:,cond1_idx);
            [cell_freq, startstopframes, totaltime] = framematch_mscam_behavecam_approach(3, behavior, idx_cells, timestamp)
            avg_freq = mean(cell_freq);
            final_results{i,ii} = avg_freq;
            end
         
        end
    %end  
    
end


%%
x = zeros(17,3);
for i = 1:17
    %if size(final_results_filt{i,7,:},1) ==0
    %    x(i,:) = 0;
    %else
    x(i,:) = final_results{i,7,:};
    %end
end


f = mean(x);


