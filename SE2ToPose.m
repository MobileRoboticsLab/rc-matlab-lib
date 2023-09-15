function pose = SE2ToPose(state)

% Extract x, y and yaw from the input vector
x = state(1);
y = state(2);
theta = state(3);

% Convert yaw (rotation about Z axis) to a quaternion
q = eul2quat([theta 0 0], 'ZYX');

% Create the PoseStamped message
pose = rosmessage('geometry_msgs/PoseStamped');

% Fill in the header
pose.Header.FrameId = "base_link";
pose.Header.Stamp = rostime('now');

% Fill in the position
pose.Pose.Position.X = x;
pose.Pose.Position.Y = y;
pose.Pose.Position.Z = 0; % Assuming a 2D plane

% Fill in the orientation (quaternion)
pose.Pose.Orientation.W = q(1);
pose.Pose.Orientation.X = q(2);
pose.Pose.Orientation.Y = q(3);
pose.Pose.Orientation.Z = q(4);

end

