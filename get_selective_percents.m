p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','idx_novel.mat'));
files = is_split(files);

numExps = length(files);
final_results = cell(numExps,2,1);

%Connor Johnson 10/16/20 ACM Lab Boston University
%
%The purpose of this code is to extract the cells that encode only one
%condition from our EZM and Day 1 Sociability registered data

for i = 1:numExps
    
    %Load files from the EZM Registered Data (Post auROC)
    load(fullfile(files(i).folder, 'idx_littermate.mat'));
    idx_lit = idx;
    load(fullfile(files(i).folder, 'idx_novel.mat'));
    idx_empty = idx;
    load(fullfile(files(i).folder, 'zscored_cell_filt.mat'));
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
    lit_per = size(idx_lit,2)/size(zscored_cell_filt,2);
    final_results{i,2} = lit_per;
    
    empty_per = size(idx_empty,2)/size(zscored_cell_filt,2);
    final_results{i,3} = empty_per;
end
    
    