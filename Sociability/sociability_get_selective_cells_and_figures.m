p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_filt.mat'));
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,8,1);
       traces = struct('trial',1);

for i = 1:numExps
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    load(fullfile(files(i).folder, 'zscored_cell.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'cuplocation.mat'));
    cell_events = cell_events_filt;
    
    mtime = timestamp.mscam(:,3);
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    %figure(i)

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
        
        [ratio, sel_ind] = cell_select_2cond(cell_events,timestamp,cond1,cond2);
        final_results{i,7} = ratio;
        final_results{i,8} = sel_ind;
        cond1_idx = sel_ind.cond1;
        %cond2_idx = sel_ind.cond2;
        %neutral_idx = sel_ind.neutral;
 
        for ii = 2:3
           if sum(cond1_idx) == 0
               traces(i).trial = [];
           else
                behavior = interactions(:,ii);
                idx_cells = cell_events(:,cond1_idx);
%                if ii == 2 | ii ==3
                [cell_freq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
                msframes = startstopframes.mscam;
                msframes(:,2) = msframes(:,1);
                msframes(:,1) = msframes(:,1) - 400;
                msframes(:,2) = msframes(:,2) + 400;
                msframes = msframes(msframes(:,1) > 0,:);
                msframes = msframes(msframes(:,2) < size(mtime,1),:);
                cells = struct('avg',1);
                for iii = 1:size(msframes,1)
                    x = zscored_cell(msframes(iii,1):msframes(iii,2),cond1_idx);
                    cells(iii).avg = x;
                end
                
                avgca = cells(1).avg;
                for v = 2:size(msframes,1)
                    avgca = avgca + cells(v).avg;
                end
                
                avgca = avgca/size(msframes,1); 
                
            
                    
                if ii == 2    
                avg_freq = mean(cell_freq);
                final_results{i,ii} = avg_freq;
                traces(i).trial = avgca;
                elseif ii == 3
                avg_freq = mean(cell_freq);
                final_results{i,ii} = avg_freq;
                traces(i).noncond = avgca;
                end
           end
        end
        
        
        
end  
 %%   
    avgca = horzcat(traces.trial);
    [x,y] = max(avgca);
    [o,u] = sort(y, 'ascend');
    sortavgca = avgca;
    for v = 1:length(u)
        sortavgca(:,v) = avgca(:,u(v));
    end
    yy = imagesc(-20:0.01:20,1:size(o,2),sortavgca');
    ylabel('Cell #')
    xlabel('Time from interaction (seconds)')
    pl = line([0,0], [size(o,2),0]);
    pl.Color = 'Black';
    pl.LineWidth = 1.5 ;
    
    
    figure(2)
    avgca = horzcat(traces.noncond);
    [x,y] = max(avgca);
    [o,u] = sort(y, 'ascend');
    sortavgca = avgca;
    for v = 1:length(u)
        sortavgca(:,v) = avgca(:,u(v));
    end
    yy = imagesc(-20:0.01:20,1:size(o,2),sortavgca');
    ylabel('Cell #')
    xlabel('Time from interaction (seconds)')
    pl = line([0,0], [size(o,2),0]);
    pl.Color = 'Black';
    pl.LineWidth = 1.5 ;
        

%%
x = zeros(1,3);
for i = 1:17
    %if size(final_results_filt{i,7,:},1) ==0
    %    x(i,:) = 0;
    %else
    x(i,:) = final_results{i,7,:};
    %end
end

f = mean(x);


