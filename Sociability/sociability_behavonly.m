close all
clear all
clc

%This code is to analyze the DLC output of the Obj Memory and Sociability
%tasks performed for the ACC experiments in the CM lab
%Specifically it will analyze the vector outputs from Alex's Code in the
%obj_interactions.mat file


p_folder = uigetdir();
files = dir(fullfile(p_folder,'**','obj_interactions.mat')); %to determine the folder of each trial
numExps = length(files);
final_results = cell(numExps,6,1);
load('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\Sociability\startframes.mat')
for i = 1:numExps
   
    %Initialize tempArray
    tempArray = [];
    fileArray{i} = tempArray;
    tempBehave = dir(fullfile(files(i).folder,'obj_interactions.mat')); %temporary variable holding the Behavior matrix of current trial
  

    load(fullfile(tempBehave.folder, tempBehave.name));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    interactions(:,7) = timestamp.behavecam(:,3); %add timestamps to the behavior matrix
    interactions(1,7) = 0; %make first frame equal to time 0
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    frame1 = startframes(i);
%%%                                                    %%%
%%% This is to extract the time spent near each object %%%
%%%                                                    %%%

for iii = [2,3,4,5,6]
    
    soc = find(interactions(:,iii) == 1); %find all the frames where the animal is a) interacting or b) in the zone
    activeframes = size(soc);
    
if activeframes(1) >= 1
    startstop = [];
    startstop = [startstop soc(1)]; %my loop does not include the first frame an animal is behaving so I manually added it
    %%%
    %%% This for loop should find all the *start* and *stop* frames of a
    %%% behavior, aka the first frame an animal behaves and then the last
    %%% frame of that specific instance of behavior.
    %%%
    for v = 1:length(soc)           
        if v+1 <= length(soc)
            if (soc(v+1) - soc(v)) > 1
            startstop = [startstop soc(v)];
            startstop = [startstop soc(v+1)];
            end
        end
    end
    %
    %The loop also does not include the last frame, which I have manually added
    %
    startstop = [startstop soc(length(soc))];
    %remember those timestamps we added? Lets put them to use.
    startstop = vec2mat(startstop, 2);
    startstoptimes = startstop;
    x = size(startstop);
    
    for v = 1:x(1)
        startstoptimes(v, 1) = interactions(startstop(v,1),7);
        startstoptimes(v, 2) = interactions(startstop(v,2),7);
    end
    %
    %It is important to know the TOTAL TIME an animal performed a behavior
    %so I am calculating that here in variable 'totaltime'
    %
    totaltime = [];
    for v = 1:x(1)
        b = diff(startstoptimes(v,:));
        totaltime = [totaltime b];
    end

    behavior_spikefreq = [];
    trialtime = ((interactions(length(interactions),7)-(interactions(startframes(i))))/1000)
    
else

    behavior_spikefreq = [];
    totaltime = 0;
end
    if iii == 2
        %Use for Time(s) interact with Obj 1
        %final_results(i,2) = {((sum(totaltime)/1000))};
        %Use for Percent Time interact with Obj 1
        final_results(i,2) = {((sum(totaltime)/1000)/trialtime)*100}; 
    elseif iii == 3
        %Use for Time(s) interact with Obj 2
        %final_results(i,3) = {((sum(totaltime)/1000))};
        %Use for Percent Time interact with Obj 2
        final_results(i,3) = {((sum(totaltime)/1000)/trialtime)*100};
        
    elseif iii == 4
        %Use for Time(s) in Top
        %final_results(i,4) = {((sum(totaltime)/1000))};
        %Use for Percent Time in Top
        final_results(i,4) = {((sum(totaltime)/1000)/trialtime)*100};  
    elseif iii == 5
        %Use for Time(s) in Middle
        %final_results(i,5) = {((sum(totaltime)/1000))};
        %Use for Percent Time in Middle
        final_results(i,5) = {((sum(totaltime)/1000)/trialtime)*100};    
    elseif iii == 6
        %Use for Time(s) in Bottom
        %final_results(i,6) = {((sum(totaltime)/1000))};
        %Use for Percent Time in Bottom
        final_results(i,6) = {((sum(totaltime)/1000)/trialtime)*100};
    end    

end
end