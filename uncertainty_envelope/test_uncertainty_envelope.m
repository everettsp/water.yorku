% test_envelope
n = 10;
m = 100;
x = 1:0.1:n;

figure(1)
hold 'on'
eh = uncertainty_envelope.empty;

F = @(x) 100 .* sin(x + 10 * rand(1)) .* rand([m,1]) + 100 .* rand([m,1]) .^ (10 .* rand(1));
eh(1) = plot_uncertainty_envelope(F(x),x,'Percentile',60,'ShowOutliers',true);
eh(2) = plot_uncertainty_envelope(F(x),x,'Percentile',90,'ShowMean',true);
eh(3) = plot_uncertainty_envelope(F(x),x,'Percentile',55,'Color',[1 0 0]);