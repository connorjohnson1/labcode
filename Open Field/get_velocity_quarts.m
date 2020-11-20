p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_filt.mat')); %to determine the folder of each trial
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,5,1);

velocities = struct('trials',1)

for i = 1:numExps
    load(fullfile(files(i).folder, 'startframe.mat'));
    load(fullfile(files(i).folder, 'obj_interactions_100_90.mat'));
    velocities(i).trials = interactions(startframe:size(interactions,1),10);

end


all_vel = vertcat(velocities.trials);
quarts = quantile(all_vel,[0.25, 0.5, 0.75, 1]);

Q1 = quarts(1);
Q2 = quarts(2);
Q3 = quarts(3);

for i = 1:numExps
    
    
    load(fullfile(files(i).folder, 'obj_interactions_100_90.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    load(fullfile(files(i).folder, 'zscored_cell_filt.mat'));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'startframe.mat'));

    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
    vel = interactions(:,10);
    
    for v = 1:length(vel)
        if vel(v) < Q1
            vel(v) = 1;
        elseif (Q1 < vel(v)) && (vel(v)< Q2)
            vel(v) = 2;
        elseif (Q2 < vel(v)) && (vel(v) < Q3)
            vel(v) = 3;
        elseif vel(v) > Q3
            vel(v) = 4;
        end
    end
    
    for v = 1:4
        behavior = vel == v;
        %behavior(temp_q) = 1;
        %[cellfreq, ~, ~] = framematch_mscam_behavecam(behavior, cell_events_filt, timestamp);
        [AUC] = get_AUC_approach(1, zscored_cell_filt, timestamp, behavior);
        final_results{i,v+1} = mean(AUC);
    end
   
end
