%% RC Keyboard Control
% Jonathan Boylan
% 9/21

clc
close all
CLEAR

%%

RC = RCCar();

pause(1.0)

rcdisplay = RCDisplay(RC, 1, 1, ...
    {@displayRCState}, ...
    {@attachKeyboardControl});

rcdisplay.DisplayRate = 20;

pause(1.0);

rcdisplay.open();
