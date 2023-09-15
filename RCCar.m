% Jonathan Boylan
% 09-12-2023

%% RC Car
classdef RCCar < handle

    % Define properties for the RCController class.
    properties
        Node    % ROS node.
        Options % User-defined options

        % Subscribers listen for messages on specific topics.
        PoseSubscriber
        LidarSubscriber
        MapSubscriber

        % Publishers send messages to specific topics.
        MotorSpeedPublisher
        ServoPositionPublisher
        SysCommandPublisher

        % Timer objects for planner and controller functions.
        PlannerTimer
        ControlTimer

        % State properties for the vehicle.
        LastState    % Last state of the vehicle. (Automatic)
        CurrentState % Current state [x, y, theta] of the vehicle. (Automatic)
        NextState    % Predicted or desired next state. (Set by user)
        GoalState    % Target state that the vehicle is trying to reach. (Set by user)

        % Control properties for the vehicle
        CurrentControl % Curent control [v, gamma] of the vehicle. (Automatic)
        NextControl    % Predicted or desired next control. (Set by user)

        % Utility properties for storing global data
        DataLog1
        DataLog2
        DataLog3
        DataLog4
        DataLog5

        % Property keeping track of 
        isStopped
    end

    methods

        % Constructor
        function obj = RCCar(options)

            % Use default RCOptions.
            arguments
                options = RCOptions
            end

            obj.Options = options;

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

            obj.isStopped = true;
            obj.CurrentControl = [0; 0];

            fprintf("RC Car Initialized.\n")
        end


        % Start the RC functions
        function go(obj)

            if ~obj.isStopped
                fprintf("RC Car already going.\n")
                return
            end

            fprintf("Starting RC Planner @ %.1f Hz. \n", obj.Options.PlannerFreq)
            
            obj.isStopped = false;

            % planner timer
            obj.PlannerTimer = timer('Period', 1/obj.Options.PlannerFreq, ...
                'ExecutionMode', 'fixedRate', ...
                'TimerFcn', @(~,~) obj.Options.PlannerFcn(obj));
            start(obj.PlannerTimer);

            fprintf("Starting RC Control @ %.1f Hz. \n", obj.Options.ControlFreq)

            % control timer
            obj.ControlTimer = timer('Period', 1/obj.Options.ControlFreq, ...
                'ExecutionMode', 'fixedRate', ...
                'TimerFcn', @(~,~) obj.Options.ControlFcn(obj));
            start(obj.ControlTimer);

        end

        % Stop and delete the timers.
        function stop(obj)

            if obj.isStopped
                disp("RC already stopped. Use 'STOP' command to end all timers.")
            end

            fprintf("Stopping RC Planner.\n")
            if isvalid(obj.PlannerTimer)
                stop(obj.PlannerTimer);
                delete(obj.PlannerTimer);
            end

            fprintf("Stopping RC Control.\n")
            if isvalid(obj.ControlTimer)
                stop(obj.ControlTimer);
                delete(obj.ControlTimer);
            end

            obj.isStopped = true;

            % Clear timer properties.
            obj.PlannerTimer = [];
            obj.ControlTimer = [];
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

        % Sends a command to set the motor's speed. [erpm]
        function setMotorSpeed(obj, speedValue)
            % Create a ROS message
            msg = rosmessage(obj.MotorSpeedPublisher);

            % Set the desired speed value
            msg.Data = speedValue;

            % Publish the message
            send(obj.MotorSpeedPublisher, msg);

            % Update control
            obj.CurrentControl(1) = speedValue;
        end

        % Sends a command to set the servo's position.
        function setServoPosition(obj, positionValue)
            % Create a ROS message
            msg = rosmessage(obj.ServoPositionPublisher);

            % Set the desired position value
            msg.Data = positionValue;

            % Publish the message
            send(obj.ServoPositionPublisher, msg);
            
            % Update control
            obj.CurrentControl(2) = positionValue;
        end

        % Callback function for PoseSubscriber. This is called whenever a new pose
        % message is received. The pose information is converted to SE(2) state
        % space and saved to CurrentState.
        function poseCallback(obj, ~, message)
            obj.LastState = obj.CurrentState;
            obj.CurrentState = poseToSE2(message);
        end

    end % End of methods

end % End of classdef
