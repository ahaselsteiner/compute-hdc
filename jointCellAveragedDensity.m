function fbarjoint = jointCellAveragedDensity(PM, gridCenterPoints)
%JOINTCELLAVERARAGEDPDF returns the cell-averaged joint probability density
%   PM              probabilistic model, in case it is model based on the 
%                   conditonal modeling approach (modelType='CMA') the 
%                   struct contains the following fields:
%                       .distribution - string, e.g. 'weibull', 'lognormal'
%                       .isConditional - boolean array for each parameter, e.g. [1 1 1]
%                       .coeff - double array or function array, e.g. [2.3, 1.7, 0.2]
%   gridCenterPoints       grid center locations; formatted as cell,
%                          thus gridCenterPoints{1} contains the vector
%                          for the first variable / dimension
%
%   Currently supports up to 4 dimensions
MIN_PROB_IN_DOMAIN = 1 - (1/(1*365.25*24/6));

p = length(PM.labels); % number of dimensions

if p>4
    disp('Error: Only up to 4 dimensions are supported')
    return
end

sizeGridCenterPoints = zeros(length(gridCenterPoints), 1);
for i = 1:length(gridCenterPoints)
  sizeGridCenterPoints(i) = length(gridCenterPoints{i});
end

if PM.modelType == 'CMA'
    fbarjoint = jointCellAveragedDensityCMA(PM, gridCenterPoints);
elseif PM.modelType == 'KDE'
    fbarjoint = jointCellAveragedDensityKDE(PM);
    if min(fbarjoint(:)) < 0
        disp('Minimum value of fbarjoint (due to ill defined cdf?!):')
        min(fbarjoint(:))
    end
else
    msg = ['An error occurred. Your probabilistic model must either be of' ...
    'type "CMA" or of type "KDE". Check the field "modelType".'];
    error(msg)
end

% Check if enough probability is within the computational domain.
p = length(PM.labels);
cellSize = 1;
dx = zeros(p,1);
for i = 1:p
    dx(i) = gridCenterPoints{i}(2) - gridCenterPoints{i}(1);
    cellSize = cellSize * dx(i);
end
probability_in_domain = sum(fbarjoint(:)) * cellSize;
if (probability_in_domain < MIN_PROB_IN_DOMAIN)
    msg = ['Error. Too little probability within your computational ' ...
        'domain. Your computational domain contains ' num2str(probability_in_domain) ...
        ' but the required minimum is set to MIN_PROB_IN_DOMAIN=' num2str(MIN_PROB_IN_DOMAIN) ...
        '. Consider enlarging the computational domain.'];
    error(msg);
end


% Author: Andras F. Haselsteiner
