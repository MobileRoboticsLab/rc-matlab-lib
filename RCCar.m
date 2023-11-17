% Jonathan Boylan
% 09-12-2023

%% RC Car
classdef RCCar < handle

    % Define properties for the RCController class.
    properties
        Node    % ROS node.

        % Subscribers listen for messages on specific topics.
        PoseSubscriber
        LidarSubscriber
        MapSubscriber

        % Publishers send messages to specific topics.
        MotorSpeedPublisher
        ServoPositionPublisher
        SysCommandPublisher

        % State properties for the vehicle.
        LastState    % Last state of the vehicle. (Automatic)
        CurrentState % Current state [x, y, theta] of the vehicle. (Automatic)
        NextState    % Predicted or desired next state. (Set by user)
        GoalState    % Target state that the vehicle is trying to reach. (Set by user)

        % Time information
        LastTime
        CurrentTime

        % Velocity information
        LastVelocity
        CurrentVelocity

        % Control properties for the vehicle
        CurrentControl % Curent control [v, gamma] of the vehicle. (Automatic)
        NextControl    % Predicted or desired next control. (Set by user)

        % Utility properties for storing global data
        DataLog1
        DataLog2
        DataLog3
        DataLog4
        DataLog5

        % RC Params
        WheelBaseLength
        DriveGain
        DriveOffset
        SteerGain
        SteerOffset
        MaxSpeed
        MinSpeed
        MaxSteerAngle
        MinSteerAngle

    end

    methods

        % Constructor
        function obj = RCCar()

            fprintf("Connecting to RC Car...\n");

            % Distance between front and back axles
            obj.WheelBaseLength = 0.3;

            % Speed conversion: ERPM -> m/s
            obj.DriveGain = 3500;
            obj.DriveOffset = 0;

            % Steer conversion: ? -> rads
            obj.SteerGain = 0.95;
            obj.SteerOffset = 0.40;

            % DO NOT TOUCH! >:(
            obj.MaxSpeed = 1.0; % m/s
            obj.MinSpeed = -0.75; % m/s
            obj.MaxSteerAngle = +0.25; % rad
            obj.MinSteerAngle = -0.25; % rad

            obj.Node = ros.Node('/rc_car_matlab_node');

            % Subscribers
            obj.PoseSubscriber = ros.Subscriber(obj.Node, ...
                '/slam_out_pose', 'geometry_msgs/PoseStamped', ...
                @(src, msg) obj.poseCallback(src, msg));
            obj.LidarSubscriber = ros.Subscriber(obj.Node, ...
                '/scan', 'sensor_msgs/LaserScan');
            obj.MapSubscriber = ros.Subscriber(obj.Node, ...
                '/map', 'nav_msgs/OccupancyGrid');

            % Publishers
            obj.MotorSpeedPublisher = ros.Publisher(obj.Node, ...
                '/commands/motor/speed', 'std_msgs/Float64');
            obj.ServoPositionPublisher = ros.Publisher(obj.Node, ...
                '/commands/servo/position', 'std_msgs/Float64');
            obj.SysCommandPublisher = ros.Publisher(obj.Node, ...
                '/syscommand', 'std_msgs/String');

            obj.CurrentState = [0; 0; 0];
            obj.CurrentVelocity = [0; 0; 0];
            obj.CurrentControl = [0; 0];
            obj.CurrentTime = datetime('now');

            obj.DataLog1 = [];
            obj.DataLog2 = [];
            obj.DataLog3 = [];
            obj.DataLog4 = [];
            obj.DataLog5 = [];

            pause(5.0)
            fprintf("RC Car Connected.\n")
        end

        % Get the latest pose message
        function pose = getPose(obj)
            pose = obj.PoseSubscriber.LatestMessage;
        end

        % Get the latest map message
        function map = getMap(obj)
            map = obj.MapSubscriber.LatestMessage;
        end

        % Get the latest LIDAR scan
        function scan = getScan(obj)
            scan = obj.LidarSubscriber.LatestMessage;
        end

        % Sends a command to set the motor's speed. [m/s]
        function setSpeed(obj, speedValue)

            % Make sure speed is within the speed limits
            speedValue = max(min(speedValue, obj.MaxSpeed), obj.MinSpeed);

            % Convert to erpm
            motorSpeed = obj.DriveGain * speedValue + obj.DriveOffset;

            % Create a ROS message
            msg = rosmessage(obj.MotorSpeedPublisher);

            % Set the desired speed value
            msg.Data = motorSpeed;

            % Publish the message
            send(obj.MotorSpeedPublisher, msg);

            % Update control
            obj.CurrentControl(1) = speedValue;
        end

        % Sends a command to set the servo's position.
        function setSteeringAngle(obj, angleValue)

            % Make sure angle is within the steering limits
            angleValue = max(min(angleValue, obj.MaxSteerAngle), obj.MinSteerAngle);

            % Convert to servo position
            servoPos = obj.SteerGain * angleValue + obj.SteerOffset;

            % Create a ROS message
            msg = rosmessage(obj.ServoPositionPublisher);

            % Set the desired position value
            msg.Data = servoPos;

            % Publish the message
            send(obj.ServoPositionPublisher, msg);

            % Update control
            obj.CurrentControl(2) = angleValue;
        end

        % Callback function for PoseSubscriber. This is called whenever a new pose
        % message is received. The pose information is converted to SE(2) state
        % space and saved to CurrentState.
        function poseCallback(obj, ~, message)
            obj.LastState = obj.CurrentState;
            obj.CurrentState = convertPoseToSE2(message);
            obj.LastTime = obj.CurrentTime;
            obj.CurrentTime = datetime('now');
            obj.LastVelocity = obj.CurrentVelocity;
            obj.CurrentVelocity = (obj.CurrentState - obj.LastState) ./ ...
                seconds(obj.CurrentTime - obj.LastTime);
        end

        function clearLogs(obj)
            obj.DataLog1 = [];
            obj.DataLog2 = [];
            obj.DataLog3 = [];
            obj.DataLog4 = [];
            obj.DataLog5 = [];
        end

        % Typedefs
        function x = X(obj)
            x = obj.CurrentState(1);
        end

        function y = Y(obj)
            y = obj.CurrentState(2);
        end

        function phi = Phi(obj)
            phi = obj.CurrentState(3);
        end

        function vx = Vx(obj)
            vx = obj.CurrentVelocity(1);
        end

        function vy = Vy(obj)
            vy = obj.CurrentVelocity(2);
        end

        function v = V(obj)
            v = sqrt(sum(obj.CurrentVelocity(1:2).^2));
        end

        function omega = Omega(obj)
            omega = obj.CurrentVelocity(3);
        end

        % Retrieves the occupancy value of the map at a specified (x, y) location.
        function occupancy = getOccupancy(obj, x, y)
            
            % Get the latest map data
            map = obj.getMap();
            
            % Convert the real-world (x, y) coordinates to grid/map
            % coordinates based on map resolution and origin
            x_grid = round((x - map.Info.Origin.Position.X) / map.Info.Resolution);
            y_grid = round((y - map.Info.Origin.Position.Y) / map.Info.Resolution);
            
            % Check if the converted grid coordinates are within the valid map boundaries
            if x_grid < 1 || x_grid > map.Info.Width || ...
               y_grid < 1 || y_grid > map.Info.Height
                fprintf("Provided XY location (%f, %f) is out of the map's boundaries.\n", x, y);
                occupancy = -1;  % Return an error code for out-of-bound location
                return;
            end
            
            % Convert the 2D grid coordinates into a 1D index for the map data array
            index = sub2ind([map.Info.Width, map.Info.Height], x_grid, y_grid);
            
            % Fetch and return the occupancy value from the map data at the calculated index
            occupancy = map.Data(index);
            
        end

        % Sends a command to reset the map
        function resetMap(obj)

            % Create a ROS message
            msg = rosmessage(obj.SysCommandPublisher);

            % Set the message data to the "reset" command
            msg.Data = "reset";
            
            % Publish the message
            send(obj.SysCommandPublisher, msg);
        end

        % Save the map to a .mat file
        function saveMap(obj)

            % Convert to Navigation Toolbox grid
            saved_map = readOccupancyGrid(obj.getMap());

            % Save to workspace
            save("OccupancyGridSave.mat", "saved_map");
        end

    end % End of methods

end % End of classdef
