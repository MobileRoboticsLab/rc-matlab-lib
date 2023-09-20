function setRotation(RC, rotation, forward_velocity, wheelbaseLength)

gamma = atan2(rotation * wheelbaseLength, forward_velocity);

setSteeringAngle(RC, gamma)

end