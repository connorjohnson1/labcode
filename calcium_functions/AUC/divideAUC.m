function [AUC_div] = divideAUC(cell_transients, timestamp);

  btime = timestamp.behavecam(:,3); btime(1) = 0;
  mstime = timestamp.mscam(:,3); mstime(1) = 0;

  
  trace_length = size(cell_transients,1);
  chunks = trace_length/30;
  chunks = floor(chunks);
  
  
  
  for i = 1:chunks
      



end