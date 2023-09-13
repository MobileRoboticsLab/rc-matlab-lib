function opts = RCOptions()

% Create new RC options struct
opts = struct;

% ROS_MASTER_URI
opts.URI = "http://10.42.0.1:11311";

% Control functions
opts.PlannerFcn = @TestPlannerFcn;
opts.ControlFcn = @TestControlFcn;

% Timer frequencies
opts.PlannerFreq = 0.5; % Hz
opts.ControlFreq = 10; % Hz

% Speed conversion: ERPM -> m/s
opts.DriveGain = 3500;
opts.DriveOffset = 0;

% Steer conversion: ? -> rads
opts.SteerGain = 0.95;
opts.SteerOffset = 0.40;

% DO NOT TOUCH! >:(
opts.SpeedLimit = 0.5; % m/s
opts.SpeedLimitReverse = 0.25; % m/s
opts.SteerLimitMin = -0.25; % rad
opts.SteerLimitMax = +0.25; % rad
