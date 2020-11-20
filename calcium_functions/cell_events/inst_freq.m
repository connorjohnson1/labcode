function [avg_instfreq,std_instfreq,instfreq_all] = inst_freq(cell_events,timestamp)
%CJ ACM Lab 5/9/2020
%INPUTS:
%cell_events = (frame x cell) logical matrix of Ca2+ peaks
%timestamps = timestamp.mat from the same trial as the Ca2+ data
%
%This function calculates the instantaneous frequency of cells using
%inst_freq = 1 / ISI
%
%OUTPUTS:
%instfreq_all = struct containing all of the instaneous frequencies calculated 
%for each cell.
%avg_instfreq = a vector with the avg inst_freq of each cell
%std_instfreq = a vector with the std of inst_freqs of each cell
    

    mstime = timestamp.mscam(:,3); mstime(1) = 0;
    instfreq_all = cell(size(cell_events,2),1);
    avg_instfreq = [];
    std_instfreq = [];
    
    for i = 1:size(cell_events,2)
        
        spikeframes = find(cell_events(:,i) > 0);
        spiketimes = mstime(spikeframes);
        inst_freq = [];
        
        for ii = 2:length(spiketimes)
            ISI = ((spiketimes(ii) - spiketimes(ii-1))/1000);
            inst_freq = [inst_freq (1/ISI)];
        end
        
        instfreq_all(i) = {inst_freq};
        avg_instfreq = [avg_instfreq mean(inst_freq)];
        std_instfreq = [std_instfreq std(inst_freq)];
        
    end
           
end