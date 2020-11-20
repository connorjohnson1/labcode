%Written by Connor Johnson October 2019. Cruz-Martin Lab Boston University.
%This code is for the analysis of the DLC output of the Obj Memory, 
%Sociability, and Empathy tasks performed for the ACC experiments in the CM lab
%Specifically it will analyze the vector outputs from Alex's Code in the
%obj_interactions.mat file

p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','obj_interactions.mat')); %to determine the folder of each trial
numExps = length(files);
final_results = cell(numExps,3,1);


for i = 1:numExps

    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    %load(fullfile(files(i).folder, 'cuplocation.mat'));
    
    %if cuplocation(1) == 1;
    %     interactions2 = interactions;
    %     interactions2(:,2) = interactions(:,3);
    %     interactions2(:,3) = interactions(:,2);
    %     interactions = interactions2;
    %elseif cuplocation(2) == 1;
    %        interactions = interactions;
    %end
        
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
    btime = timestamp.behavecam(:,3); btime(1) = 0;
    mstime = timestamp.mscam(:,3); mstime(1) = 0;
    
    for ii = 2:3
  
    
        behavior = interactions(1:5400,ii);

        %find instances of behavior
        soc = find(behavior == 1); 
        if size(soc,1) > 0


            startstop = [];
            startstop = [startstop soc(1)]; %first behavior frame

            %find all the *start* and *stop* frames
            for iii = 1:length(soc)           
                if iii+1 <= length(soc)
                    if (soc(iii+1) - soc(iii)) > 10
                    startstop = [startstop soc(iii)];
                    startstop = [startstop soc(iii+1)];
                    end
                end
            end
            startstop = [startstop soc(length(soc))]; %last behavior frame 
            startstop = vec2mat(startstop, 2);
            check = startstop(:,1) - startstop(:,2);
            startstop = startstop(find(check ~= 0),:);
            startstoptimes = startstop;
            %find the timestamps that correlate to the behavior frames
            for iii = 1:size(startstop,1)
                startstoptimes(iii, 1) = btime(startstop(iii,1));
                startstoptimes(iii, 2) = btime(startstop(iii,2));
            end
            %calculate lenth of behavior since we have the data all out on the
            %table
            totaltime = [];
            for v = 1:size(startstop,1)
                b = diff(startstoptimes(v,:));
                totaltime = [totaltime b];
            end
            totaltime = totaltime'/1000;
            totaltime = sum(totaltime);
            %maxtime = max(btime)/1000;
            maxtime = btime(5400)/1000;
            percent_time = (totaltime/maxtime)*100;

            final_results{i,ii} = percent_time;
        end
    end

end