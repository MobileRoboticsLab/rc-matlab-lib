classdef RCControl < handle

    properties
        RC

        ControlTimer
        ControlFcn
        ControlFreq

        isRunning
    end

    methods
        function obj = RCControl(RC, controlFcn, controlFreq)
            obj.RC = RC;
            obj.ControlFreq = controlFreq;
            obj.ControlFcn = controlFcn;
            obj.isRunning = false;
        end

        function start(obj)
            if ~obj.isRunning

                obj.RC.clearLogs();

                fprintf("Starting RC Control @ %.1f Hz. \n", obj.ControlFreq)

                % control timer
                obj.ControlTimer = timer('Period', 1/obj.ControlFreq, ...
                    'ExecutionMode', 'fixedRate', ...
                    'TimerFcn', @(~,~) obj.ControlFcn(obj.RC));
                start(obj.ControlTimer);

                obj.isRunning = true;
            else
                fprintf("RC Control is already running.\n")
            end
        end

        function stop(obj)
            if obj.isRunning

                stop(obj.ControlTimer)
                delete(obj.ControlTimer)
                obj.ControlTimer = [];

                fprintf("RC Control stopped.\n")
                obj.isRunning = false;
            else
                fprintf("RC Control is already stopped.\n")
            end
        end
    end
end

