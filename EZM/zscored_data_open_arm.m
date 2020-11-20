p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events.mat')); %to determine the folder of each trial
files = is_split(files);
numExps = length(files);
hold off
close all

for i = 1:numExps
   

    load(fullfile(files(i).folder, 'obj_interactions.mat'));
   load(fullfile(files(i).folder, 'cuplocation.mat'));
    load(fullfile(files(i).folder, 'zscored_cell_filt.mat'));
    load(fullfile(files(i).folder, 'cell_events.mat'));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'idx_littermate.mat'));
    %idx_center = idx;
    %load(fullfile(files(i).folder, 'idx_center.mat'));
    %idx_periphery = idx;
    
   % x = [idx_center, idx_periphery]
    
   zscored_cell_filt = mean(zscored_cell_filt(:,idx),2);
   cell_events_filt = cell_events;
    if cuplocation(1) == 1
         interactions2 = interactions;
         interactions2(:,2) = interactions(:,3);
         interactions2(:,3) = interactions(:,2);
         interactions = interactions2;
    elseif cuplocation(2) == 1
           
   end
    
    zscored = zscored_cell_filt;
    behavior = interactions(:,3);
    [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, cell_events_filt, timestamp);
    msframes = startstopframes.mscam;
    avg_zscore = mean(zscored_cell_filt,2);
    in_open = zeros(1,size(zscored_cell_filt,1));
    for ii = 1:size(msframes,1)
        in_open(msframes(ii,1):msframes(ii,2)) = max(max(zscored));
    end
    
    
    behavior = interactions(:,2);
    [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, cell_events_filt, timestamp);
    msframes = startstopframes.mscam;
    in_closed = zeros(1,size(zscored_cell_filt,1));
    for ii = 1:size(msframes,1)
        in_closed(msframes(ii,1):msframes(ii,2)) = max(max(zscored));
    end
   
    %avg_zscore = mean(zscored_cell_filt(:,[4,8,13,25,29,37,52,54,60,62,77,89,92]),2);
    for ii = 1:size(zscored,2)
    ii 
    area(in_closed,'LineStyle','none','FaceColor','g');
    alpha(0.25)
    hold on
    area(in_open,'LineStyle','none','FaceColor','r');
    alpha(0.25)
    plot(zscored(:,ii),'Color','#0072BD','LineWidth',1.25);
    xlim([0 12000])
    ylim([-1 max(zscored(:,i))])
    %x = input('Were Ca2+ events properly extracted from this trace?');
    hold off
    end
    
end