function plot = plotDataLog(RC, plot, xlog, ylog)

% Get data from RC
xData = RC.(strcat("DataLog", int2str(xlog)));
yData = RC.(strcat("DataLog", int2str(ylog)));

if isempty(plot)
    % CREATE
    plot = plot(xData, yData);
else
    % UPDATE
    set(plot, 'xdata', xData, 'ydata', yData);
end

end
