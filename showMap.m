% Convert and display latest occupancy grid
function showMap(rc)

% Get latest map from RC
map_msg = rc.getMap();

% Convert to Occupancy Grid type
occupancyGrid = readOccupancyGrid(map_msg);

% Show in figure
show(occupancyGrid)