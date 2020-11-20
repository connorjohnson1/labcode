p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_filt.mat')); %to determine the folder of each trial
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,3,1);

for i = 1:numExps
   

    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    load(fullfile(files(i).folder, 'timestamp.mat'));

    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    count = 1;
    for ii = [2,3]
    behavior = interactions(:,ii);
    [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, cell_events_filt, timestamp);

    final_results{i,ii} = mean(cellfreq);
    end

end