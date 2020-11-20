p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_filt.mat')); %to determine the folder of each trial
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,5,1);

%The purpose of this code is to extract all velocities from a behavior and
%bin them into 20 bins, allowing us to extract AUC for each bin


%velocities = struct('trials',1);
%save velocities from all trials
%for i = 1:numExps
%    load(fullfile(files(i).folder, 'startframe.mat'));
%    load(fullfile(files(i).folder, 'obj_interactions.mat'));
%    interactions(interactions(:,4) <0 ,4) = 0;
%    velocities(i).trials = interactions(startframe:size(interactions,1),4);

%end

%create velocity bins
%all_vel = vertcat(velocities.trials);
max_vel = 1;
min_vel = 0;
binsize = max_vel/10;

vel_bins = min_vel:binsize:max_vel;

for i = 1:numExps
    %load all necessary files
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'zscored_cell_filt.mat'));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'startframe.mat'));
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
    vel = interactions(startframe:size(interactions,1),4);
    
    %load each bin
    for ii = 2:size(vel_bins,2)
        behavior = (interactions(:,4) <= vel_bins(ii) & interactions(:,4) > vel_bins(ii-1));  
        if sum(behavior) == 0
            final_results{i,ii} = [];
        else
            [AUC] = get_AUC_approach(1, zscored_cell_filt, timestamp, behavior);
            final_results{i,ii} = mean(AUC);
        end
    end        
        
end