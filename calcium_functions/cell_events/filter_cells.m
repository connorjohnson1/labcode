function [raw_trace_filt, cell_events_filt, dff_cell_transients_filt, zscored_cell_filt, idx] = filter_cells(raw_trace,cell_events, dff_cell_transients, zscored_cell, timestamp)
%
% CJ 6/11/20 ACM Lab Boston University
%
% This function will filter bad cells out of our raw_trace and cell_event
% variables.
%

    [~,cell_freq] = get_avg_freq(cell_events,timestamp);
    
    %Threshold is set here to 0.25
    good_cells = find(cell_freq < 0.25);
    
    %Output
    idx = good_cells;
    raw_trace_filt = raw_trace(good_cells,:);
    cell_events_filt = cell_events(:,good_cells);
    dff_cell_transients_filt = dff_cell_transients(:,good_cells);
    zscored_cell_filt = zscored_cell(:,good_cells);
    
end