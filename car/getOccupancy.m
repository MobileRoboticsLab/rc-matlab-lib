% Retrieves the occupancy value of the map at a specified (x, y) location.
function occupancy = getOccupancy(obj, x, y)

% Get the latest map data
map = obj.getMap();

% Convert the real-world (x, y) coordinates to grid/map coordinates based on map resolution and origin
x_grid = round((x - map.Info.Origin.Position.X) / map.Info.Resolution);
y_grid = round((y - map.Info.Origin.Position.Y) / map.Info.Resolution);

% Check if the converted grid coordinates are within the valid map boundaries
if x_grid < 1 || x_grid > map.Info.Width || y_grid < 1 || y_grid > map.Info.Height
    fprintf("Provided XY location (%f, %f) is out of the map's boundaries.\n", x, y);
    occupancy = -1;  % Return an error code for out-of-bound location
    return;
end

% Convert the 2D grid coordinates into a 1D index for the map data array
index = sub2ind([map.Info.Width, map.Info.Height], x_grid, y_grid);

% Fetch and return the occupancy value from the map data at the calculated index
occupancy = map.Data(index);

end