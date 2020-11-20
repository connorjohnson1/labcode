p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events.mat'));
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,3,1);

for i = 1:numExps
    
    %load files needed for this script
    load(fullfile(files(i).folder, 'zscored_cell_filt.mat'));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'idx_littermate.mat'));
    fam = idx;
    load(fullfile(files(i).folder, 'idx_empty.mat'));
    empty = idx;
    
    %get trial name
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
    %get selective cells' traces
    famcells = zscored_cell_filt(:,fam);
    emptycells = zscored_cell_filt(:,empty);
    
    %get correlation coefficents
    corr_fam = corrcoef(famcells);
    corr_empty = corrcoef(emptycells);
    
    corr_fam(corr_fam == 1) = [];
    corr_fam = reshape(corr_fam,size(fam,2),size(fam,2)-1);
    avg_corr_fam = mean(mean(corr_fam,2));
    final_results{i,2} = avg_corr_fam;
    
    corr_empty(corr_empty == 1) = [];
    corr_empty = reshape(corr_empty,size(empty,2),size(empty,2)-1);
    avg_corr_empty = mean(corr_empty,2);
    final_results{i,3} = avg_corr_empty;
    
    emptyfam_avg_corrs = zeros(size(fam));
    
    for ii = 1:size(fam,2)
        emptyfamcells = [zscored_cell_filt(:,fam(ii)), emptycells];
        corr_emptyfam = corrcoef(emptyfamcells);
        corr_emptyfam = corr_emptyfam(1,:);
        corr_emptyfam(corr_emptyfam == 1) = [];
        avg_corr_emptyfam = mean(corr_emptyfam);
        emptyfam_avg_corrs(ii) = avg_corr_emptyfam;
    end    
    final_results{i,3} = mean(avg_corr_emptyfam);
    
    zscored = zscored_cell_filt;
    x = [fam,empty];
    zscored(:,x) = [];
    neutral_cells = zscored;
    famneut_avg_corrs = zeros(size(fam));
    for ii = 1:size(fam,2)
        famneut_cells = [zscored_cell_filt(:,fam(ii)), neutral_cells];
        corr_famneut = corrcoef(famneut_cells);
        corr_famneut = corr_famneut(1,:);
        corr_famneut(corr_famneut == 1) = [];
        avg_corr_famneut = mean(corr_famneut);
        famneut_avg_corrs(ii) = avg_corr_famneut;
    end 
    final_results{i,4} = mean(famneut_avg_corrs);
    
    
end
