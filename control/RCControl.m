classdef RCControl < handle

    properties
        RC

        ControlTimer
        PlannerTimer

        ControlFcn
        PlannerFcn

        ControlFreq
        PlannerFreq

        isRunning
    end

    methods
        function obj = RCControl(RC, controlHandle, plannerHandle)
            obj.RC = RC;
            obj.ControlFreq = 10;
            obj.ControlFcn = controlHandle;
            obj.PlannerFreq = 0.5;
            obj.PlannerFcn = plannerHandle;
            obj.isRunning = false;
        end

        function start(obj)
            if ~obj.isRunning

                obj.RC.clearLogs();

                fprintf("Starting RC Planner @ %.1f Hz. \n", obj.PlannerFreq)

                % planner timer
                obj.PlannerTimer = timer('Period', 1/obj.PlannerFreq, ...
                    'ExecutionMode', 'fixedRate', ...
                    'TimerFcn', @(~,~) obj.PlannerFcn(obj.RC));
                start(obj.PlannerTimer);

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

                stop(obj.PlannerTimer)
                delete(obj.PlannerTimer)
                obj.PlannerTimer = [];

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

