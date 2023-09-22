function attachmentData = attachKeyboardControl2(RC, display, attachmentData, control2)
if isempty(attachmentData)
    display.Figure.KeyPressFcn = @(~,evt) keyPress(RC, evt.Key, control2);
    display.Figure.KeyReleaseFcn = @(~,evt) keyRelease(RC, evt.Key);
    RC.NextControl = [0; 0];
    attachmentData = 1;
    disp("Attached keyboard.")
end
setSpeed(RC, RC.NextControl(1));
setSteeringAngle(RC, RC.NextControl(2));
end

function keyPress(RC, key, control2)
switch key
    case 'w'
        RC.NextControl(1) = RC.MaxSpeed;
    case 'a'
        RC.NextControl(2) = RC.MaxSteerAngle;
    case 's'
        RC.NextControl(1) = RC.MinSpeed;
    case 'd'
        RC.NextControl(2) = RC.MinSteerAngle;
    case 'space'
        if control2.isRunning
            control2.stop()
        else
            control2.start()
        end
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