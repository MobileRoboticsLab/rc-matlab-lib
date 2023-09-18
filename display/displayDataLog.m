function plotData = displayDataLog(RC, ~, plotData, xlog, ylog)

% Get data from RC
xData = RC.(strcat("DataLog", int2str(xlog)));
yData = RC.(strcat("DataLog", int2str(ylog)));

if isempty(plotData)
    % CREATE
    plotData = plot(xData, yData);
else
    % UPDATE
    set(plotData, 'xdata', xData, 'ydata', yData);
end

end
