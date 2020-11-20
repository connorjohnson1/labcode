p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_filt.mat')); %to determine the folder of each trial
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,3,1);

%
% This is to extract the activity from ALL cells in the sociability
% trials using different approach lengths. 
%
%%%%
%%%% PLEASE CHECK LINES 48-55 TO ENSURE YOU ARE RUNNING THE CORRECT
%%%% FUNCTION WITH THE CORRECT APPROACH TIME (t)
%%%%
%
%

for i = 1:numExps
    %load all files
    load(fullfile(files(i).folder,'cell_events_filt.mat'));
    load(fullfile(files(i).folder,'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cuplocation.mat'));
    
    %put familiar cup always in first column    
    if cuplocation(1) == 1
         interactions2 = interactions;
         interactions2(:,2) = interactions(:,3);
         interactions2(:,3) = interactions(:,2);
         interactions = interactions2;
    elseif cuplocation(2) == 1
           
    end
    
    %rename cell_events_filt
    cell_events = cell_events_filt; 
    
    %get trial name
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
    %run behaviors
    for ii = 2:4
        if ii == 4
            [population_freq,cell_freq] = get_avg_freq(cell_events_filt,timestamp);
            final_results{i,ii} = population_freq;
        else
            behavior = interactions(:,ii);

            if sum(interactions) > 0   
                %Normal frame-match (frequency during interactions)
                [freq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, cell_events, timestamp);
                %Frame-Match +t seconds (t0 = interaction start) t0->
                %[freq, startstopframes, totaltime] = framematch_mscam_behavecam_approach(3, behavior, cell_events, timestamp);
                %Frame-Match -t seconds (t0 = interaction start) (t0-t)->t0
                %[freq, startstopframes, totaltime] = framematch_mscam_behavecam_neg_approach(3, behavior, cell_events, timestamp);
                %Frame-Match +/-t seconds (t0 = interaction start) (t0-t)->(t0+t)
                %[freq, startstopframes, totaltime] = framematch_mscam_behavecam_posneg_approach(3, behavior, cell_events, timestamp);
            else
                freq = [];
            end

                final_results{i,ii} = mean(freq);
        end
    end
   

end