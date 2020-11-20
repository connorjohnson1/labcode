function [ratio, sel_ind] = cell_select_2cond_AUC(cell_transients,startframe, timestamp,cond1, cond2)
%
% 5/15/2020 Connor Johnson ACM Lab, Boston University
% Adapted from Jiminez et al. 2016
%
% The purpose of this code is to determine cells that are selective for
% certain conditions (Object Zone, Social Zone, Interactions, Etc...)
%
%INPUTS
%cell_events = binary matrix of Ca2+ spikes (Time x Cell)
%timestamps = the timestamp info from the same trial as the cell_events
%

    %get the original AUC by running framematch on the two conditions
    [AUC] = get_AUC(3, cell_transients, timestamp, cond1);
    behave1freq = AUC;
    [~, AUC] = div_AUC(cond2, startframe, timestamp, cell_transients);
    behave2freq = AUC;
    
    %find the difference in original AUC
    beh1_ratediff = behave1freq - behave2freq;
    beh2_ratediff = behave2freq - behave1freq;
    
    %create empty matrix for shuffled AUC
    shuffled_freq1 = zeros(1000,size(cell_transients,2));
    shuffled_freq2 = zeros(1000,size(cell_transients,2));
    
    %shuffle the data 1000 times (circular shift)
    p = randperm(size(cell_transients,1),1000);
    for ii = 1:1000
        cell_events_shift = circshift(cell_transients,p(ii),1);
        [AUC] = get_AUC(3, cell_events_shift, timestamp, cond1);
        shuffled_freq1(ii,:) = AUC;
        
        [~, AUC] = div_AUC(cond2, startframe, timestamp, cell_transients);
        shuffled_freq2(ii,:) = AUC;
    end
    
    %find the difference in the shuffled data
    shuffled_diff1=shuffled_freq1-shuffled_freq2;
    shuffled_diff2=shuffled_freq2-shuffled_freq1;
    
    %find the upper quartile value
    cond1_2stdthresh = quantile(shuffled_diff1,0.95);
    cond2_2stdthresh = quantile(shuffled_diff2,0.95);
    
    %evaluate selectivity
    cond1_selective = beh1_ratediff > cond1_2stdthresh;
    cond2_selective = beh2_ratediff > cond2_2stdthresh;
    
    %save the indices of which cells are selective and which aren't
    cond1_selective_idx = find(cond1_selective > 0);
    cond2_selective_idx = find(cond2_selective > 0);
    nonselective_idx = find(cond1_selective<1 & cond2_selective<1);
    
    ratio = [(length(cond1_selective_idx)/size(cell_transients,2)), (length(cond2_selective_idx)/size(cell_transients,2)), (length(nonselective_idx)/size(cell_transients,2))];
    sel_ind.cond1 = cond1_selective_idx; sel_ind.cond2 = cond2_selective_idx; sel_ind.neutral = nonselective_idx;
    
    
    end

        