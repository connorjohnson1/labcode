% ACM Lab - Visualize Ca2+ Traces - 5/26/2020 (Informal Code)
%
% In order to run please open raw_trace and cell_events from one trial
% (make sure they are both from the same trial)
%
% When asked for input, press 1 if the trace looks good and 0 if it looks
% bad
% 
% to run the code press ctrl + enter
%
% At the end the code will give you a value percent_good, this is the
% percent of traces that you deemed as being good. write this value down
% and average it with all other trials you run.
%
close all
correct = []
%cell_events = cell_events_filt;
x = [4,12,13,14,16,17,20,22,23,33,35,41,45,57,62];
raw_trace = raw_trace_filt(x,:);
%raw_trace = squeeze(raw_trace);
%for i = 1:size(raw_trace,1)
%    [C(i,:),S(i,:),~] = deconvolveCa(raw_trace(i,:), 'foopsi', 'ar1',...
%        'smin', -3, 'optimize_pars', true, 'optimize_b', true, 'max_tau', 20);
%end

for i = 1:size(raw_trace,1)
    %subplot(2,1,1)
    plot(raw_trace(i,1:6000));
    xlim([0 6500])
    i
    %subplot(2,1,2)
    %plot(S(i,:));
    %subplot(2,1,2)
    %plot(cell_events(:,i));
    x = input('Were Ca2+ events properly extracted from this trace?');
    correct = [correct x];
end

%goodtraces = size(find(correct == 1),2);

percent_good = (goodtraces/size(correct,2))*100