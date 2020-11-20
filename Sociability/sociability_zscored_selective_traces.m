p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','idx_empty.mat')); %to determine the folder of each trial
files = is_split(files);
numExps = length(files);
hold off
close all

for i = 1:numExps
   

    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'zscored_cell_filt.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cuplocation.mat'));
    
    load(fullfile(files(i).folder, 'idx_littermate.mat'));
    idx_littermate = idx;
    load(fullfile(files(i).folder, 'idx_empty.mat'));
    idx_empty = idx;
    
    x = [idx_littermate,idx_empty];
    
    zscored_cell_filt(:,x) = [];
    
    if cuplocation(1) == 1
         interactions2 = interactions;
         interactions2(:,2) = interactions(:,3);
         interactions2(:,3) = interactions(:,2);
         interactions = interactions2;
    elseif cuplocation(2) == 1
           
    end
    
    zscored = mean(zscored_cell_filt');
    behavior = interactions(:,3);
    [~, startstopframes, ~] = framematch_mscam_behavecam(behavior, cell_events_filt, timestamp);
    msframes = startstopframes.mscam;
    avg_zscore = mean(zscored_cell_filt,2);
    empty_int = zeros(1,size(zscored_cell_filt,1));
    for ii = 1:size(msframes,1)
        empty_int(msframes(ii,1):msframes(ii,2)) = max(zscored);
    end
    
    behavior = interactions(:,2);
    [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, cell_events_filt, timestamp);
    msframes = startstopframes.mscam;
    littermate_int = zeros(1,size(zscored_cell_filt,1));
    for ii = 1:size(msframes,1)
        littermate_int(msframes(ii,1):msframes(ii,2)) = max(zscored);
    end
   
    %avg_zscore = mean(zscored_cell_filt(:,[4,8,13,25,29,37,52,54,60,62,77,89,92]),2);
    area(littermate_int,'LineStyle','none','FaceColor','g');
    alpha(0.25)
    hold on
    area(empty_int,'LineStyle','none','FaceColor','r');
    alpha(0.25)
    plot(zscored,'Color','#0072BD','LineWidth',1.25);
    xlim([0 6500])
    ylim([-1 max(zscored)])
    x = input('Were Ca2+ events properly extracted from this trace?');
    hold off
    
end