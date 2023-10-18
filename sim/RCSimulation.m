classdef RCSimulation < handle

    properties

        Node

        SimulationPeriod
        SimulationTimer

        PosePublisher
        ScanPublisher

        MotorSpeedSubscriber
        ServoPositionSubscriber
        SysCommandSubscriber

        WheelBaseLength
        State
        Control
        Scan

        Obstacles

        isRunning
    end

    methods
        function obj = RCSimulation()
            obj.Node = ros.Node('/rc_sim_matlab_node');

            obj.SimulationPeriod = 1/10;
            obj.isRunning = false;

            obj.WheelBaseLength = 0.3;
            obj.State = [0; 0; 0];
            obj.Control = [0; 0];

            obj.Scan = exampleLaserScan();

            obj.PosePublisher = ros.Publisher(obj.Node, ...
                "/slam_out_pose", "geometry_msgs/PoseStamped");
            obj.ScanPublisher = ros.Publisher(obj.Node, ...
                "/scan", "sensor_msgs/LaserScan");
            obj.publishScan()

            % obj.MapPublisher = ros.Publisher(obj.Node, ...
            %     "/map", "nav_msgs/OccupancyGrid");

            obj.MotorSpeedSubscriber = ros.Subscriber(obj.Node, ...
                "/commands/motor/speed", "std_msgs/Float64", ...
                @(~,msg) motorSpeedCallback(obj, msg));
            obj.ServoPositionSubscriber = ros.Subscriber(obj.Node, ...
                "/commands/servo/position", "std_msgs/Float64", ...
                @(~,msg) servoPositionCallback(obj, msg));
            obj.SysCommandSubscriber = ros.Subscriber(obj.Node, ...
                "/syscommand", "std_msgs/String", ...
                @(~,msg) sysCommandCallback(obj, msg));

            fprintf("RC Simulation Initialized.\n")

        end

        function start(obj)
            if ~obj.isRunning

                obj.SimulationTimer = timer('TimerFcn', {@(~,~) simulate(obj)}, ...
                    'ExecutionMode', 'fixedRate', 'Period', obj.SimulationPeriod);
                start(obj.SimulationTimer)

                obj.isRunning = true;
                fprintf("RC Simulation started.\n")
            else
                fprintf("Simulation is already running.\n")
            end
        end

        function stop(obj)
            if obj.isRunning

                stop(obj.SimulationTimer)
                delete(obj.SimulationTimer)
                obj.SimulationTimer = [];

                obj.isRunning = false;
                fprintf("RC Simulation stopped.\n")
            else
                fprintf("Simulation is already stopped.\n")
            end
        end

        function simulate(obj)
            obj.State = obj.State + ...
                ackermannODE(0, obj.State, obj.Control, obj.WheelBaseLength)*obj.SimulationPeriod;
            obj.publishPose();
            if ~isempty(obj.Obstacles)
                obj.Scan = simLidarScan(obj.State, obj.Obstacles);
                obj.publishScan();
            end
        end

        function motorSpeedCallback(obj, msg)
            obj.Control(1) = msg.Data / 3500;
        end

        function servoPositionCallback(obj, msg)
            obj.Control(2) = (msg.Data - 0.40) / 0.95;
        end

        function sysCommandCallback(obj, msg)
            if (msg.Data == "reset")
                obj.State = [0; 0; 0;];
            end
        end

        function publishPose(obj)
            pose = convertSE2ToPose(obj.State);
            send(obj.PosePublisher, pose);
        end

        function publishScan(obj)
            send(obj.ScanPublisher, obj.Scan);
        end

        % function publishMap()
        %     % future use
        % end
    end
end

