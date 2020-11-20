p_folder = uigetdir();
files = dir(fullfile(p_folder,'**','obj_interactions.mat'));
numExps = length(files);
final_results = cell(numExps,8,1);

for i = 1:numExps
    
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    cell_events = cell_events_filt;
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
    for ii = 2:3
        behavior = interactions(:,ii);
        [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, cell_events, timestamp);
        final_results{i,ii} = mean(cellfreq);
    end
    
    for ii = 1:4
        behavior = interactions(:,5) == ii;
        [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, cell_events, timestamp);
        final_results{i,ii+3} = mean(cellfreq);
    end
    
end