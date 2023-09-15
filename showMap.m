function showMap(rc)
figMap = figure('Name', 'Occupancy Grid Map', 'NumberTitle', 'off');
set(figMap, 'CloseRequestFcn', @closeFig);

ax = axes(figMap); % Create an axis in the map figure
map_msg = rc.getMap();
occupancyGrid = readOccupancyGrid(map_msg);
binMat = occupancyMatrix(occupancyGrid); % Convert occupancyGrid to a binary matrix
imgObj = image(uint8(binMat*255), 'CDataMapping', 'scaled', 'Parent', ax); % Convert logical to uint8 for display
colormap(ax, 'gray');
axis tight;

t = timer('TimerFcn', @(~,~)updateMap(rc, imgObj), 'Period', 0.5, 'ExecutionMode', 'fixedRate');
start(t);

    function updateMap(rc, imgObj)
        % This function will periodically fetch and display the map
        map_msg = rc.getMap();
        occupancyGrid = readOccupancyGrid(map_msg);
        binMat = occupancyMatrix(occupancyGrid); % Convert to a binary matrix
        set(imgObj, 'CData', uint8(binMat*255)); % Update the CData of the image object
    end

    function closeFig(~,~)
        if isvalid(t)
            stop(t)
            delete(t)
        end
        delete(gcf);
        disp("Closed Map.")
    end
end
