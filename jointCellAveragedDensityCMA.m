function fbarjoint = jointCellAveragedDensityCMA(ProbModel, gridCenterPoints)
%JOINTCELLAVERAGEDDENSITYCMA returns the cell-averaged joint probability 
%density
%   PM              probabilistic model based on the conditonal modeling 
%                   approach (modelType='CMA'). It is a struct and 
%                   contains the following fields:
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

% --- dimension 1 ---
currentDim = 1;
ProbModelCD = ProbModel; % probabilistic model of the current dimension
ProbModelCD.distribution = ProbModel.distributions{currentDim};
ProbModelCD.coeff = ProbModel.coeffs{currentDim};
ProbModelCD.isConditional = ProbModel.isConditionals{currentDim};
fbarxj{1} = marginalCellAveragedPdf(ProbModelCD, gridCenterPoints{1}');
fbarxj{1} = repmat(fbarxj{1}, [1 sizeGridCenterPoints(2:end)']);

% --- dimension 2 ---
currentDim = 2;
ProbModelCD = ProbModel;
ProbModelCD.distribution = ProbModel.distributions{currentDim};
ProbModelCD.coeff = ProbModel.coeffs{currentDim};
ProbModelCD.isConditional = ProbModel.isConditionals{currentDim};
for i = 1:length(gridCenterPoints{1}) 
    fbarxj{2}(i,:) = marginalCellAveragedPdf(ProbModelCD, ...
        gridCenterPoints{2}', gridCenterPoints{1}(i));
end
if (p>=3)
    fbarxj{2} = repmat(fbarxj{2}, [1 1 sizeGridCenterPoints(3:end)']);
end

% --- dimension 3 ---
if (p>=3)
    currentDim = 3;
    ProbModelCD = ProbModel;
    ProbModelCD.distribution = ProbModel.distributions{currentDim};
    ProbModelCD.coeff = ProbModel.coeffs{currentDim};
    ProbModelCD.isConditional = ProbModel.isConditionals{currentDim};
    for i = 1:length(gridCenterPoints{1})
        for j = 1:length(gridCenterPoints{2}) 
            fbarxj{3}(i,j,:) = marginalCellAveragedPdf(ProbModelCD, ...
                gridCenterPoints{3}', [gridCenterPoints{1}(i); ...
                gridCenterPoints{2}(j)]);
        end
    end
end
if (p>=4)
    fbarxj{3} = repmat(fbarxj{3}, [1 1 1 sizeGridCenterPoints(4:end)']);
end

% --- dimension 4 ---
if (p>=4)
    currentDim = 4;
    ProbModelCD = ProbModel;
    ProbModelCD.distribution = ProbModel.distributions{currentDim};
    ProbModelCD.coeff = ProbModel.coeffs{currentDim};
    ProbModelCD.isConditional = ProbModel.isConditionals{currentDim};
    for i = 1:length(gridCenterPoints{1})
        for j = 1:length(gridCenterPoints{2}) 
            for k = 1:length(gridCenterPoints{3}) 
                fbarxj{4}(i,j,k,:) = marginalCellAveragedPdf(ProbModelCD, ...
                    gridCenterPoints{4}', [gridCenterPoints{1}(i); ...
                    gridCenterPoints{2}(j); gridCenterPoints{3}(k)]);
            end
        end
    end
end

fbarjoint = ones(sizeGridCenterPoints');
for i = 1:length(gridCenterPoints)
    fbarjoint = fbarjoint .* fbarxj{i};
end

% Author: Andreas F. Haselsteiner
