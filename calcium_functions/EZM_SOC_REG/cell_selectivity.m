%function [selectivity_info] = cell_selectivity()
close all
clear all
clc
p_folder = uigetdir();
files = dir(fullfile(p_folder,'**','cell_events.mat'));
numExps = length(files);
selective_idx = cell(numExps,1);
ratio = zeros(numExps,2);
file_names = cell(numExps,1);
selectivity_info = cell(numExps,3,1);

for i = 1:numExps

    figure(i)
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cell_events.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'cuplocation.mat'));
    
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    file_names{i} = currentfile;
    name = strrep(char(file_names{i}), ' ', '_');
    
    if cuplocation(1) == 1     
        behavior = interactions(:,4);
    elseif cuplocation(2) == 1
        behavior = interactions(:,6);
        
    end
    
    [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, cell_events, timestamp);
    
    orgfreq = cellfreq;
    shuffled_freq = zeros(1000,size(cell_events,2));
    
    for ii = 1:1000
        cell_events = shake(cell_events,1);
        [cellfreq, startstopframes, totaltime] = framematch_mscam_behavecam(behavior, cell_events, timestamp);
        shuffled_freq(ii,:) = cellfreq;
    end
    mean_shuffle = mean(shuffled_freq);
    std_shuffle = std(shuffled_freq);
    thresh_freq = mean_shuffle + (std_shuffle*2)
    [f, idx] = find(orgfreq > thresh_freq);
    
    if size(f,2) < 0;
        f = 0;
        idx = 0;
        x = [0 100]
        pie(x)
        legend('Non Object Selective Cells')
        title(name)
    else
        
    selective_idx{i} = idx;
    
    selective= size(f,2);
    nonselective = size(cell_events,2) - selective;
    x = [selective/size(cell_events,2) nonselective/size(cell_events,2)]
    ratio(i,:) = x;
    pie(x)
    legend('Object Selective Cells', 'Non Object Selective Cells')
    title(name)
    
    selectivity_info{i,1} = currentfile;
    selectivity_info{i,2} = ratio;
    selectivity_info{i,3} = idx;
    
    end

end

%end
        