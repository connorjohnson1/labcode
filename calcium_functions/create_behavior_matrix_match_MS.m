p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_filt.mat'));
files = is_split(files);

numExps = length(files);
final_results = cell(numExps,7,1);


for i = 1:numExps
    
    %Load files from server
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'obj_interactions_100.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    load(fullfile(files(i).folder, 'raw_trace_filt.mat'));

    raw_trace_filt = raw_trace_filt';
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9),'\')
    final_results(i,1) = currentfile;

    behavior_states = zeros(size(cell_events_filt,1),2);
    
    for ii = 2:3
    
        behavior = interactions(:,ii);
    
        [~, startstopframes, ~] = framematch_mscam_behavecam(behavior, cell_events_filt, timestamp)
    
        for iii = 1:size(startstopframes.mscam,1);
            behavior_states(startstopframes.mscam(iii,1):startstopframes.mscam(iii,2),ii-1) = 1;
        end
            
    
    end
    
    mkdir(fullfile('D:\Users\Connor Johnson\Desktop\Geoff_data',string(currentfile)));
    save(fullfile('D:\Users\Connor Johnson\Desktop\Geoff_data',string(currentfile),'raw_trace'),'raw_trace_filt');
    save(fullfile('D:\Users\Connor Johnson\Desktop\Geoff_data',string(currentfile),'behavior_states'),'behavior_states');
end