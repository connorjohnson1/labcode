%Find Selective Cells for EZM

p_folder = uigetdir();
files = dir(fullfile(p_folder,'**','obj_interactions.mat'));
numExps = length(files);
final_results = cell(numExps,8,1);

for i = 1:numExps
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cell_events.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;

        cond1 = interactions(:,2);
        cond2 = interactions(:,3);

        
    [ratio, sel_ind] = cell_select_2cond(cell_events,timestamp,cond1,cond2);
    final_results{i,7} = ratio;
    final_results{i,8} = sel_ind;
    %cond1_idx = sel_ind.cond1;
    %cond2_idx = sel_ind.cond2;
    
    neutral_idx = sel_ind.neutral;
    for ii = 2:3
        behavior = interactions(:,ii);
        idx_cells = cell_events(:,neutral_idx);
        [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, idx_cells, timestamp);
        final_results{i,ii} = mean(cellfreq);
                   
  
    end
    
    
end


%%
x = zeros(numExps,3);
for i = 1:numExps
    x(i,:) = final_results{i,7,:};
end

f = mean(x);
