function [t_rise, t_decay] =  get_rise_decay_times(ten_p, ninety_p,transient,frames,timestamp)
    
    %Connor Johnson ACM Lab BU 11/13/20
%The purpose of this function is to calculate the rise/decay times of our
%VIPACC Ca2+ transients
%%
[~,idx_amplitude] = max(transient);
mstime = timestamp.mscam(:,3);
mstime(1) = 0;
%FOR RISE TIMES
[~,idx_10p] = min(abs(transient(1:idx_amplitude) - ten_p));
[~,idx_90p] = min(abs(transient(1:idx_amplitude) - ninety_p));

transient_time = mstime(frames(1):frames(2));
t_rise = (transient_time(idx_90p)-transient_time(idx_10p))/1000;

%%
%FOR DECAY TIMES
[~,idx_10p] = min(abs(transient(idx_amplitude:length(transient)) - ten_p));
[~,idx_90p] = min(abs(transient(idx_amplitude:length(transient)) - ninety_p));

idx_10p = idx_10p + (idx_amplitude-1);
idx_90p = idx_90p + (idx_amplitude-1);

t_decay = (transient_time(idx_10p)-transient_time(idx_90p))/1000;
    

end

