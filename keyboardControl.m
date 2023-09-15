function keyboardControl(RC)

fig = figure('Name', 'Key Press Visualization', 'NumberTitle', 'off');

set(fig, 'KeyPressFcn', @keyPress)
set(fig, 'KeyReleaseFcn', @keyRelease)
set(fig, 'CloseRequestFcn', @closeFig);

speedCmd = 0;
steerCmd = 0;

% Create text boxes for WASD and the message with bigger size and proper alignment
boxSize = [0.25 0.25];
wText = uicontrol('Style', 'text', 'String', 'W', 'Units', 'normalized', ...
    'Position', [0.375 0.55 boxSize], 'FontSize', 24, 'BackgroundColor', [1 1 1]);
aText = uicontrol('Style', 'text', 'String', 'A', 'Units', 'normalized', ...
    'Position', [0.075 0.25 boxSize], 'FontSize', 24, 'BackgroundColor', [1 1 1]);
sText = uicontrol('Style', 'text', 'String', 'S', 'Units', 'normalized', ...
    'Position', [0.375 0.25 boxSize], 'FontSize', 24, 'BackgroundColor', [1 1 1]);
dText = uicontrol('Style', 'text', 'String', 'D', 'Units', 'normalized', ...
    'Position', [0.675 0.25 boxSize], 'FontSize', 24, 'BackgroundColor', [1 1 1]);

t = timer('TimerFcn', @(~,~) updateGUI(RC), 'Period', 0.1, 'ExecutionMode', 'fixedRate');
start(t);

    function keyPress(~, evt)
        if evt.Key == 'w'
            set(wText, 'BackgroundColor', [0 1 0]); % highlight when pressed
            speedCmd = RC.Options.SpeedLimit;
        elseif evt.Key == 'a'
            set(aText, 'BackgroundColor', [0 1 0]);
            steerCmd = RC.Options.SteerLimitMax;
        elseif evt.Key == 's'
            set(sText, 'BackgroundColor', [0 1 0]);
            speedCmd = -RC.Options.SpeedLimitReverse;
        elseif evt.Key == 'd'
            set(dText, 'BackgroundColor', [0 1 0]);
            steerCmd = RC.Options.SteerLimitMin;
        end
    end

    function keyRelease(~, evt)
        if evt.Key == 'w'
            set(wText, 'BackgroundColor', [1 1 1]); % un-highlight when released
            speedCmd = 0;
        elseif evt.Key == 'a'
            set(aText, 'BackgroundColor', [1 1 1]);
            steerCmd = 0;
        elseif evt.Key == 's'
            set(sText, 'BackgroundColor', [1 1 1]);
            speedCmd = 0;
        elseif evt.Key == 'd'
            set(dText, 'BackgroundColor', [1 1 1]);
            steerCmd = 0;
        end
    end

    function updateGUI(RC)
        % This function will periodically check and update the GUI
        setSpeed(RC, speedCmd);
        setSteeringAngle(RC, steerCmd);
    end

    function closeFig(~,~)
        if isvalid(t)
            stop(t)
            delete(t)
        end
        delete(gcf);
        disp("Closed GUI.")
    end

end
