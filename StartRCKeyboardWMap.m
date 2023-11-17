%% RC Keyboard Control
% Jonathan Boylan
% 11/10

clc
clear
close all

%% Display

% Set the map zoom
zoom = 5.0;

% Connect to RC
RC = RCCar();

% Reset the RC map
RC.resetMap()

% Create map figure
display = figure();
display.KeyPressFcn = @(~,evt) keyPress(RC, evt.Key);
display.KeyReleaseFcn = @(~,evt) keyRelease(RC, evt.Key);

% Apply zoom
map_size = 50.0;
axis_size = map_size / zoom;

% Optimization params
c = 0; % ticker
d = 100; % resolution

% Set speed limits
RC.MaxSpeed = 0.25;
RC.MinSpeed = -0.25;

% Start control loop
RC.NextControl = [0; 0];
while 1

    % Send commands
    RC.setSpeed(RC.NextControl(1))
    RC.setSteeringAngle(RC.NextControl(2))

    % Update map once every resolution ticks
    if (mod(c, d) == 0)
        % Get latest map
        map = RC.getMap();
        % Convert to occupancy grid type
        mapf = readOccupancyGrid(map);
        % Display the map
        show(mapf)
        % Apply zoom
        axis([-axis_size axis_size -axis_size axis_size])
    end

    c = c + 1; % tick

    % Run at fixed frequency
    pause(0.01)
end

%% Figure Functions

function keyPress(RC, key)
    switch key
        case 'w'
            RC.NextControl(1) = RC.MaxSpeed;
        case 'a'
            RC.NextControl(2) = RC.MaxSteerAngle;
        case 's'
            RC.NextControl(1) = RC.MinSpeed;
        case 'd'
            RC.NextControl(2) = RC.MinSteerAngle;
    end
end

function keyRelease(RC, key)
    switch key
        case 'w'
            RC.NextControl(1) = 0;
        case 'a'
            RC.NextControl(2) = 0;
        case 's'
            RC.NextControl(1) = 0;
        case 'd'
            RC.NextControl(2) = 0;
    end
end