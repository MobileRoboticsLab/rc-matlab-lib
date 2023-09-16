function opts = RCOptions()

% Create new RC options struct
opts = struct;

% Speed conversion: ERPM -> m/s
opts.DriveGain = 3500;
opts.DriveOffset = 0;

% Steer conversion: ? -> rads
opts.SteerGain = 0.95;
opts.SteerOffset = 0.40;

% DO NOT TOUCH! >:(
opts.SpeedLimit = 1.0; % m/s
opts.SpeedLimitReverse = 0.75; % m/s
opts.SteerLimitMin = -0.25; % rad
opts.SteerLimitMax = +0.25; % rad
