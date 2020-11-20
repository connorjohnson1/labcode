function rasterplot(cell_events, raw_trace, index, behavior, timestamp)
%Connor Johnson ACM Lab 5/1/2020
%
%The purpose of this code is to create a raster plot of our Ca2+ events
%
%INPUTS:
%cell_events = matrix of cell events (frames x cells)
%interactions = logical vector of behavior data
%timestamp = timestamp.mat files from same trial as Ca2+ data and behavioral data
   raw_trace = raw_trace';
   raw_trace = raw_trace(:,index);
  
   for i = 1:size(raw_trace,2)
       raw_trace(:,i) = normalize(raw_trace(:,i),'range');
       raw_trace(:,i) = raw_trace(:,i) + (i-1);
   end
    spikes = cell_events(:,index);
    btime = timestamp.behavecam(:,3)/1000; btime(1) = 0;
    mstime = timestamp.mscam(:,3)/1000; mstime(1) = 0;
    f = find(behavior > 0); behavior(f) = size(spikes,2);
    for i = 1:size(spikes,2);
        f = find(spikes(:,i) > 0);
        spikes(f,i) = i;
    end
    g = area(btime', behavior,'LineStyle', 'none', 'FaceAlpha', 0.5, 'FaceColor', 'r')
    hold on
    %g = area(btime', interactions(:,2),'LineStyle', 'none', 'FaceAlpha', 0.1, 'FaceColor', 'b')
    for i = 1:size(spikes,2);
        f = find(spikes(:,i) > 0);
    for ii = 1:size(f,1)
    line([mstime(f(ii)),mstime(f(ii))],[i-1,i],'color','black');
    end
    end
    plot(mstime',raw_trace, 'b');
    hold off

end

