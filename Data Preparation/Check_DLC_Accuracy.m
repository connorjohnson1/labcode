p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','DLCcoordinates.csv')); %to determine the folder of each trial
files = is_split(files);
numExps = length(files);
final_results = {numExps, 5};


%control chamber, objmem, openfield
%n = [16,22,37,40];
%Zero Maze
%n = [31, 37, 46, 49];
%sociability, opposite sex, social_memory, empathy
n = [40,46, 61, 64];

%n = [16, 22, 37, 40]
%n = [55, 61, 70, 73]
%no lens open field
%n = [31, 37, 46, 49];


for i = 1:numExps
    load(fullfile(files(i).folder, 'startframe.mat'))
    tempFiles = dir(fullfile(files(i).folder,'DLCcoordinates.csv'));
    tempArray = char(fullfile(tempFiles.folder, 'DLCcoordinates.csv'));
    M=readtable(tempArray, 'HeaderLines', 3);
    M= M{:,:};
    M = M(startframe(1):length(M),:);
    
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    finalresults{i,1} = currentfile;
    
    snout = find(M(:,n(1)) > 0.90);
    snoutacc = (length(snout)/length(M));
     finalresults{i,2} = snoutacc;
    head = find(M(:,n(2)) > 0.90);
    headacc = (length(head)/length(M));
     finalresults{i,3} = headacc;
    centroid = find(M(:,n(3)) > 0.90);
    centroidacc = (length(centroid)/length(M));
     finalresults{i,4} = centroidacc;
    tailbase = find(M(:,n(4)) > 0.90);
    tailacc = (length(tailbase)/length(M));
     finalresults{i,5} = tailacc;
     
end