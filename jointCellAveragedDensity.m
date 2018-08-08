function fbarjoint = jointCellAveragedDensity(ProbModel, gridCenterPoints)
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

p = length(ProbModel.labels); % number of dimensions

if p>4
    disp('Error: Only up to 4 dimensions are supported')
    return
end

sizeGridCenterPoints = zeros(length(gridCenterPoints), 1);
for i = 1:length(gridCenterPoints)
  sizeGridCenterPoints(i) = length(gridCenterPoints{i});
end

if ProbModel.modelType == 'CMA'
    fbarjoint = jointCellAveragedDensityCMA(ProbModel, gridCenterPoints);
elseif ProbModel.modelType == 'KDE'
    fbarjoint = jointCellAveragedDensityKDE(ProbModel, gridCenterPoints)
else
    msg = ['An error occurred. Your probabilistic model must either be of' ...
    'type "CMA" or of type "KDE". Check the field "modelType".'];
    error(msg)
end


% Author: Andras F. Haselsteiner
