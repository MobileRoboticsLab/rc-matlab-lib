function keyPress(RC, key)

switch key
    case 'w'
        setSpeed(RC, RC.Options.SpeedLimit)
    case 'a'
        setSteeringAngle(RC, RC.Options.SteerLimitMax)
    case 's'
        setSpeed(RC, -RC.Options.SpeedLimitReverse)
    case 'd'
        setSteeringAngle(RC, RC.Options.SteerLimitMin)
end

end