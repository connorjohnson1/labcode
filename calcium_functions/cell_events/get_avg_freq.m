function [population_freq,cell_freq] = get_avg_freq(cell_events,timestamp)
%CJ ACM Lab 5/9/2020
%INPUTS:
%cell_events = (frame x cell) logical matrix of Ca2+ peaks
%timestamps = timestamp.mat from the same trial as the Ca2+ data
%
%This function calculates the average frequency of Ca2+ events across a
%trial
%
%OUTPUTS:
%population_freq = the overall frequency of a trial
%cell_freq = a vector containing the average firing rate of each cell
    

    mstime = timestamp.mscam(:,3); mstime(1) = 0;
    cell_events = cell_events>0;
    totaltime = mstime(length(mstime))/1000;
    total_cell_events = sum(cell_events);
    cell_freq = total_cell_events/totaltime;
    population_freq = (sum(total_cell_events)/size(cell_events,2))/totaltime;


end