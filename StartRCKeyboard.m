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

keyboard

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