p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','obj_interactions.mat'));
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,4,1);


for i = 1:numExps
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'startframe.mat'));
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(8:10));
    final_results(i,1) = currentfile;
    
   for ii = [2,3,8]
       behavior = interactions(:,ii);
       if sum(behavior) == 0
       final_results{i,ii} = [];
       else
       
       [percent_time, seconds] = behavior_times(behavior, startframe, timestamp);
       final_results{i,ii} = percent_time*100;
           if ii == 8
               final_results{i,4} = percent_time*100;
               final_results{i,5} = size(seconds,1);
           end
       end
   end
end