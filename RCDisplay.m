classdef RCDisplay < handle

    properties

        RC

        Rows
        Cols

        Figure
        isOpen

        FrameRate
        DisplayTimer

        DisplayFcns
        DisplayPlotData

    end

    methods
        function obj = RCDisplay(RC, rows, cols, varargin)
            addpath("displays/");
            obj.RC = RC;

            if (rows*cols ~= numel(varargin))
                error("Display Error: Number of input functions does not equal the grid size.")
            end

            obj.Rows = rows;
            obj.Cols = cols;
            obj.DisplayFcns = varargin;

            obj.FrameRate = 15;
            obj.isOpen = false;

        end

        function open(obj)
            if ~obj.isOpen

                obj.Figure = figure();

                obj.initializeDisplay()

                obj.DisplayTimer = timer('TimerFcn', {@(~,~) updateDisplay(obj)}, ...
                    'ExecutionMode', 'fixedRate', 'Period', 1/obj.FrameRate);
                start(obj.DisplayTimer)

                obj.Figure.CloseRequestFcn = @(~,~) close(obj);
                obj.isOpen = true;
                fprintf("RC Display opened.\n")
            else
                fprintf("RC Display is already open.\n")
            end
        end

        function close(obj)
            if obj.isOpen

                stop(obj.DisplayTimer)
                delete(obj.DisplayTimer)
                obj.DisplayTimer = [];

                delete(obj.Figure)

                fprintf("RC Display closed.\n")
                obj.isOpen = false;
            else
                fprintf("RC Display is already closed.\n")
            end
        end

        function initializeDisplay(obj)
            obj.DisplayPlotData = cell(1, obj.Rows*obj.Cols);
            for r = 1:obj.Rows
                for c = 1:obj.Cols
                    i = (r - 1)*obj.Cols + c;
                    subplot(r, c, i)
                    obj.DisplayPlotData{i} = obj.DisplayFcns{i}(...
                        obj.RC, obj.Figure, []);
                end
            end
        end

        function updateDisplay(obj)
            for r = 1:obj.Rows
                for c = 1:obj.Cols
                    i = (r - 1)*obj.Cols + c;
                    obj.DisplayPlotData{i} = obj.DisplayFcns{i}(...
                        obj.RC, obj.Figure, obj.DisplayPlotData{i});
                end
            end
        end

    end
end

