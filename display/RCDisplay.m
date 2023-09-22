classdef RCDisplay < handle

    properties

        RC

        Rows
        Cols

        Figure
        isOpen

        NumDisplays
        DisplayRate
        DisplayTimer
        DisplayFcns
        DisplayData

        NumAttachments
        AttachmentRate
        AttachmentTimer
        AttachmentFcns
        AttachmentData

    end

    methods
        function obj = RCDisplay(RC, rows, cols, displays, attachments)
            obj.RC = RC;

            obj.Rows = rows;
            obj.Cols = cols;

            obj.NumDisplays = numel(displays);
            obj.DisplayRate = 10;
            obj.DisplayFcns = displays;

            obj.NumAttachments = numel(attachments);
            obj.AttachmentRate = 20;
            obj.AttachmentFcns = attachments;

            if (rows*cols ~= obj.NumDisplays)
                error("Display Error: Number of displays does not equal the subplot size.")
            end

            obj.isOpen = false;

        end

        function open(obj)
            if ~obj.isOpen

                obj.Figure = figure();

                obj.DisplayData = {};
                for d = 1:obj.NumDisplays
                    obj.DisplayData{d} = [];
                end

                obj.AttachmentData = {};
                for a = 1:obj.NumAttachments
                    obj.AttachmentData{a} = [];
                end

                obj.DisplayTimer = timer('TimerFcn', {@(~,~) updateDisplays(obj)}, ...
                    'ExecutionMode', 'fixedRate', 'Period', 1/obj.DisplayRate);
                start(obj.DisplayTimer)

                obj.AttachmentTimer = timer('TimerFcn', {@(~,~) updateAttachments(obj)}, ...
                    'ExecutionMode', 'fixedRate', 'Period', 1/obj.AttachmentRate);
                start(obj.AttachmentTimer)

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

                stop(obj.AttachmentTimer)
                delete(obj.AttachmentTimer)
                obj.AttachmentTimer = [];

                delete(obj.Figure)

                fprintf("RC Display closed.\n")
                obj.isOpen = false;
            else
                fprintf("RC Display is already closed.\n")
            end
        end

        function updateDisplays(obj)
            figure(obj.Figure)
            for r = 1:obj.Rows
                for c = 1:obj.Cols
                    i = (r - 1)*obj.Cols + c;
                    subplot(obj.Rows, obj.Cols, i)
                    obj.DisplayData{i} = obj.DisplayFcns{i}(...
                        obj.RC, obj, obj.DisplayData{i});
                end
            end
        end

        function updateAttachments(obj)
            for a = 1:obj.NumAttachments
                obj.AttachmentData{a} = obj.AttachmentFcns{a}(...
                    obj.RC, obj, obj.AttachmentData{a});
            end

        end
    end
    
end
