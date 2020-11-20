function [msbins, behbins] = ROC_bin(bin_size, timestamp);

%Connor Johnson 8/3/2020 ACM Lab BU
%
%The purpose of this function is to divide the behavior and miniscope 
%frames into (x)ms bins
%
%Inputs:
%
%bin_size = the size of the bins you want in milliseconds; ex: 1000 = 1s
%timestamp = the timestamp data recorded during aquisition that will allow 
%us to find the closest intervals to our bin size
%
%Outputs:
%
%msbins = matrix containing the indices of the bins for our miniscope data
%behbins = matrix containing the indices of the bins for our behavior data
%%
        
        %Create new variables for miniscope and behavior timestamps from
        %struct
        mstime = timestamp.mscam(:,3); mstime(1) = 0;
        btime = timestamp.behavecam(:,3); btime(1) = 0;
    
        %create imaginary bins based on bin size and length of mscam
        ms_div = 1:bin_size:max(mstime);
            
        %find the closest matching timestamps in mscam to our imaginary bins
        mdiv = [];
        for v = 1:size(ms_div,2)
            %subtract current imaginary bin from all values and find the
            %value with the lowest difference
            [~,idx] = min(abs(mstime - ms_div(v)));
            %creates variable with the INDICES of mscam timestamps for
            %binning
            mdiv = [mdiv idx];
        end
        
        %Match my mscam timestamps to my behavior timestamps, so that the
        %starting time stamp of each bin will be as close as possible
        ms_timestamps = mstime(mdiv);
        bdiv = [];
        for v = 1:size(ms_div,2)
            [~,idx] = min(abs(btime - ms_timestamps(v)));
            %creates variable with the INDICES of behavior timestamps for
            %binning
            bdiv = [bdiv idx];
            
        end
        
        %find actual values based on bins
        %ms_timestamps = mstime(mdiv);
        %beh_timestamps = btime(bdiv);
        %testing variable in case I want to look at the
        %lengths of my bins
        %msblocks = diff(ms_timestamps);
        %behblocks = diff(beh_timestamps);
        
        %use indices for rest of analysis since it's easier than using the
        %timestamp values
        msbins = mdiv;
        behbins = bdiv;
end