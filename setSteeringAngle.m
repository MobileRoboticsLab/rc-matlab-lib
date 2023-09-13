% Sets the desired steering angle [rad]
function setSteeringAngle(obj, angle)

% Make sure angle is within the steering limits
angle = max(min(angle, obj.Options.SteerLimitMax), obj.Options.SteerLimitMin);

% Convert to servo position
servoPos = obj.Options.SteerGain * angle + obj.Options.SteerOffset;

% Set the servo position
setServoPosition(obj, servoPos);

end