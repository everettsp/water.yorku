classdef uncertainty_envelope < handle
    % copyright MIT open license
    
    properties
        MedPlot                     % median values
        EnvelopePlots               % fill plot indicating the region bounded by the percentiles
        OutlierPlot                 % fill plot of the box between the quartiles
        MeanPlot                    % mean value
        Percentile                  % percentile of points contained by uncertainty envelope (default 75)
    end
    
    properties (Dependent=true)
        Color               % colour of uncertainty envelope        (default auto)
        EnvelopeAlpha               % alpha of uncertainty envelope         (default 0.2)
        LineWidth                   % linewidth of median plot and envelope (default 1.5)
        EdgeAlpha                   % edge alpha                            (default 0)
        DisplayName                 % series display name                   (default 'data')
        ShowMean                    % show mean values                      (default false)
        ShowMedian                  % show median values                    (default true)
        ShowOutliers                % show outliers                         (default false)
    end
    
    methods
        function obj = uncertainty_envelope(data, domain, varargin)
            args = obj.check_inputs(data, domain, varargin{:});
            obj.Percentile = args.Percentile;
            
            hold('on');
            
            % plot median and mean
            obj.MedPlot = plot(domain,median(data,2));
            obj.MeanPlot = plot(domain,mean(data,2),':');
            
            % find the discontinuities in the data
            data_starts = find(~any(isnan(data),2) & any(isnan([nan(1,size(data,2));data(1:end-1,:)]),2)); %lag down
            data_ends = find(~any(isnan(data),2) & any(isnan([data(2:end,:);nan(1,size(data,2))]),2)); %shit up
            
            % edge conditions
            if data_ends(1) < data_starts(1)
                data_starts = [1 data_starts];
            end
            
            if data_starts(end) > data_starts(end)
                data_ends = [data_ends height(tt)];
            end
            
            % plot continuous segments
            for i2 = 1:numel(data_starts)
                idx = data_starts(i2):data_ends(i2);
                data_bounds = prctile(data,[obj.Percentile,100-obj.Percentile],2);
                obj.EnvelopePlots{i2} = fill([domain(idx); flipud(domain(idx))],...
                    [data_bounds(idx,1); flipud(data_bounds(idx,2))],...
                    [0.5, 0.5, 0.5]);
            end
            
            % identify and plot outlier points (specify outlier detection
            % method in 'isoutlier' function below
            k2 = 1;
            outliers = [];
            for i2 = 1:size(data,1)
                ldx_outliers = isoutlier(data(i2,:));
                idx_outliers = find(ldx_outliers);
                if ~isempty(idx_outliers)
                    for i3 = 1:nnz(ldx_outliers)
                        outliers(k2,:) = [domain(i2), data(i2,idx_outliers(i3))];
                        k2 = k2 + 1;
                    end
                end
            end
            
            if ~isempty(outliers)
                obj.OutlierPlot = plot(outliers(:,1),outliers(:,2),'o','LineWidth',0.5,'MarkerSize',0.5);
            else
                obj.OutlierPlot = plot([]);
            end
            
            if not(isempty(args.Color))
                obj.Color = args.Color;
            else
                obj.Color = obj.MedPlot.Color;
            end
            
            obj.EnvelopeAlpha = args.EnvelopeAlpha;
            obj.EdgeAlpha = args.EdgeAlpha;
            obj.DisplayName = args.DisplayName;
            obj.LineWidth = args.LineWidth;
            
            obj.ShowOutliers = args.ShowOutliers;
            obj.ShowMean = args.ShowMean;
            obj.ShowMedian = args.ShowMedian;
            
            if not(isempty(args.Color))
                obj.Color = args.Color;
            else
                obj.Color = obj.MedPlot.Color;
            end
            
            for i2 = 1:numel(obj.EnvelopePlots)
                if i2 ~= 1
                    obj.EnvelopePlots{i2}.HandleVisibility = 'off';
                end
            end
            
        end
        
        function set.Color(obj, Color)
            if ~isempty(obj.MedPlot)
                obj.MedPlot.Color = Color;
                obj.MedPlot.MarkerEdgeColor = Color;
                obj.MedPlot.MarkerFaceColor = Color;
                
                obj.MeanPlot.Color = Color;
                obj.MeanPlot.MarkerEdgeColor = Color;
                obj.MeanPlot.MarkerFaceColor = Color;
                
                for i2 = 1:numel(obj.EnvelopePlots)
                    obj.EnvelopePlots{i2}.FaceColor = Color;
                    obj.EnvelopePlots{i2}.EdgeColor = Color;
                end
                
                if ~isempty(obj.OutlierPlot)
                    obj.OutlierPlot.Color = Color;
                    obj.OutlierPlot.MarkerFaceColor = Color;
                end
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
            
            if ~isempty(obj.OutlierPlot)
                obj.OutlierPlot.DisplayName = [DisplayName,' outliers'];
            end
            
            for i2 = 1:numel(obj.EnvelopePlots)
                obj.EnvelopePlots{i2}.DisplayName = [DisplayName,' ',num2str(obj.Percentile),'% confidence'];
            end
        end
        
        
        function set.LineWidth(obj, LineWidth)
            obj.MeanPlot.LineWidth = LineWidth;
            obj.MedPlot.LineWidth = LineWidth;
            for i2 = 1:numel(obj.EnvelopePlots)
                obj.EnvelopePlots{i2}.EdgeAlpha = 0;
            end
        end
        
        function LineWidth = get.LineWidth(obj)
            LineWidth = obj.MeanPlot.LineWidth;
        end
        
        function set.EnvelopeAlpha(obj, EnvelopeAlpha)
            for i2 = 1:numel(obj.EnvelopePlots)
                obj.EnvelopePlots{i2}.FaceAlpha = EnvelopeAlpha;
            end
        end
        
        function EnvelopeAlpha = get.EnvelopeAlpha(obj)
            EnvelopeAlpha = obj.EnvelopePlots(1).FaceAlpha;
        end
        
        function set.EdgeAlpha(obj, EdgeAlpha)
            for i2 = 1:numel(obj.EnvelopePlots)
                obj.EnvelopePlots{i2}.EdgeAlpha = EdgeAlpha;
            end
        end
        
        function EdgeAlpha = get.EdgeAlpha(obj)
            EdgeAlpha = obj.EnvelopePlots(1).EdgeAlpha;
        end
        
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
        
        function set.ShowOutliers(obj, yesno)
            if ~isempty(obj.OutlierPlot)
                if yesno
                    obj.OutlierPlot.Visible = 'on';
                else
                    obj.OutlierPlot.Visible = 'off';
                    obj.OutlierPlot.HandleVisibility = 'off';
                end
            end
        end
        
        function yesno = get.ShowOutliers(obj)
            if ~isempty(obj.OutlierPlot)
                yesno = strcmp(obj.OutlierPlot.Visible, 'on');
            end
        end
    end
    
    methods (Access=private)
        function results = check_inputs(obj, data, domain, varargin)
            isscalarnumeric = @(x) (isnumeric(x) & isscalar(x));
            isscalarabove50 = @(x) (isscalarnumeric(x) & x > 50);
            p = inputParser();
            p.addRequired('Data', @isnumeric);
            isdomain = @(x) (isdatetime(x) | isnumeric(x));
            p.addRequired('Domain', isdomain);
            p.addParameter('Percentile', 75, isscalarabove50);
            p.addParameter('DisplayName', 'Data', @ischar);
            iscolor = @(x) (isnumeric(x) & length(x) == 3);
            p.addParameter('Color', [], iscolor);
            p.addParameter('LineWidth',1.5, isscalarnumeric)
            isalpha = @(x) (isnumeric(x) & isscalar(x) & x <= 1);
            p.addParameter('EnvelopeAlpha', 0.2, isalpha);
            p.addParameter('EdgeAlpha', 0, isalpha);
            isscalarlogical = @(x) (islogical(x) & isscalar(x));
            p.addParameter('ShowOutliers', false, isscalarlogical);
            p.addParameter('ShowMean', false, isscalarlogical);
            p.addParameter('ShowMedian', true, isscalarlogical);
            p.parse(data, domain, varargin{:});
            results = p.Results;
        end
    end
end
