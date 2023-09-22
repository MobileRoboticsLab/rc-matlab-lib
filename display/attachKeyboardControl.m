function attachmentData = attachKeyboardControl(RC, display, attachmentData)
if isempty(attachmentData)
    display.Figure.KeyPressFcn = @(~,evt) keyPress(RC, evt.Key);
    display.Figure.KeyReleaseFcn = @(~,evt) keyRelease(RC, evt.Key);
    RC.NextControl = [0; 0];
    attachmentData = 1;
    disp("Attached keyboard.")
end
setSpeed(RC, RC.NextControl(1));
setSteeringAngle(RC, RC.NextControl(2));
end

function keyPress(RC, key)
switch key
    case 'w'
        RC.NextControl(1) = RC.MaxSpeed;
    case 'a'
        RC.NextControl(2) = RC.MaxSteerAngle;
    case 's'
        RC.NextControl(1) = RC.MinSpeed;
    case 'd'
        RC.NextControl(2) = RC.MinSteerAngle;
end
end

function keyRelease(RC, key)
switch key
    case 'w'
        RC.NextControl(1) = 0;
    case 'a'
        RC.NextControl(2) = 0;
    case 's'
        RC.NextControl(1) = 0;
    case 'd'
        RC.NextControl(2) = 0;
end
end