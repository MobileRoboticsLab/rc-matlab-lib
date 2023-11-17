%% RC Keyboard Control
% Jonathan Boylan
% 11/10

clc
clear
close all

%% Display

% Connect to RC
RC = RCCar();

display = figure();
display.KeyPressFcn = @(~,evt) keyPress(RC, evt.Key);
display.KeyReleaseFcn = @(~,evt) keyRelease(RC, evt.Key);

c = 0;
d = 100;

RC.MaxSpeed = 0.25;
RC.NextControl = [0; 0];
while 1
    RC.setSpeed(RC.NextControl(1))
    RC.setSteeringAngle(RC.NextControl(2))
    if (mod(c, d) == 0)
        map = RC.getMap();
        mapf = readOccupancyGrid(map);
        show(mapf)
    end
    c = c + 1;
    pause(0.01)
end

%% Functions

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