close all
x = [4,12,13,14,16,17,20,22,23,33,35,41,45,57,62];
trace = raw_trace_filt(x,1:6500);
trace = normalize(trace', 'range');

for i = 1:size(trace,2)
trace(:,i) = trace(:,i) + i-1;
end

hold on
for i = 1:size(trace,2)
plot(smooth(trace(1:6500,i)),'LineWidth',1.3)
end
hold off

