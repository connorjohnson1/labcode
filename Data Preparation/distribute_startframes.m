close all
clear all
clc
p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','timestamp.mat'));
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,2,1);
