%% vars = {'logs', 'numFiles', 'path_parts'}
%% clear(vars{:})
p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');


logs = dir(fullfile(p_folder,'**','obj_interactions.mat')); 
coord_idx = true(length(logs),1);
numFiles = length(logs);
if numFiles == 0
    print('No obj_interactions.mat file, cannot run');
end

for i = 1:numFiles
   
            path_parts = regexp(logs(i).folder, '\', 'split');
            fprintf('Filtering matrix %.0f of %.0f: %s %s %s %s\n',i,numFiles,path_parts{6},path_parts{7},path_parts{8}, path_parts{9})
              
            name = path_parts{9};
            
            if (name(length(name)) == '1')
                %%make a new subfolder
                %parent folder specifies the path to the location of
                %new subfolder
                %foldername specifies name of new subfolder
                %note that status returns 0 if directory not created
                %and 1 if directory is created
                parentfolder = fullfile(path_parts{1},path_parts{2},path_parts{3},path_parts{4},path_parts{5},path_parts{6},path_parts{7},path_parts{8});
                foldername = [path_parts{9}(1:9) '_0'];
                mkdir parentfolder foldername;
                status = mkdir(parentfolder,foldername);
                
                %%make new obj_interactions
                %load and define interactions1 from the file previous to split
                %(ex: Trail_001_0)
                load(fullfile(logs(i-1).folder,'obj_interactions.mat'))
                interactions1 = interactions;
                %puts size of interactions1 in variable m (rows) and n (columns) 
                [m,n] = size(interactions1);
                %create first and second interactions matrices
                %load and define interactions2 from the file after split
                %(ex: Trail_001_1)
                load(fullfile(logs(i).folder,'obj_interactions.mat'))
                interactions2 = interactions;
                %puts size of interactions1 in variable m2 (rows) (column
                %number is the same
                [m2,~] = size(interactions2);
                
                %shift frame # down
                interactions2(:,1) = interactions(:,1) + m;
                
                %create new combined matrix (interactions) and save it
                interactions3 = zeros(m+m2,n);
                interactions3(1:m,:) = interactions1;
                interactions3(m+1:end,:) = interactions2;
                fprintf("     Saving obj_interactions\n");
                path = fullfile(parentfolder,foldername,'obj_interactions.mat');
                save(path,'interactions3')
 
                %%Make a new timestamp
                load(fullfile(logs(i-1).folder,'timestamp.mat'))
                timestamp1 = timestamp;
                load(fullfile(logs(i).folder,'timestamp.mat'))
                timestamp2 = timestamp;
                
                %create first and second behavior matrices
                behav1 = timestamp1.behavecam;
                [m,n] = size(behav1);
                behav2 = timestamp2.behavecam;
                [m2,~] = size(behav2);
                
                %shift behav frame # and time down
                behav2(:,2) = behav2(:,2) + m;
                behav2(:,3) = behav2(:,3) + behav1(end,3);
                
                %create combined behavior time
                %should I change to behav3 to instead redefine variable
                %behavecam?
                behav3 = zeros(m+m2,n);
                behav3(1:m,:) = behav1;
                behav3(m+1:end,:) = behav2;
                
                %create first and second mscam matrices
                ms1 = timestamp1.mscam;
                [m,n] = size(ms1);
                ms2 = timestamp2.mscam;
                [m2,~] = size(ms2);
                
                %shift ms frame # and time down
                ms2(:,2) = ms2(:,2) + m;
                ms2(:,3) = ms2(:,3) + ms1(end,3);
                
                %create combined ms time
                ms3 = zeros(m+m2,n);
                ms3(1:m,:) = ms1;
                ms3(m+1:end,:) = ms2;
                
                %put new matrices in a struct and save it
                timestamp3 = struct('behavecam',behav3,'mscam',ms3);
                fprintf("     Saving timestamp\n")
                save(fullfile(parentfolder,foldername,'timestamp.mat'),'timestamp3')
            end
end