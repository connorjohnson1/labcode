close all
clear all
clc

%The Purpose of this script is to extract the timestamp data from the 
%Timestamp.Dat file created with every recording in the UCLA Software
%Connor Johnson ACM Lab 1/2/2020

p_folder = uigetdir();
files = dir(fullfile(p_folder,'**','timestamp.dat')); %to select directory from which .dat files will be pulled
numExps = length(files);

MeanTimeElapsMs = [];
MeanTimeElapsBh = [];
perdiff = [];
mstotalframes = [];
bhtotalframes = [];
mstotaltime = [];
bhtotaltime = [];

%for i = 1:numExps
%    ind = numExps-i+1;
%    isDel = strfind(files(ind).folder,'DLCcoordinate.csv');
%    if ~isempty(isDel)
%        files(ind) = [];
%    end
%end

numExps = length(files);

for i = 1:numExps
    %Initialize tempArray
    tempArray = [];
    % Find all msCam videos
    tempFiles = dir(fullfile(files(i).folder,'timestamp.dat'));
    for ii = 1:length(tempFiles)
        tempArray{ii} = fullfile(tempFiles(ii).folder,tempFiles(ii).name);
        
        
        M=importdata(tempArray{ii}); %% This will create the matrix version
        
        defaultcam = M.data(1,1);
        
        cam1 = M.data(M.data(:,1) == defaultcam,:);
        cam2 = M.data(M.data(:,1) ~= defaultcam,:);
        
        if length(cam1) > length(cam2)
            
            behavecam = cam1;
            mscam = cam2;
            
        else 
            
            behavecam = cam2;
            mscam = cam1;
            
        %MsCam = M.data(M.data(:,1) >= 4,:);     %% of the timestamp.dat files and separate
        %BehaveCam = M.data(M.data(:,1) < 4 ,:); %% them by Behavior or Miniscope
        end
      
        timestamp=struct;
        timestamp.behavecam = behavecam;
        timestamp.mscam = mscam;
        save(fullfile(files(i).folder,'timestamp.mat'),'timestamp')
        mslength = length(mscam);
        msframes = mscam(mslength,2);
        mstime = mscam(mslength,3);
        bhlength = length(behavecam);
        bhframes = behavecam(bhlength,2);
        bhtime = behavecam(bhlength,3);
        
        msframes_est = round(mstime/50);
        bhframes_est = round(bhtime/33.36);
        
        msframesdropped = (msframes_est - msframes);
        bhframesdropped = (bhframes_est - bhframes);
        msframesdroppedperc = (msframesdropped/msframes_est)*100;
        bhframesdroppedperc = (bhframesdropped/bhframes_est)*100;
        
        mstotaltime = [mstotaltime msframesdroppedperc];
        bhtotaltime = [bhtotaltime bhframesdroppedperc];
        
        
        
      
    end
    
end



histogram(mstotaltime,30)
hold on
histogram(bhtotaltime,30)
xlabel('Percent Frames Dropped')
title('Sociability')
legend('MsCam', 'BhCam')
hold off


