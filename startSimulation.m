%% RC Car Simulation Startup
function startSimulation()

%% ROS Connection

% Start ROS Core on localhost
rosinit("http://localhost:11311")

% ROS Node Handle
simNode = ros.Node('/rc_matlab_sim');

% Publishers
simPosePublisher = ros.Publisher(simNode, ...
    "/slam_out_pose", "geometry_msgs/PoseStamped");
simScanPublisher = ros.Publisher(simNode, ...
    "/scan", "sensor_msgs/LaserScan");

% simMapPublisher = ros.Publisher(simNode, ...
%     "/map", "nav_msgs/OccupancyGrid");

% Subscribers
simMotorSpeedSubscriber = ros.Subscriber(simNode, ...
    "/commands/motor/speed", "std_msgs/Float64", @motorSpeedCallback);
simServoPositionSubscriber = ros.Subscriber(simNode, ...
    "/commands/servo/position", "std_msgs/Float64", @servoPositionCallback);
simSysCommandSubscriber = ros.Subscriber(simNode, ...
    "/syscommand", "std_msgs/String", @sysCommandCallback);

%% Start Simulation

% Vehicle properties
wheelbaseLength = 1.0;
currentState = [0; 0; 0];
currentControl = [0; 0];

simulationPeriod = 0.01;
simulationTimer = timer('TimerFcn', {@(~,~) simulate()}, ...
    'ExecutionMode', 'fixedRate', 'Period', simulationPeriod);
start(simulationTimer)

%% Start Publisher Timers

posePublishTimer = timer('TimerFcn', {@(~,~) publishPose()}, ...
    'ExecutionMode', 'fixedRate', 'Period', 0.075);
start(posePublishTimer)

scanPublishTimer = timer('TimerFcn', {@(~, ~) publishScan}, ...
    'ExecutionMode', 'fixedRate', 'Period', 1.0);
start(scanPublishTimer)

% mapPublishTimer = timer('TimerFcn', {@(~, ~) publishMap}, ...
%     'ExecutionMode', 'fixedRate', 'Period', 1.0);
% start(mapPublishTimer)

%% FUNCTIONS

    % Ackermann steering dynamics
    function simulate()
        currentState = currentState + ...
            ackermannODE(0, currentState, currentControl, wheelbaseLength)*simulationPeriod;
    end

    function motorSpeedCallback(~, msg)
        currentControl(1) = msg.Data / 3500;
    end

    function servoPositionCallback(~, msg)
        currentControl(2) = (msg.Data - 0.40) / 0.95;
    end

    function sysCommandCallback(~, ~)
        currentState = [0; 0; 0;];
    end

    function publishPose()
        pose = SE2ToPose(currentState);
        send(simPosePublisher, pose);
    end

    function publishScan()
        send(simScanPublisher, exampleLaserScan());
    end

    % function publishMap()
    %     % future use
    % end

end
