% Sets the desired speed [m/s]
function setSpeed(obj, speed)

% Make sure speed is within the speed limits
speed = max(min(speed, obj.Options.SpeedLimit), -obj.Options.SpeedLimitReverse);

% Convert to erpm
motorSpeed = obj.Options.DriveGain * speed + obj.Options.DriveOffset;

% Set the motor speed
setMotorSpeed(obj, motorSpeed);

end