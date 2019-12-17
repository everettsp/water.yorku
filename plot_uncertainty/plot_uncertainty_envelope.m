function ueh = plot_uncertainty_envelope(data,domain,varargin)
if exist('domain','var') && ischar(domain)
    varargin{end+1} = '';
    varargin(2:(end)) = varargin(1:(end-1));
    varargin{1} = domain;
    has_xvals = false;
    clear domain
elseif exist('domain','var')
    has_xvals = true;
else
    has_xvals = false;
end

if istimetable(data)
    if ~has_xvals
        domain = data.Properties.RowTimes;
    end
    data = data.Variables;
    
elseif ismatrix(data)
    if ~has_xvals
        n = size(data,1);
        domain = 1:n;
    end
    
    if has_xvals
        if size(domain,1) == 1
            domain = domain';
        end
        
        if ~any(numel(domain) == size(data)) %if number of x vals not equal to either dimension, error
            error('x dimensions are not consistent with data dimensions')
        elseif find(numel(domain) == size(data)) == 2    %if number of samples == number of columns, transpose
            data = data';
        end
        
    end
end

ueh = uncertainty_envelope(data,domain,varargin{:});

end
