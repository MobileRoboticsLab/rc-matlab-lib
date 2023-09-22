%% RC Simulation
% Jonathan Boylan
% 9/21

clc
close all
CLEAR

%%

RC = RCCar();
sim = RCSimulation();

pause(1.0)

sim.start();

rcdisplay = RCDisplay(RC, 1, 1, ...
    {@displayRCState}, ...
    {@attachKeyboardControl});
%    @displayLidarScan
%    @(RC, ~, data) displayDataLog(RC, 0, data, 1, 2)
%    @(RC, ~, data) displayDataLog(RC, 0, data, 1, 3)

rcdisplay.DisplayRate = 20;

pause(1.0);

rcdisplay.open();

keyboard

sim.stop();
