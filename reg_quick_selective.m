p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_reg.mat'));
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,3,1);


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
        if cuplocation(1) == 2
             interactions2 = interactions;
             interactions2(:,2) = interactions(:,3);
             interactions2(:,3) = interactions(:,2);
             interactions = interactions2;
        elseif cuplocation(2) == 2

        end
        
        cond1 = interactions(:,2);
        if cuplocation(1) == 2
            cond2 = sum(interactions(:,5:6),2);
        elseif cuplocation(2) == 2
            cond2 = sum(interactions(:,4:5),2);  
        end
        
        [ratio, sel_ind] = cell_select_2cond(cell_events,timestamp,cond1,cond2);
        final_results{i,2} = ratio;
        final_results{i,3} = sel_ind;

end




