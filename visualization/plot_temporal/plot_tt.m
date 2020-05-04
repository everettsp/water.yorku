function ph = plot_tt(tt,varargin)
% plot timetable
% wrapper for timetabel input to plot()

    assert(istimetable(tt),'input must be timetable')
    
    for i2 = 1:width(tt)
        ph = plot(tt(:,i2).Properties.RowTimes,tt(:,i2).Variables,varargin{:},'DisplayName',tt.Properties.VariableNames{i2});
    end
    
    ah = gca();
    
    if numel(unique(tt.Properties.VariableUnits)) == 1
        ah.YLabel.String = ['[',tt.Properties.VariableUnits{1},']'];
    end
    ah.XLabel.String = ['datetime',' ','[',ah.XTick(1).Format,']'];
end