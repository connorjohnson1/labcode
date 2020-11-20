close all
clear all
clc

p_folder = uigetdir();
files = dir(fullfile(p_folder,'**','timestamp.dat')); %to select directory from which .dat files will be pulled
numExps = length(files);
rowz = round(numExps/10)     %% Used round function in case the total number of trials is odd
figure(1)                   %% This is to prepare a subplot that can integrate all the data extracted from each text file
subplot(rowz, 5, 1);        %% 
figure(2)
subplot(rowz, 5, 1);
MeanTimeElapsMs = [];
MeanTimeElapsBh = [];
perdiff = [];
mscamavgfr = [];
bhcamavgfr = [];
mscamfrstd = [];
bhcamfrstd = [];

for i = 1:numExps
    %Initialize tempArray
    tempArray = [];
    % Find all msCam videos
    tempFiles = dir(fullfile(files(i).folder,'timestamp.dat'));
    for ii = 1:length(tempFiles)
        tempArray{ii} = fullfile(tempFiles(ii).folder,tempFiles(ii).name);
        
        
        M=importdata(tempArray{ii}); %% This will create the matrix version
        
        
        
        MsCam = M.data(M.data(:,1) >= 4,:);     %% of the timestamp.dat files and separate
        BehaveCam = M.data(M.data(:,1) < 4 ,:); %% them by Behavior or Miniscope

    end

    fileArray{i} = tempArray;
   
        %Calculate the difference in time between each frame
        mscamFR = diff(MsCam(:,3));
        behavecamFR = diff(BehaveCam(:,3));
        
        %Change the starting timestamp to 0
        behavecamFR(1) = 0;
        mscamFR(1) = 0;
 
        if i <= numExps/2
        figure(1)
        subplot(rowz, 5, i);
        histogram(mscamFR, 150);
        hold on
        histogram(behavecamFR, 150);
        hold off
        
        %Extract info to title each figure
        fileArrayChar = char(fileArray{i});
        behaviorinfo = strsplit(fileArrayChar, {'\', '_'});
        behaviorinfo = join(behaviorinfo(6:14));
        
        % This is to get the info for the Ms and Behave
        % total time elapsed and total frames
     
        mstotalframes = length(MsCam); mstotalframes2 = num2str(mstotalframes);
        bhtotalframes = length(BehaveCam); bhtotalframes2 = num2str(bhtotalframes);
        mstotaltime = MsCam(length(MsCam),3); mstotaltime2 = num2str(mstotaltime);
        bhtotaltime = BehaveCam(length(BehaveCam),3); bhtotaltime2 = num2str(bhtotaltime);
        
        
        
        ylim=get(gca,'ylim');
        omfg = (ylim(2)/5);
        xlim=get(gca,'xlim');
        text(xlim(2),ylim(2), mstotalframes2, 'Color', '#D95319')
        text(xlim(2),(ylim(2)-omfg), mstotaltime2, 'Color', '#7E2F8E')
        text(xlim(2),(ylim(2)-(2*omfg)), bhtotalframes2, 'Color',  '#77AC30')
        text(xlim(2),(ylim(2)-(3*omfg)), bhtotaltime2, 'Color', '#A2142F')
       
        %to calculate mean times elapsed
        MeanTimeElapsMs = [MeanTimeElapsMs mstotaltime];
        MeanTimeElapsBh = [MeanTimeElapsBh bhtotaltime];
        
        %to calculate percent difference in time elapsed
        perdiff1 = (bhtotaltime-mstotaltime)/bhtotaltime;
        perdiff = [perdiff perdiff1];
        
        mscamavgfr = [mscamavgfr mean(mscamFR)];
        bhcamavgfr = [bhcamavgfr mean(behavecamFR)];
        
        mscamfrstd = [mscamfrstd std(mscamFR)];
        bhcamfrstd = [bhcamfrstd std(behavecamFR)];
        
        title(behaviorinfo);
        
        
        else 
        figure(2)
        subplot(rowz, 5, (i + 1 - (round(numExps/2))));
        histogram(mscamFR, 50);
        hold on
        histogram(behavecamFR, 50);
        hold off
        
        %Extract info to title each figure
        fileArrayChar = char(fileArray{i});
        behaviorinfo = strsplit(fileArrayChar, {'\', '_'});
        behaviorinfo = join(behaviorinfo(6:14))
        
        mstotalframes = length(MsCam); mstotalframes2 = num2str(mstotalframes);
        bhtotalframes = length(BehaveCam); bhtotalframes2 = num2str(bhtotalframes);
        mstotaltime = MsCam(length(MsCam),3); mstotaltime2 = num2str(mstotaltime);
        bhtotaltime = BehaveCam(length(BehaveCam),3); bhtotaltime2 = num2str(bhtotaltime);
        
        
        
        ylim=get(gca,'ylim');
        omfg = (ylim(2)/5);
        xlim=get(gca,'xlim');
        text(xlim(2),ylim(2), mstotalframes2, 'Color', '#D95319')
        text(xlim(2),(ylim(2)-omfg), mstotaltime2, 'Color', '#7E2F8E')
        text(xlim(2),(ylim(2)-(2*omfg)), bhtotalframes2, 'Color',  '#77AC30')
        text(xlim(2),(ylim(2)-(3*omfg)), bhtotaltime2, 'Color', '#A2142F')
        
        MeanTimeElapsMs = [MeanTimeElapsMs mstotaltime];
        MeanTimeElapsBh = [MeanTimeElapsBh bhtotaltime];

        perdiff1 = (bhtotaltime-mstotaltime)/bhtotaltime;
        perdiff = [perdiff perdiff1];
        
        mscamavgfr = [mscamavgfr mean(mscamFR)];
        bhcamavgfr = [bhcamavgfr mean(behavecamFR)];
        
        mscamfrstd = [mscamfrstd std(mscamFR)];
        bhcamfrstd = [bhcamfrstd std(behavecamFR)];
        
        title(behaviorinfo);
        title(behaviorinfo);
        

        end
end

figure(3);
histogram(mscamavgfr);
hold on
histogram(bhcamavgfr);
legend('MsCam', 'Behave Cam')
meanperdiff = mean(perdiff);
hold off


