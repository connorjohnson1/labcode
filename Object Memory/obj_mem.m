close all
clear all
clc


p_folder = uigetdir();
files = dir(fullfile(p_folder,'**','cell_events.mat')); %to determine the folder of each trial
numExps = length(files);
allsocialspikes = [];
allnonsocialspikes = [];
final_results = cell(numExps,9,1);

for i = 1:numExps
   
    %Initialize tempArray
    tempArray = [];
    % Find all msCam videos
    fileArray{i} = tempArray;
    tempFiles = dir(fullfile(files(i).folder,'cell_events_filt.mat')); %temporary variable holding the Ca traces of the current trial
    tempBehave = dir(fullfile(files(i).folder,'obj_interactions.mat')); %temporary variable holding the Behavior matrix of current trial
    load(fullfile(tempFiles.folder, tempFiles.name));
    load(fullfile(tempBehave.folder, tempBehave.name));
    load(fullfile(files(i).folder, 'timestamp.mat'));
    cell_events = cell_events_filt;
    
    cell_events = cell_events > 0;
    a = size(cell_events);
    totalpeaks = sum(cell_events')';%Here I wanted to sum all the Ca spikes that happen within each frame, to get a grand total of the population
    totalpeaks(:,2) = 1:a(1);
    totalpeaks(:,3) = timestamp.mscam(:,3);
    totalpeaks(1,3) = 0;
    interactions(:,7) = timestamp.behavecam(:,3); %add timestamps to the behavior matrix
    interactions(1,7) = 0; %make first frame equal to time 0
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
%%%                                                                           %%%
%%% This is to extract the data of interactions with cups or objects behavior %%%
%%%                                                                           %%%
for iii = [2,3,4,5,6]
    soc = find(interactions(:,iii) == 1); %find all the frames where the animal 
    sss = size(soc);
if sss(1) >= 1
    y = size(cell_events);
    totalcells = (y(2));
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
    %
    %This loop will find the timestamps equivalent to each behavior frame
    %This is what we will use to match the behavior matrix to the Ca2+ matrix
    %
    
    %%%%% Edit to look at activity in 3 second window after interaction
    %%%%% with object
    startstop = vec2mat(startstop, 2);
    
%    if iii == 2 || iii == 3
%    startstop(:,2) = startstop(:,1) + 60;
%    end
    
%        if startstop(size(startstop,1)- 2,2) > length(interactions)
%        startstop(size(startstop,1) - 2,2) = length(interactions);
%    end
    
    
    
%     if startstop(size(startstop,1)- 1,2) > length(interactions)
%        startstop(size(startstop,1) - 1,2) = length(interactions);
%    end
    
%    if startstop(size(startstop,1),2) > length(interactions)
%        startstop(size(startstop,1),2) = length(interactions);
%    end
    
 
    
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
    spiketime = [];
    spikeframe = [];
    %
    %This for loop matches the behavior matrix times to that of the Ca2+
    %matrix, additionally giving us the frame numbers
    %
    for v = 1:x(1)
        [val,idx] = min(abs(totalpeaks(:,3) - startstoptimes(v,1)));
        spiketime = [spiketime totalpeaks(idx,3)];
        spikeframe = [spikeframe idx];
        [val,idx] = min(abs(totalpeaks(:,3) - startstoptimes(v,2)));
        spiketime = [spiketime totalpeaks(idx,3)];
        spikeframe = [spikeframe idx];
    end
    spiketime = vec2mat(spiketime, 2);
    spikeframe = vec2mat(spikeframe, 2);
    totalspikes = [];
     x = size(spikeframe);
    for v = 1:x(1)
        spikes = sum(totalpeaks(spikeframe(v,1):spikeframe(v,2),1));
        totalspikes = [totalspikes spikes];
    end
    
    behavior_spikefreq = ((sum(totalspikes))/totalcells)/((sum(totaltime))/1000);
%if sum(totaltime)/1000 < 5
%    behavior_spikefreq = [];
%else
%end

else
    behavior_spikefreq = [];
end
    if iii == 2
        final_results(i,2) = {behavior_spikefreq};
    elseif iii == 3
        final_results(i,3) = {behavior_spikefreq};
    elseif iii == 4
        final_results(i,4) = {behavior_spikefreq};
        final_results(i,5) = {((sum(totaltime)/1000)/(interactions(length(interactions),7)/1000))*100};  
    elseif iii == 5
        final_results(i,6) = {behavior_spikefreq};
        final_results(i,7) = {((sum(totaltime)/1000)/(interactions(length(interactions),7)/1000))*100};    
    elseif iii == 6
        final_results(i,8) = {behavior_spikefreq};
        final_results(i,9) = {((sum(totaltime)/1000)/(interactions(length(interactions),7)/1000))*100};
    end    

end
end

allsocialspikes = allsocialspikes';
    allnonsocialspikes = allnonsocialspikes';
    
    meansoc = mean(allsocialspikes);
    meannon = mean(allnonsocialspikes);
