p_folder = uigetdir();
files = dir(fullfile(p_folder,'**','cell_events.mat'));
numExps = length(files);
final_results = cell(numExps,8,1);

for i = 1:numExps
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cell_events.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'cuplocation.mat'));
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
    if cuplocation(1) == 1
        cond1 = interactions(:,4);
        cond2 = sum(interactions(:,5:6),2);
    elseif cuplocation(2) == 1
        cond1 = interactions(:,6);
        cond2 = sum(interactions(:,4:5),2);   
    end
        
    [ratio, sel_ind] = cell_select_2cond(cell_events,timestamp,cond1,cond2);
    final_results{i,7} = ratio;
    final_results{i,8} = sel_ind;
    %cond1_idx = sel_ind.cond1;
    %cond2_idx = sel_ind.cond2;
    neutral_idx = sel_ind.neutral;
    for ii = 2:6
        behavior = interactions(:,ii);
        if sum(behavior) == 0 && cuplocation(1) == 1
            final_results{i,3} = 0;
        elseif sum(behavior) == 0 && cuplocation(2) == 1
            final_results{i,2} = 0;
        else
            idx_cells = cell_events(:,neutral_idx);
            [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
            avg_freq = mean(cellfreq);
            if ii == 2 && cuplocation(1) == 1
                final_results{i,ii} = avg_freq;
            elseif ii == 2 && cuplocation(2) == 1
                final_results{i,3} = avg_freq;
            elseif ii == 3 && cuplocation(1) == 1
                final_results{i,ii} = avg_freq;
            elseif ii == 3 && cuplocation(2) ==1
                final_results{i,2} = avg_freq;
            else 
                final_results{i,ii} = avg_freq;
            end
            
            if cuplocation(1) == 2
                final_results{i,2} = 0;
            elseif cuplocation(2) == 2
                final_results{i,3} = 0;
            end
                   
        end
    end
    
    
end


%%
x = zeros(numExps,3);
for i = 1:numExps
    x(i,:) = final_results{i,7,:};
end

f = mean(x);
