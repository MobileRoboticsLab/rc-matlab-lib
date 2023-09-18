% Sends a command to reset the map
function resetMap(obj)

% Create a ROS message
msg = rosmessage(obj.SysCommandPublisher);

% Set the message data to the "reset" command
msg.Data = "reset";

% Publish the message
send(obj.SysCommandPublisher, msg);

end