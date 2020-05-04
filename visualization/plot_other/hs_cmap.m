function colmat = hs_cmap(x1,x2,varargin)
% function creates a colour matrix [n,3] for biaviate data [n,2]
%
% input arguments
% smooth            true (kernel density) or false (histogram)
% n_pts             evaluation points (kernel density) or number of bins (histogram)
% args_histogram	additional inputs for histogram functions
% colormap          rgb colour gradient of size [i,3];

if size(x1,1) == 2 && ischar(x2) % if data is input [n,2], seperate into x1 and x2
    varargin(2:(end+1)) = varargin(1:end);
    varargin(1) = x2;
    x2 = x1(:,2);
    x1 = x1(:,1);
end

par = inputParser;
par.KeepUnmatched = true;

addParameter(par,'smooth',true,@islogical)          % kernel smooth (true) or histogram (false)
addParameter(par,'n_pts',100,@isscalar)             % number of points for ksdensity
addParameter(par,'args_extra',{},@iscell)           % additional input arguments for kernel or histogram function
is_colgrad = @(x) isnumeric(x) & size(x,2) == 3;
addParameter(par,'colormap',parula,is_colgrad)      % colourmap [n,3] matrix

parse(par,varargin{:})
make_smooth = par.Results.smooth;
n_pts = par.Results.n_pts;
args_extra = par.Results.args_extra;
colgrad = par.Results.colormap;

idx = ~(isnan(x1) | isnan(x2));
x1 = x1(idx);
x2 = x2(idx);
clear idx

n = numel(x1);

if make_smooth
    % if ks smooth, get probability density estimates
    % scale the bivariate mesh slightly beyond the range of input values
    % (+/-) ptspace_scale * stdeviation
    
    ptspace_scale = 1;
    pts1_temp = linspace(min(x1) - std(x1) * ptspace_scale,max(x1) + std(x1) * ptspace_scale, n_pts);
    pts1 = reshape(repmat(pts1_temp,[n_pts,1]), [n_pts * n_pts, 1]);
    pts2_temp = linspace(min(x2) + std(x1) * ptspace_scale,max(x2) + std(x1) * ptspace_scale, n_pts);
    pts2 = repmat(pts2_temp',[n_pts,1]);
    pts = [pts1,pts2];
    clear vars pts1_temp pts1 pts2_temp pts2
    
    if ~isempty(args_extra)
        [ks_freq, ~] = ksdensity([x1,x2],pts,args_extra);
    else
        [ks_freq, ~] = ksdensity([x1,x2],pts);
    end
    n_rows = numel(unique(pts(:,1)));
    n_cols = length(pts) ./ n_rows;
    freq = reshape(ks_freq, [n_rows,n_cols])';
    bins1 = unique(pts(:, 1)');
    bins2 = unique(pts(:, 2)');
    
else
    % if histogram, get bins
    if ~isempty(args_extra)
        [freq,c] = hist3([x1,x2],args_extra);
    else
        [freq,c] = hist3([x1,x2]);
    end
    bins1 = c{1};
    bins2 = c{2};
end

% normalize the bins between 0 and 1
freq_min = min(min(freq));
bins_norm = (freq - freq_min) / max(max(freq - freq_min));
clear bins_min

% group each datapoint to nearest kernel point/histo bin
% get the corresponding bin based on the minimum absolute difference
% between datapoint and kernel point/histo bin
b1 = abs(x1 - repmat(bins1, [n 1]));
[~, freq_idx1] = min(b1,[], 2);
b2 = abs(x2 - repmat(bins2, [n 1]));
[~, freq_idx2] = min(b2,[], 2);

% lookup colour index for each datapoint
freq_colgrad_inds = get_colvals(bins_norm,colgrad);

col_idx = nan(n, 1);
for i2 = 1:n
    col_idx(i2) = freq_colgrad_inds(freq_idx1(i2), freq_idx2(i2));
end

colmat = colgrad(col_idx,:);

function colgrad_inds = get_colvals(data_normalized,colgrad)
    % get colour indices based on normalized data
    num_colors = size(colgrad, 1);
    precision_step = 1 / num_colors;
    colgrad_inds = round((data_normalized + precision_step) * ((1 ./ precision_step) ./ (1 + precision_step)));
end
end