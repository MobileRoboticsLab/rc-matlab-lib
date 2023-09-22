function plotData = displayRCState(RC, ~, plotData)

if isempty(RC.CurrentState)
    return
end

%% CAR INFO

% RC Car properties
carWidth = 0.1; % m
carLength = 0.3; % m

% Get current state and control
position = RC.CurrentState(1:2); % x, y
theta = RC.CurrentState(3); % theta
% velocity = RC.CurrentControl(1);
gamma = RC.CurrentControl(2);

% carWheelbaseLength = 0.3
% carTrackWidth = 0.2
% rho = carWheelbaseLength/tan(gamma);
% gamma_left = atan2(carWheelbaseLength, rho + carTrackWidth/2);
% gamma_right = atan2(carWheelbaseLength, rho - carTrackWidth/2);

% Car body points
body_RC = [+carLength/2, -carLength/2, -carLength/2 , +carLength/2;
           +carWidth/2, +carWidth/2, -carWidth/2, -carWidth/2];


%% WHEEL INFO

% Wheel properties
wheelWidth = 0.05; % m
wheelLength = 0.1; % m
axleOffsetX = 0.85*(carLength/2); % m
axleOffsetY = (carWidth + wheelWidth)/2; % m

% Wheel body points
wheel = [+wheelLength/2, -wheelLength/2, -wheelLength/2 , +wheelLength/2;
         +wheelWidth/2, +wheelWidth/2, -wheelWidth/2, -wheelWidth/2];

%% SETUP FRAMES

% FRAMES:
% G: Global frame
% RC: Car frame (rot: theta)
% FW: Front axle frame (rot: theta + gamma)
% BW: Back axle frame (rot: theta)

% Translation: Ground frame to RC frame
G_trans_RC = position;

% Rotation: Ground frame to RC frame
G_rot_RC = [cos(theta), -sin(theta);
            sin(theta), cos(theta)];

% Translations: Front/back axle to left and right wheel frames
XW_trans_WL = [0; +axleOffsetY];
XW_trans_WR = [0; -axleOffsetY];

% Translations: RC frame to front and back axle frames
RC_trans_FW = [+axleOffsetX; 0];
RC_trans_BW = [-axleOffsetX; 0];

% Rotation: RC frame to front axle frame
RC_rot_FW = [cos(gamma), -sin(gamma);
             sin(gamma), cos(gamma)];

% RC_rot_FL = [cos(gamma_left), -sin(gamma_left);
%              sin(gamma_left), cos(gamma_left)];
% RC_rot_FR = [cos(gamma_right), -sin(gamma_right);
%              sin(gamma_right), cos(gamma_right)];

%% APPLY TRANSFORMS

% Body transformation
body_G = G_trans_RC + G_rot_RC*body_RC;

% Wheels transformations
wheelFL_G = G_trans_RC + G_rot_RC*(RC_trans_FW + (RC_rot_FW*wheel + XW_trans_WL)); % front left
wheelBL_G = G_trans_RC + G_rot_RC*(RC_trans_BW + (wheel + XW_trans_WL)); % back left
wheelBR_G = G_trans_RC + G_rot_RC*(RC_trans_BW + (wheel + XW_trans_WR)); % back right
wheelFR_G = G_trans_RC + G_rot_RC*(RC_trans_FW + (RC_rot_FW*wheel + XW_trans_WR)); % front right

% wheelFL_G = G_trans_RC + G_rot_RC*(RC_trans_FW + (RC_rot_FL*wheel + XW_trans_WL));
% wheelFR_G = G_trans_RC + G_rot_RC*(RC_trans_FW + (RC_rot_FR*wheel + XW_trans_WR));

%% PLOT

if isempty(plotData)
    hold on
    grid on
    plotData = {};
    plotData{1} = fill(body_G(1,:), body_G(2,:), 'g'); % car plot
    plotData{2} = fill(wheelFL_G(1,:), wheelFL_G(2,:), 'k'); % Front Left
    plotData{3} = fill(wheelBL_G(1,:), wheelBL_G(2,:), 'k'); % Back Left
    plotData{4} = fill(wheelBR_G(1,:), wheelBR_G(2,:), 'k'); % Back Right
    plotData{5} = fill(wheelFR_G(1,:), wheelFR_G(2,:), 'k'); % Front Right
else
    set(plotData{1}, 'xdata', body_G(1,:), 'ydata', body_G(2,:))
    set(plotData{2}, 'xdata', wheelFL_G(1,:), 'ydata', wheelFL_G(2,:))
    set(plotData{3}, 'xdata', wheelBL_G(1,:), 'ydata', wheelBL_G(2,:))
    set(plotData{4}, 'xdata', wheelBR_G(1,:), 'ydata', wheelBR_G(2,:))
    set(plotData{5}, 'xdata', wheelFR_G(1,:), 'ydata', wheelFR_G(2,:))
end

halfWindowSize = 1.0;
axis([G_trans_RC(1) - halfWindowSize, ...
    G_trans_RC(1) + halfWindowSize, ...
    G_trans_RC(2) - halfWindowSize, ...
    G_trans_RC(2) + halfWindowSize]);

end

