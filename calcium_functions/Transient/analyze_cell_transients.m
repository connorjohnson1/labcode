p_folder = uigetdir('Y:\Data 2018-2019\Anterior Cingulate Cortex\BehaviorMiniscopesACC\Organized\');
addpath(genpath('Y:\Lab Software and Code\ConnorStuff'));
files = dir(fullfile(p_folder,'**','dff_cell_transients_filt.mat'));
files = is_split(files);
numExps = length(files);
final_results = cell(numExps,1,1);

%Connor Johnson 11/13/20 ACM Lab Boston University
%The purpose of this script is to determine features of our VIPACC Ca2+
%transients (Peak Amplitude, length, rise+decay times...)


for i = 1:numExps
    
    %Load files from server
    load(fullfile(files(i).folder, 'timestamp.mat'));
    load(fullfile(files(i).folder, 'obj_interactions.mat'));
    load(fullfile(files(i).folder, 'cell_events_filt.mat'));
    load(fullfile(files(i).folder, 'dff_cell_transients_filt.mat'));
    
    %Write File Name in Final Results Matrix
    file_delim = strsplit(files(i).folder, '\');
    currentfile = join(file_delim(7:9));
    final_results(i,1) = currentfile;
    
    %%% UNCOMMENT IF RUNNING ON SOCIABILITY
    %load(fullfile(files(i).folder, 'cuplocation.mat'));
    %if cuplocation(1) == 1;
    %     interactions2 = interactions;
    %     interactions2(:,2) = interactions(:,3);
    %     interactions2(:,3) = interactions(:,2);
    %     interactions = interactions2;
    %elseif cuplocation(2) == 1;
    %        interactions = interactions;
    %end
    
    amplitudes = zeros(1,size(dff_cell_transients_filt,2));
    length_s = zeros(1,size(dff_cell_transients_filt,2));
    rise_time = zeros(1,size(dff_cell_transients_filt,2));
    decay_time = zeros(1,size(dff_cell_transients_filt,2));
    transient_freq = zeros(1,size(dff_cell_transients_filt,2));
    %get average amplitude of cell transients
    for ii = 1:size(dff_cell_transients_filt,2);
        %get length of transients for each cell
        behavior = dff_cell_transients_filt(:,ii) > 0;
        [freq, startstopframes, totaltime] = get_transient_length(behavior, cell_events_filt, timestamp);
        %save lengths
        length_s(ii) = mean(totaltime);
        %save start/end frames for each transients
        t_frames = startstopframes.mscam;
        %find peak amplitude for each transient
        temp_amp = zeros(1,size(t_frames,1));
        temp_rise = zeros(1,size(t_frames,1));
        temp_decay = zeros(1,size(t_frames,1));
        for iii = 1:size(startstopframes.mscam,1);
            %calculate amplitude for this transient
            temp_amp(iii) = max(dff_cell_transients_filt(t_frames(iii,1):t_frames(iii,2),ii));
            transient = dff_cell_transients_filt(t_frames(iii,1):t_frames(iii,2),ii);
            %calculate rise/decay time
            ten_p = temp_amp(iii)*0.1;
            ninety_p = temp_amp(iii)*0.9;
            [t_rise, t_decay] =  get_rise_decay_times(ten_p, ninety_p,transient,t_frames(iii,:),timestamp);
            temp_rise(iii) = t_rise;
            temp_decay(iii) = t_decay;
        end
        amplitudes(ii) = mean(temp_amp);
        rise_time = mean(temp_rise);
        decay_time = mean(temp_decay);
    end
            
    final_results{i,2} = mean(length_s);
    final_results{i,3} = mean(amplitudes);
    final_results{i,4} = mean(rise_time);
    final_results{i,5} = mean(decay_time);
   
    
end