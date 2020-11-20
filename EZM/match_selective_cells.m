p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','cell_events.mat'));
files = is_split(files);

numExps = length(files);
final_results = cell(numExps,11,1);

for i = 1:numExps
    
    load(fullfile(files(i).folder, 'idx_open.mat'));
    idx_open = idx;
    load(fullfile(files(i).folder, 'idx_closed.mat'));
    idx_closed = idx;
    %load(fullfile(files(i).folder, 'idx_headdip.mat'));
    %idx_headdip = idx;
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(9:11));
    final_results(i,1) = currentfile;
    file_delim{8} = 'Sociability';
    soc_file = string(join(file_delim,'\'));
    load(fullfile(soc_file, 'idx_littermate.mat'));
    idx_fam = idx;
    load(fullfile(soc_file, 'idx_empty.mat'));
    idx_empty = idx;
    
    %%%%% ORDER OF FINAL RESULTS %%%%%
    % 1. Filename
    % 2. intersect(idx_closed, idx_open)
    % 3. intersect(idx_closed, idx_fam)
    % 4. intersect(idx_closed, idx_empty)
    % 5. intersect(idx_open, idx_fam)
    % 6. intersect(idx_open, idx_empty)
    % 7. intersect(idx_fam, idx_empty)
    % 8. intersect(idx_closed, idx_open, idx_fam)
    % 9. intersect(idx_closed, idx_open, idx_empty)
    % 10. intersect(idx_closed, idx_fam, idx_empty)
    % 11. intersect(idx_open,idx_fam, idx_empty)
    % 12. intersect(idx_open, idx_fam, idx_empty, idx_closed)

 
   final_results{i,2} = intersect(idx_closed, idx_open);
   final_results{i,3} = intersect(idx_closed, idx_fam);
   final_results{i,4} = intersect(idx_closed, idx_empty);
   final_results{i,5} = intersect(idx_open, idx_fam);
   final_results{i,6} = intersect(idx_open, idx_empty);
   final_results{i,7} = intersect(idx_fam, idx_empty);
   final_results{i,8} = intersect(intersect(idx_closed, idx_open), idx_fam);
   final_results{i,9} = intersect(intersect(idx_closed, idx_open), idx_empty);
   final_results{i,10} = intersect(intersect(idx_closed, idx_fam), idx_empty);
   final_results{i,11} = intersect(intersect(idx_open,idx_fam), idx_empty);
   final_results{i,12} = intersect(intersect(intersect(idx_open, idx_fam), idx_empty), idx_closed);
   idx_closed_only = idx_closed
  % final_results{i,13}
end