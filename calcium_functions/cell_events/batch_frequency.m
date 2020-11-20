close all
clear all
clc
p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events_filt.mat'));
numExps = length(files);
final_results = cell(numExps,2,1);

for i = 1:numExps
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    [population_freq,cell_freq] = avg_freq(cell_events,timestamp);
    final_results{i,2} = population_freq;
  
end
