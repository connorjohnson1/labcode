function[percent_time, seconds] = behavior_times(behavior, startframe, timestamp)

%CJ ACM Lab 5/9/2020
%
%The purpose of this function is to find the total amount of time an animal
%spent doing a behavior.
%
%INPUTS:
%Behavior = a logical matrix of whether or not an animal is performing a
%behavior. This can be a single column (one behavior) or multiple columns
%(multiple behaviors) if you want to bin different behaviors together.
%
%
%timestamp = the timestamp.mat file for the same trial as your behavior and
%ca2+ data.
%
%OUTPUT
%percent_time = the percent of total trial that the animal spent performing 
%the behavior
%
%seconds = the number of seconds the animal spent performing the behavior
    
    %create timestamps
    btime = timestamp.behavecam(startframe:length(timestamp.behavecam),3);
    behavior = behavior(startframe:length(behavior));
    %find instances of behavior
    soc = find(behavior == 1); 
    if size(soc,1) > 0

        startstop = [];
        startstop = [startstop soc(1)]; %first behavior frame
        
        %find all the *start* and *stop* frames
        for i = 1:length(soc)           
            if i+1 <= length(soc)
                if (soc(i+1) - soc(i)) > 10
                startstop = [startstop soc(i)];
                startstop = [startstop soc(i+1)];
                end
            end
        end
        startstop = [startstop soc(length(soc))]; %last behavior frame 
        startstop = vec2mat(startstop, 2);
        check = startstop(:,1) - startstop(:,2);
        startstop = startstop(check ~= 0,:);
        int_length = (startstop(:,2) - startstop(:,1));
        startstop = startstop(int_length > 20,:);
        
        startstoptimes = startstop;
        %find the timestamps that correlate to the behavior frames
        for i = 1:size(startstop,1)
            startstoptimes(i, 1) = btime(startstop(i,1));
            startstoptimes(i, 2) = btime(startstop(i,2));
        end
        %calculate lenth of behavior since we have the data all out on the
        %table
        totaltime = [];
        for v = 1:size(startstop,1)
            b = diff(startstoptimes(v,:));
            totaltime = [totaltime b];
        end
        
        %find the total time in seconds
        totaltime = totaltime'/1000;
        seconds = sum(totaltime);
        
        %find the total percent time
        percent_time = seconds/(btime(length(btime))/1000);
        seconds = totaltime;

        
    end
        
end
    