p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events.mat'));
files = is_split(files);

numExps = length(files);
final_results = cell(numExps,3,1);

%This code is to get the avg AUC +/- 5 seconds of the zscored ca2+ trace 
%before and after the animal enters a certain behavioral condition
%
%Particularly this can be used to import selective cells and look at their
%activity, or simply the entire population activity
%
%10/1/20 Connor Johnson, ACM Lab, Boston Univeristy


for i = 1:numExps
    
    %load files
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'zscored_cell_filt.mat'));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    %load selective cells
    load(fullfile(files(i).folder, 'idx_open.mat'));
    
    %get file name
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
    %change cell idx to only selective cells
    idx_cells = zscored_cell_filt(:,idx);
    
    %get AUC and save in final matrix
    for ii = 2:3
        behavior = interactions(:,ii);
        [AUC] = get_AUC_neg(5, idx_cells, timestamp, behavior);
        final_results{i,ii+2} = mean(AUC);
        [AUC] = get_AUC_approach(5, idx_cells, timestamp, behavior);
        final_results{i,ii} = mean(AUC);
    end
end