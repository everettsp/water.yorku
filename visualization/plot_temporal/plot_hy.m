function bh = plot_hy(tt,varargin)
% plot hyetograph
% wrapper for a bar graph with a reverse right y-axis

ah = gca();
yyaxis right
ah.YColor = 'black';
assert(istimetable(tt),'input must be timetable')
for i2 = 1:width(tt)
    bh = bar(tt(:,i2).Properties.RowTimes,tt(:,i2).Variables,varargin{:},'DisplayName',tt.Properties.VariableNames{i2});
end
ah.YDir = 'reverse';

set(ah,'YColor','black');


ylim_default = ylim;

ylim(ylim_default .* [1,3])

if numel(unique(tt.Properties.VariableUnits)) == 1
    ah.YLabel.String = ['[',tt.Properties.VariableUnits{1},']'];
end
ah.XLabel.String = ['datetime',' ','[',ah.XTick(1).Format,']'];

yyaxis left
ah.YColor = 'black';
end

