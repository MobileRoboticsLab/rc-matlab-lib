%% RC Car Simulation Shutdown
function stopSimulation()

if exist('RC', 'var')
    RC.stop
end

clear
STOP

% Shut down ROS Core
rosshutdown