# RC MATLAB Library

| Contact           |                   |
| ----------------- | ----------------- |
| Dr. Ordonez       | -                 |
| Jonathan Boylan   | jboylan@fsu.edu   |

## Download Instructions

1) Install latest version of MATLAB.
2) Install ROS Toolbox. *(Add on > ROS Toolbox)*
3) Download this library. *(Code > Download ZIP)*
4) Extract in a convenient directory.

## RC Car Instructions

1) Grab a RC car from the shelf and a pair of batteries. Note the RC number on the side of the car (not the large 1 on the front). Make sure everything is intact and there are no loose connections.

2) Plug in the two batteries. First, the one with the red connector, then the white connector. If you see, hear, or smell anything strange, disconnect the batteries immediately.

3) Wait for the Lidar to start spinning. Should take about a minute. If it doesn't, unplug the batteries and let the TA know.

4) Go into your WiFi settings. Look for a WiFi connection by the name of `MobileRoboticsLabRC#`. Make sure the `#` matches your RC car number. Connect to the WiFi using 'a security key instead' with the passkey `mobileroboticslab`. 

## MATLAB Library Instructions

1) Open MATLAB and go to where you downloaded the library.

2) Right click on the folder `rc-matlab-lib-main` and select 'Add to Path > Selected Folders'. You will need to do this every time you open MATLAB.

3) Run `ConnectToROS.m` to connect to the RC car's ROS network.

3) Test the RC connection by running `StartRCKeyboard.m`, which will allow you to send commands to the RC car using your WASD keys. **Make sure the car is elevated and no wheels are touching the stand before running this on the table.**

4) You should now be able to run your lab scripts from any directory.

5) Before disconnecting the batteries. Make sure to run `DisconnectFromROS.m`. Failing to do this might cause your MATLAB to freeze.

## Library Features

### RCCar Object
```
% Initialize RC connection
RC = RCCar();
```

### RCCar Commands
```
% Set the speed (in m/s)
RC.setSpeed(v)

% Set the steering angle
RC.setSteeringAngle(gamma)

% Reset the localization position to (0,0,0) 
% and clear the occupancy grid
RC.resetMap()
```

### RCCar Properties
```
% Current state
x = RC.X;
y = RC.Y;
phi = RC.Phi;

% Current velocity
vx = RC.Vx;
vy = RC.Vy;
v = RC.V; % (= sqrt(vx^2 + vy^2))
omega = RC.Omega;

% Check occupancy at a location. Returns a
% probability of occupancy between 0.0 and 1.0
occ = RC.getOccupancy(x_, y_);

% Get the latest Lidar Scan
scan = RC.getScan();

% The RC object also includes 5 data logs
% that can hold data between functions
RC.DataLog1 = [RC.DataLog1; x];
RC.DataLog2 = y;
% ...
```

## Control Loop Example
```
%% RC Car Example Control Loop

clc
clear
close all
%%

% Initialize RC connection
RC = RCCar();

% Set total duration and frequency of the control
duration = 5.0; % seconds
frequency = 10; % hertz

tic % Start timer
while (toc < duration)

    % TODO: Control

    % Maintain fixed frequency
    pause(1/frequency);
end
```

## Please report bugs to the TA