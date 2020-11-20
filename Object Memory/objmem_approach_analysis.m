close all
clear all
clc


p_folder = uigetdir();
files = dir(fullfile(p_folder,'**','raw_trace.mat')); %to determine the folder of each trial
numExps = length(files);
allsocialspikes = [];
allnonsocialspikes = [];
approachtime = 200;
all_traces = cell(numExps,1);

for i = 2:numExps
    figure(i)
    %Initialize tempArray
    tempArray = [];
    % Find all msCam videos
    fileArray{i} = tempArray;
    tempFiles = dir(fullfile(files(i).folder,'raw_trace.mat')); %temporary variable holding the Ca traces of the current trial
    tempBehave = dir(fullfile(files(i).folder,'obj_interactions.mat')); %temporary variable holding the Behavior matrix of current trial
    load(fullfile(tempFiles.folder, tempFiles.name));
    
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'cuplocation.mat'));
    load(fullfile(files(i).folder, 'raw_trace.mat'));
    raw_trace = squeeze(raw_trace)';
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    mstime = timestamp.mscam(:,3);
    mstime(1) = 0;
    behavetime = timestamp.behavecam(:,3);
    behavetime(1) = 0;
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    all_traces(i) = currentfile;
%%%                                                    %%%
%%% This is to extract the data of Object Interactions %%%
%%%                                                    %%%
    if cuplocation(1) == 1
    soc1 = find(interactions(:,3) == 1);%find all the frames where the animal is performing behavior 6
    elseif cuplocation(2) == 1
    soc1 = find(interactions(:,2) == 1);
    %elseif cuplocation(1) == 1
    %soc1 = find(interactions(:,3) == 1);
    %elseif cuplocation(2) == 1
    %soc1 = find(interactions(:,3) == 1);
    end
    soc = sort([soc1']');
    sss = size(soc);
    
    if sss(1) >= 1

        startstop = [];
        startstop = [startstop soc(1)]; %my loop does not include the first frame an animal is behaving so I manually added it
        %%%
        %%% This for loop should find all the *start* and *stop* frames of a
        %%% behavior, aka the first frame an animal behaves and then the last
        %%% frame of that specific instance of behavior.
        %%%
        for v = 1:length(soc)           
            if v+1 <= length(soc)
                if (soc(v+1) - soc(v)) > 5
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
        startstop = vec2mat(startstop, 2);
        startstoptimes = startstop;
        x = size(startstop);
        for v = 1:x(1)
            startstoptimes(v, 1) = behavetime(startstop(v,1));
            startstoptimes(v, 2) = behavetime(startstop(v,2));
        end

        starttimes = [];
        sizestartstop = size(startstop);
        for v = 1:sizestartstop(1)
            starttimes = [starttimes behavetime(startstop(v,1))];
        end

        %
        %This for loop matches the behavior matrix times to that of the Ca2+
        %matrix, additionally giving us the frame numbers
        %   
        catime = [];
        caframe = [];

        for v = 1:length(starttimes)
            [val,idx] = min(abs(mstime - (starttimes(v))));
            catime = [catime mstime(idx)];
            caframe = [caframe idx];   
        end

        caframethresh =[];
        if caframe(1) > approachtime
            caframethresh = [caframethresh caframe(1)];
        end
        for v = 1:(length(caframe)-1)
            if (caframe(v+1) - caframe(v)) > approachtime
                caframethresh = [caframethresh caframe(v+1)];
            end
        end

    if length(caframethresh) >= 1

        if ((length(raw_trace) - caframethresh(length(caframethresh)) < approachtime))
            caframethresh = caframethresh(1:(length(caframethresh)-1));
        end

         u = struct('camat', 1);

         for v = 1:length(caframethresh)

            x = raw_trace((caframethresh(v) - approachtime):(caframethresh(v) + approachtime),:);
            %maxtrace = max(abs(x));
            %x = x./maxtrace;
            x = normalize(x, 'range');
            u(v).camat = x;
         end

         size_ca = size(x);
         g = zeros(size_ca(1),size_ca(2));
         avgca = u(1).camat;
         for v = 2:length(caframethresh)
            avgca = avgca + u(v).camat;
         end
         avgca = avgca/length(caframethresh);


         [val, index] = max(avgca);0
         sortavgca = avgca;
         [o,u] = sort(index, 'ascend');
         %[o,u] = sort(sum(avgca), 'descend');
         sortavgca = avgca;
         for v = 1:length(u)
            sortavgca(:,v) = avgca(:,u(v));
         end
         
       
        yy = imagesc(-10:0.01:10,1:size_ca(2),sortavgca');
            ylabel('Cell (#)')
            xlabel('Time from Familiar Mouse Cup Interaction(s)')
            title(currentfile)
            colorbar

        pl = line([0,0], [size_ca(2),0]);
        pl.Color = 'Black';
        pl.LineWidth = 1.5 ;


    end

    %all_traces(i) = {mean(avgca')};
    end

end

%alltrials = cat(1,all_traces{:});

%yy = imagesc(-5:0.01:5,1:length(alltrials),alltrials);
%    ylabel('Trial')
%    xlabel('Time from interaction (seconds)')
%    title(currentfile)
%    colorbar
%pl = line([0,0], [size_ca(2),0]);
%pl.Color = 'Black';
%pl.LineWidth = 1.5 ;

%% CREATE PIE CHART
% Mean firing rate
casize = size(C_spikes);
y = 0;
spikes = struct('socsum', 1);
for v = 1:length(caframethresh)
socspikerate = C_spikes(caframethresh(v):caframethresh(v)+20,3:casize(2));
spikes(v).time = (C_spikes(caframethresh(v)+20,2) - C_spikes(caframethresh(v),2));
spikes(v).socsum = sum(socspikerate)';
end

cells = spikes(1).socsum;
time = spikes(1).time;
for v = 2:length(caframethresh);
    cells = cells + spikes(v).socsum;
    time = time + spikes(v).time;
end

firingrate = sort(cells/(time/1000), 'descend');


%% ANOTHER ATTEMPT AT ISI'S FOR EACH CELL DURING EACH INTERACTION
load(fullfile(files(i).folder,'cell_events.mat'))
cell_events = cell_events > 0;
casize = size(cell_events);
yu = cell(length(caframethresh),1);
mean_instfreq = [];
std_instfreq = [];

%Inst Freq for all Interactions
for x = 3:casize(2)
    
    for v = 1:length(caframethresh)
    socint = cell_events(caframethresh(v):caframethresh(v)+200,:);
    [idx,c] = find(socint(:,x) == 1);
    isi = diff(socint(idx,2)/1000);
    yu(v) = {isi};
    end
    all_isi = cat(1,yu{:});
    all_inst = 1/all_isi;
    meanisi = mean(all_inst);
    stdisi = std(all_inst);
    nan = isnan(meanisi);
    if nan == 1
    meanisi = 0;
    stdisi = 0;
    mean_instfreq = [mean_instfreq meanisi];
    std_instfreq = [std_instfreq stdisi];
    else
    mean_instfreq = [mean_instfreq meanisi];
    std_instfreq = [std_instfreq stdisi];
    end
    
end

%Inst Freq for whole trial
wholetrial = cell_events;
mean_instfreqwt = [];
std_instfreqwt = [];
for v = 1:casize(2)-2
[idx,c] = find(wholetrial(:,v) == 1);
isi = diff(mstime(idx)/1000);
instfreq = [];
for vv = 1:length(isi)
    instfreq = [instfreq (1/isi(vv))];
end
mean_instfreqwt = [mean_instfreqwt mean(instfreq)];
std_instfreqwt = [std_instfreqwt std(instfreq)];
end

socialcells = [];
for v = 1:length(mean_instfreq)
    soc_cell = ((mean_instfreq(v) > (mean_instfreqwt(v) + 2*std_instfreqwt(v))));
    socialcells = [socialcells soc_cell];
end

numsoc = sum(socialcells);

x = [numsoc/length(socialcells) (1-(numsoc/length(socialcells)))];
    
    
    
    
pie(x)
legend('Object Selective Cells', 'Non Object Selective Cells')
title('Dir Int Animal 409 Day 1 Trial 1')
    
    
    
    
    
    
    
    