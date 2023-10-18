function plotData = displayLidarScan(RC, ~, plotData)
    scan = RC.getScan();
    if ~isempty(scan)
        plot(RC.getScan());
    end
end