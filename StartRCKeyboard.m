%% RC Keyboard Control
% Jonathan Boylan
% 11/10

clc
clear
close all

%% Display

% Connect to RC
RC = RCCar();

% Create figure for control
display = figure();
display.KeyPressFcn = @(~,evt) keyPress(RC, evt.Key);
display.KeyReleaseFcn = @(~,evt) keyRelease(RC, evt.Key);

% Start control loop
RC.NextControl = [0; 0];
while 1
    
    % Send commands
    RC.setSpeed(RC.NextControl(1))
    RC.setSteeringAngle(RC.NextControl(2))

    % Run at fixed frequency
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