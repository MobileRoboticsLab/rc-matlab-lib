%% RC Simulation
% Jonathan Boylan
% 9/21

clc
close all
CLEAR

%%

RC = RCCar();
sim = RCSimulation();
control = RCControl(RC, @WallFollowerControlFcn, 10);

pause(1.0)

sim.Obstacles = hallwayObstacles();

sim.start();

rcdisplay = RCDisplay(RC, 1, 1, ...
    {@displayRCState}, ...
    {@(RC,disp,data) attachKeyboardControl2(RC,disp,data,control)});
%    @displayLidarScan
%    @(RC, ~, data) displayDataLog(RC, 0, data, 1, 2)
%    @(RC, ~, data) displayDataLog(RC, 0, data, 1, 3)

rcdisplay.DisplayRate = 20;

pause(1.0);

rcdisplay.open();

keyboard

sim.stop();
