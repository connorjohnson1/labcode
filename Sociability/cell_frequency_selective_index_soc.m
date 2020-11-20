p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_reg.mat'));
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,9,1);


for i = 1:numExps
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cell_events_reg.mat'));
    load(fullfile(files(i).folder, 'raw_trace_filt.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'cuplocation.mat'));
    %cell_events = cell_events_filt;
 
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    figure(i)
        
    %if cuplocation(1) == 2 | cuplocation(2) == 2
  
        
    %else

        %put familiar cup always in first column    
        if cuplocation(1) == 1
             interactions2 = interactions;
             interactions2(:,2) = interactions(:,3);
             interactions2(:,3) = interactions(:,2);
             interactions = interactions2;
        elseif cuplocation(2) == 1

        end
        
        cond1 = interactions(:,2);
        if cuplocation(1) == 1
            cond2 = sum(interactions(:,5:6),2);
        elseif cuplocation(2) == 1
            cond2 = sum(interactions(:,4:5),2);  
        end
        
        [ratio, sel_ind] = cell_select_2cond(cell_events,timestamp,cond1,cond2);
        final_results{i,8} = ratio;
        final_results{i,9} = sel_ind;
        cond1_idx = sel_ind.cond1;
        %cond2_idx = sel_ind.cond2;
        %neutral_idx = sel_ind.neutral;
        for ii = 2:7
           if sum(cond1_idx) == 0
               final_results{i,ii} = [];
           else
                behavior = interactions(:,ii);
                idx_cells = cell_events(:,cond1_idx);
                if ii == 2 | ii ==3
                [cell_freq, startstopframes, totaltime] = framematch_mscam_behavecam_approach(3,behavior, idx_cells, timestamp);
                avg_freq = mean(cell_freq);
                final_results{i,ii} = avg_freq;
                elseif ii == 7
                [population_freq,~] = get_avg_freq(idx_cells,timestamp)
                final_results{i,ii} = population_freq;
                else
                [cell_freq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
                avg_freq = mean(cell_freq);
                final_results{i,ii} = avg_freq;
                end
                if ii == 2
                    rasterplot(cell_events, raw_trace_filt, cond1_idx, behavior, timestamp)
                    title(currentfile)
                    xlabel('Time (s)')
                    ylabel('Cell  #')
                end
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


