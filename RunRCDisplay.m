close all
clear rcdisplay

rcdisplay = RCDisplay(RC, 1, 1, ...
    {@displayRCState}, ...
    {@attachKeyboardControl});
%    @displayLidarScan
%    @(RC, ~, data) displayDataLog(RC, 0, data, 1, 2)
%    @(RC, ~, data) displayDataLog(RC, 0, data, 1, 3)

rcdisplay.DisplayRate = 20;

rcdisplay.open();