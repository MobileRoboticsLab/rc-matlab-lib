% Convert ROS Pose message to state vector in SE(2) space
function state = convertPoseToSE2(pose)

% Extract x and y positions from the pose message
x = pose.Pose.Position.X;
y = pose.Pose.Position.Y;

% Extract quaternion values from the pose message
qx = pose.Pose.Orientation.X;
qy = pose.Pose.Orientation.Y;
qz = pose.Pose.Orientation.Z;
qw = pose.Pose.Orientation.W;

% Convert the received quaternion to a yaw angle (theta) using
% the standard conversion formula
theta = atan2(2*(qw*qz + qx*qy), 1 - 2*(qy^2 + qz^2));

% Store the extracted 2D state (x, y, theta) in the CurrentState property
state = [x; y; theta];

end

