function WallFollowerControlFcn(RC)

% Desired distance to the right wall in meters
desiredDistance = 0.5; % m

% Proportional control gain
KP = 0.5;

% Derivative control gain
KD = 0.5;

% Persistent variables to store the last error and time
% These are required for the derivative control part
persistent lastDistanceError % Error in distance from the previous iteration
persistent lastTime % Previous time instance when the function was called

% Get the current time
currentTime = datetime('now');

% Obtain the current distance to the right wall
currentDistance = getDistanceToRightWall(RC); % m

% Calculate the error in distance
distanceError = currentDistance - desiredDistance; % m

% Set default steering angle
steeringAngle = nan;

% If lastDistanceError isn't empty, we can calculate the derivative of the error.
% On the first function call, this will be skipped as no previous error is available.
if ~isempty(lastDistanceError)

    % Calculate the change in distance error since last iteration
    deltaDistanceError = distanceError - lastDistanceError; % m
    
    % Calculate the time difference from the last function call
    deltaTime = seconds(currentTime - lastTime); % s
    
    % Rate of change of error with respect to time
    rateOfChangeError = deltaDistanceError / deltaTime; % m/s

    % Calculate the steering angle using PD control law
    steeringAngle = -KP * distanceError - KD * rateOfChangeError;

    % Set the steering angle for the remote controlled vehicle
    setSteeringAngle(RC, steeringAngle);
    
    % Set a constant speed for the remote controlled vehicle
    setSpeed(RC, 0.5); % constant speed

    % Display the current information for debugging or monitoring
    fprintf("Distance Error = %.3f m\n", distanceError);
    fprintf("Rate of Change of Error = %.3f m/s\n", rateOfChangeError);
    fprintf("Steering Angle: %.4f rad\n", steeringAngle);
end

% Update the persistent variables for the next function call
lastDistanceError = distanceError;
lastTime = currentTime;

% Store time and error data for analysis
if isempty(RC.DataLog1)
    RC.DataLog1 = 0;
else
    RC.DataLog1 = [RC.DataLog1; RC.DataLog1(end) + deltaTime];
end
RC.DataLog2 = [RC.DataLog2; distanceError];
RC.DataLog3 = [RC.DataLog3; steeringAngle];

end