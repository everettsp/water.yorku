% test_envelope
% input data should be formatted such that samples (x-axis) are rows and
% ensemble members (uncertain component) are columns. The script will
% auto-adjust if x and F(x) values are input.
% see 'uncertainty_envelope' file for input details

n = 10;
m = 100;
x = 1:0.1:n;

figure('Name','uncertainty envelope example')
hold 'on'
eh = uncertainty_envelope.empty;
F = @(x) 100 .* sin(x + 10 * rand(1)) .* rand([m,1]) + 100 .* rand([m,1]) .^ (10 .* rand(1));

eh(1) = plot_ue(x,F(x),'Percentile',60,'ShowOutliers',true);

eh(2) = plot_ue(x,F(x),'Percentile',90,'ShowMean',true);

eh(3) = plot_ue(x,F(x),'Percentile',95,'Color',[1 0 0]);