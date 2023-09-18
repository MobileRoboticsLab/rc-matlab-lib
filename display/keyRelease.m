function keyRelease(RC, key)

switch key
    case 'w'
        setSpeed(RC, 0)
    case 'a'
        setSteeringAngle(RC, 0)
    case 's'
        setSpeed(RC, 0)
    case 'd'
        setSteeringAngle(RC, 0)
end

end