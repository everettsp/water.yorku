classdef uncertainty_scatter < handle
    % copyright MIT open license
    
    properties
        MedPlot                     % median values
        MeanPlot                    % mean value
        HorizontalLines
        VerticalLines
        Percentile                  % percentile of points contained by uncertainty envelope (default 75)
    end
    
    properties (Dependent=true)
        Color               % colour of uncertainty envelope        (default auto)
        %         LineAlpha               % alpha of uncertainty envelope         (default 0.2)
        LineWidth                   % linewidth of median plot and envelope (default 1.5)
        DisplayName                 % series display name                   (default 'data')
        ShowMean                    % show mean values                      (default false)
        ShowMedian                  % show median values                    (default true)
    end
    
    methods
        function obj = uncertainty_scatter(x_data, y_data, varargin)
            args = obj.check_inputs(x_data, y_data, varargin{:});
            obj.Percentile = args.Percentile;
            
            hold('on');
            
            % plot median and mean
            x_med = median(x_data,2);
            y_med = median(y_data,2);
            x_mean = mean(x_data,2);
            y_mean = mean(y_data,2);
            
            obj.MedPlot = plot(x_med,y_med,'o');
            obj.MeanPlot = plot(x_mean,y_mean,'x');
            
            has_uncertainty = @(z) size(z,2) ~= 1;
            
            [n,~] = size(x_data);
            if has_uncertainty(x_data)
                x_uncertainty = prctile(x_data,[100-obj.Percentile,obj.Percentile],2);
                for i2 = 1:n
                    obj.HorizontalLines{i2} = plot(x_uncertainty(i2,:),[y_med(i2),y_med(i2)],'-','HandleVisibility','off');
                end
            end
            
            if has_uncertainty(y_data)
                y_uncertainty = prctile(y_data,[100-obj.Percentile,obj.Percentile],2);
                for i2 = 1:n
                    obj.VerticalLines{i2} = plot([x_med(i2),x_med(i2)],y_uncertainty(i2,:),'-','HandleVisibility','off');
                end
            end
            
            %             obj.LineAlpha = args.LineAlpha;
            obj.LineWidth = args.LineWidth;
            obj.DisplayName = args.DisplayName;
            obj.ShowMean = args.ShowMean;
            
            if not(isempty(args.Color))
                obj.Color = args.Color;
            else
                obj.Color = obj.MedPlot.Color;
            end
            
            
            if ~isempty(obj.HorizontalLines)
                obj.HorizontalLines{1}.HandleVisibility = 'on';
            elseif ~isempty(obj.VerticalLines)
                obj.VerticalLines{1}.HandleVisibility = 'on';
            end
        end
        
        function set.Color(obj, Color)
            obj.MedPlot.Color = Color;
            obj.MedPlot.MarkerEdgeColor = Color;
            obj.MedPlot.MarkerFaceColor = Color;
            
            obj.MeanPlot.Color = Color;
            obj.MeanPlot.MarkerEdgeColor = Color;
            obj.MeanPlot.MarkerFaceColor = Color;
            
            for i2 = 1:numel(obj.HorizontalLines)
                obj.HorizontalLines{i2}.Color = Color;
                obj.HorizontalLines{i2}.MarkerFaceColor = Color;
                obj.HorizontalLines{i2}.MarkerEdgeColor = Color;
            end
            
            for i2 = 1:numel(obj.VerticalLines)
                obj.VerticalLines{i2}.Color = Color;
                obj.VerticalLines{i2}.MarkerFaceColor = Color;
                obj.VerticalLines{i2}.MarkerEdgeColor = Color;
            end
        end
        
        function Color = get.Color(obj)
            Color = obj.MedPlot.Color;
        end
        
        function set.Percentile(obj, Percentile)
            obj.Percentile = Percentile;
        end
        
        function Percentile = get.Percentile(obj)
            Percentile = obj.Percentile;
        end
        
        function set.DisplayName(obj, DisplayName)
            obj.MeanPlot.DisplayName = [DisplayName,' mean'];
            obj.MedPlot.DisplayName = [DisplayName,' median'];
            
            for i2 = 1:numel(obj.HorizontalLines)
                obj.HorizontalLines{i2}.DisplayName = [DisplayName,' ',num2str(obj.Percentile),'% confidence'];
            end
            
            for i2 = 1:numel(obj.VerticalLines)
                obj.VerticalLines{i2}.DisplayName = [DisplayName,' ',num2str(obj.Percentile),'% confidence'];
            end
        end
        
        
        function set.LineWidth(obj, LineWidth)
            obj.MeanPlot.LineWidth = LineWidth;
            obj.MedPlot.LineWidth = LineWidth;
            
            for i2 = 1:numel(obj.HorizontalLines)
                obj.HorizontalLines{i2}.LineWidth = LineWidth;
            end
            
            for i2 = 1:numel(obj.VerticalLines)
                obj.VerticalLines{i2}.LineWidth = LineWidth;
            end
        end
        
        function LineWidth = get.LineWidth(obj)
            LineWidth = obj.MedPlot.LineWidth;
        end
        
        %         function set.LineAlpha(obj, EnvelopeAlpha)
        %             for i2 = 1:numel(obj.HorizontalLines)
        %                 obj.HorizontalLines{i2}.FaceAlpha = EnvelopeAlpha;
        %             end
        %             for i2 = 1:numel(obj.VerticalLines)
        %                 obj.VerticalLines{i2}.FaceAlpha = EnvelopeAlpha;
        %             end
        %         end
        %
        %         function LineAlpha = get.LineAlpha(obj)
        %             if ~isempty(obj.HorizontalLines)
        %                 LineAlpha = obj.HorizontalLines(1).LineAlpha;
        %             elseif ~isempty(obj.VerticalLines)
        %                 LineAlpha = obj.VerticalLines(1).LineAlpha;
        %             end
        %         end
        
        %
        %         function set.OutlierColor(obj, OutlierColor)
        %             obj.OutlierPlot.Color = OutlierColor;
        %         end
        %
        %         function OutlierColor = get.OutlierColor(obj)
        %             OutlierColor = obj.OutlierPlot.Color;
        %         end
        
        
        function set.ShowMean(obj, yesno)
            if yesno
                obj.MeanPlot.Visible = 'on';
            else
                obj.MeanPlot.Visible = 'off';
                obj.MeanPlot.HandleVisibility = 'off';
            end
        end
        
        function yesno = get.ShowMean(obj)
            if ~isempty(obj.MeanPlot)
                yesno = strcmp(obj.MeanPlot.Visible, 'on');
            end
        end
        
        function set.ShowMedian(obj, yesno)
            if yesno
                obj.MedPlot.Visible = 'on';
            else
                obj.MedPlot.Visible = 'off';
                obj.MedPlot.HandleVisibility = 'off';
            end
        end
        
        function yesno = get.ShowMedian(obj)
            if ~isempty(obj.MedPlot)
                yesno = strcmp(obj.MedPlot.Visible, 'on');
            end
        end
    end
    
    methods (Access=private)
        function results = check_inputs(obj, x_data, y_data, varargin)
            isscalarnumeric = @(x) (isnumeric(x) & isscalar(x));
            isscalarabove50 = @(x) (isscalarnumeric(x) & x > 50);
            p = inputParser();
            p.addRequired('x_data', @isnumeric);
            p.addRequired('y_data', @isnumeric);
            p.addParameter('Percentile', 75, isscalarabove50);
            p.addParameter('DisplayName', 'Data', @ischar);
            iscolor = @(x) (isnumeric(x) & length(x) == 3);
            p.addParameter('Color', [], iscolor);
            p.addParameter('LineWidth',1.5, isscalarnumeric)
            %             isalpha = @(x) (isnumeric(x) & isscalar(x) & x <= 1);
            %             p.addParameter('LineAlpha', 0, isalpha);
            isscalarlogical = @(x) (islogical(x) & isscalar(x));
            p.addParameter('ShowMean', false, isscalarlogical);
            p.addParameter('ShowMedian', true, isscalarlogical);
            p.parse(x_data, y_data, varargin{:});
            results = p.Results;
        end
    end
end
