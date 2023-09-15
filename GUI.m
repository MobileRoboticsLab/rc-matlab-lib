function GUI(RC)

% Stop RC when opening the GUI
if ~RC.isStopped
    RC.stop
end

% Create figure
fig = figure('Name', 'RC CAR GUI', 'NumberTitle', 'off', ...
    'Position', [100, 100, 800, 600]);

% Initialize key callbacks
fig.KeyPressFcn = @keyPress;
fig.CloseRequestFcn = @closeFig;

% Display plot data
display1Plot = [];
display2Plot = [];
display3Plot = [];
display4Plot = [];

% Call external functions to create displays
display1Handle = @(RC, plot) plotDataLog(RC, plot, 1, 2);
display2Handle = @(RC, plot) plotDataLog(RC, plot, 1, 3);
display3Handle = @plotLidarScan;
display4Handle = @plotRCState;

% Start display update timer
displayUpdateTimer = timer('TimerFcn', {@(~,~) updateDisplays()}, ...
    'ExecutionMode', 'fixedRate', 'Period', 0.075);
start(displayUpdateTimer);

%% GUI FUNCTIONS

    function keyPress(~, evt)
        switch evt.Key
            case 'esc'
                close(fig)
            case 'space'
                if RC.isStopped
                    stop(keyboardCommandTimer)
                    RC.go
                else
                    RC.stop
                    start(keyboardCommandTimer)
                end
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

    function updateDisplays()
        % Call external functions to create displays
        subplot(2,2,1);
        display1Plot = display1Handle(RC, display1Plot);

        subplot(2,2,2);
        display2Plot = display2Handle(RC, display2Plot);

        subplot(2,2,3);
        display3Plot = display3Handle(RC, display3Plot);

        subplot(2,2,4);
        display4Plot = display4Handle(RC, display4Plot);
    end
end

