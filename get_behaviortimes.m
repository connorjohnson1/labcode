p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','obj_interactions.mat'));
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,6,1);


for i = 1:numExps
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'startframe.mat'));
    load(fullfile(files(i).folder, 'cuplocation.mat'));
    
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
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
       [percent_time, seconds] = behavior_times(behavior, startframe, timestamp);
       final_results{i,ii} = percent_time;
   end
end