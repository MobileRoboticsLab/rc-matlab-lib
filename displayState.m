function displayState(RC)

% Create figure
fig = figure('Name', 'RC Car State', 'NumberTitle', 'off', ...
    'Position', [100, 100, 800, 600]);

% Figure event functions
fig.KeyPressFcn = @keyPress;
fig.KeyReleaseFcn = @keyRelease;
fig.CloseRequestFcn = @closeFig;

% RC command variables
speedCmd = 0;
steerCmd = 0;

% Display plot data object
display = plotRCState(RC, []);

% Display timers
keyboardCommandTimer = timer('TimerFcn', @(~,~) sendCommands, ...
    'Period', 0.05, 'ExecutionMode', 'fixedRate');
start(keyboardCommandTimer);
displayUpdateTimer = timer('TimerFcn', @(~,~) updateDisplay, ...
    'Period', 0.075, 'ExecutionMode', 'fixedRate');
start(displayUpdateTimer)

%% Functions

    function sendCommands()
        if RC.isStopped
            setSpeed(RC, speedCmd)
            setSteeringAngle(RC, steerCmd)
        end
    end

    function updateDisplay()
        display = plotRCState(RC, display);
    end

    function keyPress(~, evt)
        switch evt.Key
            case 'w'
                speedCmd = RC.Options.SpeedLimit;
            case 'a'
                steerCmd = RC.Options.SteerLimitMax;
            case 's'
                speedCmd = -RC.Options.SpeedLimitReverse;
            case 'd'
                steerCmd = RC.Options.SteerLimitMin;
            case 'esc'
                close(fig)
            case 'space'
                if RC.isStopped
                    RC.go
                else
                    RC.stop
                end
        end
    end

    function keyRelease(~, evt)
        switch evt.Key
            case 'w'
                speedCmd = 0;
            case 'a'
                steerCmd = 0;
            case 's'
                speedCmd = 0;
            case 'd'
                steerCmd = 0;
        end
    end

    function closeFig(~,~)
        if isvalid(keyboardCommandTimer)
            stop(keyboardCommandTimer)
            delete(keyboardCommandTimer)
        end
        if isvalid(displayUpdateTimer)
            stop(displayUpdateTimer)
            delete(displayUpdateTimer)
        end
        delete(gcf)
        disp("Closed GUI.")
    end

end