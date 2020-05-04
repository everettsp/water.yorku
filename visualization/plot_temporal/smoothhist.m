function ah = smoothhist(x,num_bins)
%     histogram(x,'Normalization','probability')
if nargin < 2
    num_bins = 10;
end
    hh = histfit(x,num_bins,'kernel');
    hh(2).YData = hh(2).YData/sum(~isnan(x));
    delete(hh(1))
    ah = hh(2);
end