function TestPlannerFcn(RC)
disp("Running Planner")

persistent lastTime
currentTime = datetime('now');

if isempty(RC.DataLog1)
    RC.DataLog3 = 0;
else
    deltaTime = seconds(currentTime - lastTime);
    RC.DataLog3 = [RC.DataLog3; RC.DataLog3(end) + deltaTime];
end

RC.DataLog4 = cos(RC.DataLog3);

lastTime = currentTime;