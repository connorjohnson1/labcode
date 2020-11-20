%plot_AUC
%

behavetime = timestamp.behavecam(:,3); behavetime(1) = 0; behavetime = behavetime/1000;
mstime = timestamp.mscam(:,3); mstime(1) = 0; mstime = mstime/1000;

behavior = interactions(:,2);
[~, startstopframes, ~] = framematch_mscam_behavecam_approach(5,behavior, cell_events_filt, timestamp)

subplot(2,1,1)
plot(raw_trace_filt(4,:));
subplot(2,1,2)
plot(dff_cell_transients_filt(:,4));
hold on
f = zeros(size(raw_trace_filt,2),1);
msframes = startstopframes.mscam;
for i = 1:size(msframes,1);
    temp = msframes(i,1):msframes(i,2)
    f(temp) = 1;
end

AUC = dff_cell_transients_filt(:,4);
AUC(f == 0) = 0;
area(AUC)

hold off
subplot(2,1,1)
xlim([1 6000])
subplot(2,1,2)
xlim([1 6000])