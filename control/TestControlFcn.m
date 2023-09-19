function TestControlFcn(RC)
disp("Running Control")

persistent lastTime
currentTime = datetime('now');

if isempty(RC.DataLog1)
    RC.DataLog1 = 0;
else
    deltaTime = seconds(currentTime - lastTime);
    RC.DataLog1 = [RC.DataLog1; RC.DataLog1(end) + deltaTime];
end

RC.DataLog2 = sin(RC.DataLog1);

lastTime = currentTime;